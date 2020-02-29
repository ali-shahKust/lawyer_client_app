import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_client_app/constant.dart';

import 'client_chat_page.dart';
import 'models/message.dart';

class ChatList extends StatefulWidget {
  String receiverUid;

  ChatList(this.receiverUid,{Key key}) : super(key: key);
  static final String path = "lib/src/pages/lists/list2.dart";

  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String _senderuid;
  CollectionReference _collectionReference;
  String userIdKey = '';
  final primary = Constant.appColor;
  final secondary = Constant.appColor;
  final databaseReference = Firestore.instance;
  DocumentSnapshot infoSnap;
  String dId = '';

  DocumentSnapshot mRef;
  Message _message;
  final List<DocumentSnapshot> LawyerList = [
  ];
  final List<DocumentSnapshot>infoList = [];

  @override
  void initState() {
    // TODO: implement initState
    getData();
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 145),
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: LawyerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index);
                    }),
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Text('Chat List',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 200,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: secondary),
              image: DecorationImage(
                  image: NetworkImage(infoList[index]['user_dp']),
                  fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  infoList[index]['username'],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.merge_type,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),

                Row(
                  children: <Widget>[
                    Icon(
                      Icons.description,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                        infoList[index]['description'],

                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Constant.appColor),
                      child: FlatButton(
                        child: Text(
                          "Start Session",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) =>
                              ChatScreen(
//                              name: LawyerList[index].data['username'],
//                              photoUrl: LawyerList[index].data['user_dp'],
//                              receiverUid:
//                              LawyerList[index].data['client_uid']
                              )));
                        },
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  void getData() async {
    try {
      Firestore.instance
          .collection('messages')
          .document(_senderuid)
          .collection(widget.receiverUid);

      print(
          Firestore.instance
              .collection('messages')
              .document(_senderuid)
              .collection(widget.receiverUid));
    }
    catch(e){

    }

  }

  void getUserDetails() async {
//    infoSnap = await Firestore.instance.collection("Users").document(userIdKey).get();
//    LawyerList.add(infoSnap);
//
//    databaseReference
//        .collection("Users").where(mRef.documentID, isEqualTo: userIdKey)
//        .getDocuments()
//        .then((QuerySnapshot snapshot) {
//      snapshot.documents.forEach((f) => infoList.add(f));
//
//      setState(() {});
//    });
//
//  }

  }
}
