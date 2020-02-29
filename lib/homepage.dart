import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_client_app/constant.dart';
import 'package:lawyer_client_app/request_page.dart';

import 'Chat_list.dart';
import 'Profile_Setting.dart';
import 'client_session_page.dart';

class ClientHomePage extends StatefulWidget {
  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {

  String mName= '';


  @override
  void initState()  {
  getData();
    super.initState();
  }

  Widget cards(image, title) {
    return GestureDetector(
      onTap: (){
        switch (title){
          case "My Session":
            Navigator.push(context, MaterialPageRoute(builder: (context) => Session_Page()));
            break;
          case "My Request":
            Navigator.push(context, MaterialPageRoute(builder: (context) => Request_Page()));
            break;
          case "Profile":
            Navigator.push(context, MaterialPageRoute(builder: (context) => Profile_Setting()));
            break;
          case "Chat":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatList()));
            break;
        }

      },
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0,
            ),
          ],
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Image.asset(
                image,
                height: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Constant.appColor)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70.withOpacity(0.9),
      body: SafeArea(
          child: Stack(
            children: <Widget>[
            Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Constant.appColor,
            ),
            width: double.infinity,
          ),
          Container(
            margin: EdgeInsets.only(left: 90, bottom: 20),
            width: 299,
            height: 279,
            decoration: BoxDecoration(
                color: Constant.appColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(160),
                    bottomLeft: Radius.circular(290),
                    bottomRight: Radius.circular(160),
                    topRight: Radius.circular(10))),
          ),
          CustomScrollView(
              slivers: <Widget>[
          SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.all(35.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text("Hello",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          Text(mName,
          style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Colors.white)),
      SizedBox(
        height: 40,
      ),
      ],
    ),
    ),
    ),
    SliverPadding(
    padding: const EdgeInsets.all(26.0),
    sliver: SliverGrid.count(
    crossAxisCount: 2,
    mainAxisSpacing: 30,
    crossAxisSpacing: 10,
    children: <Widget>[
    cards('images/wallet2.png', 'My Request'),
    cards('images/wallet3.png', 'My Session'),
    cards('images/wallet3.png', 'Chat'),
    cards(
    'images/wallet2.png', 'Profile'),
    ],
    ),
    ),
    ],
    ),
    ],
    ),
    ));
  }

  void getData() async {
    DocumentSnapshot mRef = await Firestore.instance.collection("Lawyers").document((await FirebaseAuth.instance.currentUser()).uid).get();
    setState(() {
      mName= mRef['username'];

    });
  }
  }


