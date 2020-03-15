import 'dart:io';

import 'package:lawyer_client_app/full_screen_image.dart';
import 'package:lawyer_client_app/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:lawyer_client_app/pdf_view.dart';
import 'full_screen_image.dart';
import 'models/message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
class ChatScreen extends StatefulWidget {

  //Variables For Receive profile
  String name;
  String photoUrl;
  String receiverUid;

  ChatScreen({this.name, this.photoUrl, this.receiverUid});

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //Variables
  DocumentSnapshot mRef;
  Message _message;
  String timeStamp;
  var _formKey = GlobalKey<FormState>();
  var map = Map<String, dynamic>();
  CollectionReference _collectionReference;
  DocumentReference _receiverDocumentReference;
  DocumentReference _senderDocumentReference;
  DocumentReference _documentReference;
  DocumentSnapshot documentSnapshot;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _senderuid;
  var listItem;
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  StreamSubscription<DocumentSnapshot> subscription;
  File imageFile;
  StorageReference _storageReference;
  TextEditingController _messageController;
  final String path='';


  //On start this function will be called
  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();
    getUID().then((user) {
      setState(() {
        _senderuid = user.uid;
        print("sender uid : $_senderuid");
        getSenderPhotoUrl(_senderuid).then((snapshot) {
          setState(() {
            senderPhotoUrl = snapshot['user_dp'];
            senderName = snapshot['username'];
          });
        });
        getReceiverPhotoUrl(widget.receiverUid).then((snapshot) {
          setState(() {
            receiverPhotoUrl = snapshot['user_dp'];
            receiverName = snapshot['username'];
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  //Add message to database
  void addMessageToDb(Message message) async {
    print("Message : ${message.message}");
    map = message.toMap();
    Map mMap = new Map<String, Object>();
    mMap['timestamp'] = message.timestamp;
    mMap['message'] = message.message;
    mMap['senderUid'] = message.senderUid;
    mMap['receiverUid'] = message.receiverUid;
    mMap['type'] = message.type;

    print("Map : ${map}");
    Firestore.instance
        .collection("messages")
        .document(message.senderUid)
        .collection('recent_chats')
        .document(message.receiverUid)
        .setData(mMap)
        .then((myFun) {
      Firestore.instance
          .collection("messages")
          .document(message.senderUid)
          .collection('recent_chats')
          .document(message.receiverUid)
          .collection("messages")
          .add(map);
    });
    _messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Form(
          key: _formKey,
          child: _senderuid == null
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    //buildListLayout(),
                    ChatMessagesListWidget(),
                    Divider(
                      height: 20.0,
                      color: Colors.black,
                    ),
                    ChatInputWidget(),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
        ));
  }

  //Chat Input Design
  Widget ChatInputWidget() {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
              onPressed: () {
                pickImage();
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.attach_file,
                color: Colors.black,
              ),
              onPressed: () {
                pickDoc();
              },
            ),
          ),
          Flexible(
            child: TextFormField(
              validator: (String input) {
                if (input.isEmpty) {
                  return "Please enter message";
                }
              },
              controller: _messageController,
              decoration: InputDecoration(
                  hintText: "Enter message...",
                  labelText: "Message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              onFieldSubmitted: (value) {
                _messageController.text = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.white,
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  sendMessage();
                }
              },
            ),
          )
        ],
      ),
    );
  }
//Pick Image From Gallary
  Future<String> pickImage() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = selectedImage;
    });
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();

    print("URL: $url");
    uploadImageToDb(url);
    return url;
  }

  //Pic Document
  Future<String> pickDoc() async {
    File file =
        await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');

    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(file);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();

    print("URL: $url");
    uploadDocumentToDb(url);
    return url;
  }

  //Upload Image to database
  void uploadImageToDb(String downloadUrl) {
    _message = Message.withoutMessage(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        photoUrl: downloadUrl,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['photoUrl'] = _message.photoUrl;
    map['timestamp'] = Timestamp.now();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    print("Map : ${map}");
    Firestore.instance
        .collection("messages")
        .document(_message.senderUid)
        .collection('recent_chats')
        .document(_message.receiverUid)
        .setData(map)
        .then((myFun) {
      Firestore.instance
          .collection("messages")
          .document(_message.senderUid)
          .collection('recent_chats')
          .document(_message.receiverUid)
          .collection("messages")
          .add(map);
    });
  }

  //Upload Document
  void uploadDocumentToDb(String downloadUrl) {
    _message = Message.withoutMessage(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        photoUrl: downloadUrl,
        timestamp: FieldValue.serverTimestamp(),
        type: 'doc');

    var map = Map<String, dynamic>();

    map['photoUrl'] = _message.photoUrl;
    map['timestamp'] = Timestamp.now();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;

    print("Map : ${map}");
    Firestore.instance
        .collection("messages")
        .document(_message.senderUid)
        .collection('recent_chats')
        .document(_message.receiverUid)
        .setData(map)
        .then((myFun) {
      Firestore.instance
          .collection("messages")
          .document(_message.senderUid)
          .collection('recent_chats')
          .document(_message.receiverUid)
          .collection("messages")
          .add(map);
    });
  }
//Send Normal Text Message
  void sendMessage() async {
    print("Inside send message");
    var text = _messageController.text;
    print(text);
    _message = Message(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        message: text,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text');
    print(
        "receiverUid: ${widget.receiverUid} , senderUid : ${_senderuid} , message: ${text}");
    print(
        "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
    addMessageToDb(_message);
  }

  //Get user Uid
  Future<FirebaseUser> getUID() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }
//Get Sender Profile pHoto
  Future<DocumentSnapshot> getSenderPhotoUrl(String uid) {
    var senderDocumentSnapshot =
        Firestore.instance.collection('Lawyers').document(uid).get();
    return senderDocumentSnapshot;
  }

  //Get Receiver Photo
  Future<DocumentSnapshot> getReceiverPhotoUrl(String uid) {
    var receiverDocumentSnapshot =
        Firestore.instance.collection('Users').document(uid).get();
    return receiverDocumentSnapshot;
  }

  //List Of CHats
  Widget ChatMessagesListWidget() {

    print("SENDERUID : $_senderuid");
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(_senderuid)
            .collection('recent_chats')
            .document(widget.receiverUid)
            .collection('messages')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            listItem = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  chatMessageItem(snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot documentSnapshot) {
    return buildChatLayout(documentSnapshot);
  }

  Widget buildChatLayout(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: snapshot['senderUid'] == _senderuid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              snapshot['senderUid'] == _senderuid
                  ? CircleAvatar(
                      backgroundImage: senderPhotoUrl == null
                          ? AssetImage('assets/blankimage.png')
                          : NetworkImage(senderPhotoUrl),
                      radius: 20.0,
                    )
                  : CircleAvatar(
                      backgroundImage: receiverPhotoUrl == null
                          ? AssetImage('assets/blankimage.png')
                          : NetworkImage(receiverPhotoUrl),
                      radius: 20.0,
                    ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    snapshot['senderUid'] == _senderuid
                        ? new Text(
                            senderName == null ? "" : senderName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          )
                        : new Text(
                            receiverName == null ? "" : receiverName,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                    snapshot['type'] == 'text'
                        ? new Text(
                            snapshot['message'],
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0),
                          )
                        : snapshot['type'] == 'doc'
                            ? Container(
                                height: 50,
                                width: 50,
                                child: IconButton(
                                  onPressed: () {
                                    OpenFile.open(snapshot['photoUrl']);
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => Pdf_viewer(
                                              myUrl: snapshot['photoUrl'],
                                            )));
                                  },
                                  icon: Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: (() {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                                photoUrl: snapshot['photoUrl'],
                                              )));
                                }),
                                child: Hero(
                                  tag: snapshot['photoUrl'],
                                  child: FadeInImage(
                                    image: NetworkImage(snapshot['photoUrl']),
                                    placeholder:
                                        AssetImage('assets/blankimage.png'),
                                    width: 200.0,
                                    height: 200.0,
                                  ),
                                ),
                              )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
