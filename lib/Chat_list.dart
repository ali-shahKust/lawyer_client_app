import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_client_app/constant.dart';
import 'package:lawyer_client_app/main.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import 'client_chat_page.dart';

class Chat_List extends StatefulWidget {
  Chat_List({Key key}) : super(key: key);
  static final String path = "lib/src/pages/lists/list2.dart";

  _Chat_ListState createState() => _Chat_ListState();
}

class _Chat_ListState extends State<Chat_List> {

  //variables
  final primary =Constant.appColor;
  final secondary = Constant.appColor;
  final databaseReference = Firestore.instance;
  String dId='';
  bool isChecked;

  final List<DocumentSnapshot> LawyerList = [
  ];

  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    print('abc');
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 145),
                height: MediaQuery.of(context).size.height,
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
                    child: Text('Chats',
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
//List Of Chats
  Widget buildList(BuildContext context, int index) {
    isChecked =LawyerList[index].data['chat_status'];
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
                  image: NetworkImage(LawyerList[index]['user_dp']),
                  fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  LawyerList[index]['username'],
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
                    Flexible(
                      child: Text(LawyerList[index]['description'],
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3)),
                    ),
                  ],
                ),
                Padding(
                    padding:EdgeInsets.only(top: 35),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Constant.appColor),
                      child: Row( 
                        children: <Widget>[
                          Expanded(

                            // ignore: unrelated_type_equality_checks
                            child: isChecked== false?Container():FlatButton(
                              child: Text(
                                "Start Chat",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder:(context) => ChatScreen(
                                    name: LawyerList[index].data['username'],
                                    photoUrl: LawyerList[index].data['user_dp'],
                                    receiverUid:
                                    LawyerList[index].data['client_uid']
                                )));
                              },
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded( 
                            child: LiteRollingSwitch(
                              //initial value
                              value: isChecked,
                              textOn: 'Active',
                              textOff: 'InActive',
                              colorOn: Colors.greenAccent[700],
                              colorOff: Colors.redAccent[700],
                              textSize: 8.0,
                              onChanged: (bool state) {

                                createRecord(state,LawyerList[index].documentID);
                                isChecked = state;
                                LawyerList[index].data['chat_status'] = isChecked;

                                print('Current State Of is checked is $isChecked');
                              },
                            ),
                          ),
                        ],
                      ),

                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
//Getting data From Firebase
  void getData() async {
    String uId = (await FirebaseAuth.instance.currentUser()).uid;
    databaseReference
        .collection("start_chat").where('lawyer_uid', isEqualTo: uId)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        LawyerList.add(f);
    setState(() {

    });
      });

    });
  }

  //Change Status
  void createRecord(bool state, String documentID) async {
    Map mMap = new Map<String, Object>();
    mMap['chat_status']= state;
    String mUid = (await FirebaseAuth.instance.currentUser()).uid;
    //Firestore
    await databaseReference.collection("start_chat").document(documentID).setData(
    mMap, merge: true);
    setState(() {

    });
  }

}
