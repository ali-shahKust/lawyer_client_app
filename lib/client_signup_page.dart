import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_client_app/client_login_page.dart';
import 'package:lawyer_client_app/constant.dart';
import 'package:lawyer_client_app/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'Profile_Setting.dart';

class Client_Signup extends StatefulWidget {
  @override
  _Client_SignupState createState() => _Client_SignupState();
}

class _Client_SignupState extends State<Client_Signup> {

  String _email, _password,_name;
  final databaseReference = Firestore.instance;
  ProgressDialog pr;
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _namecontroller = TextEditingController();
  final _liccontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Icon(
                      Icons.account_balance,
                      color: Constant.appColor,
                      size: 60,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Lawyer",
                      style: TextStyle(
                          color: Constant.appColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 30),
                    ),
                  ],
                ),
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.white, Colors.white])),
              ),
            ],
          ),
          SizedBox(
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                controller: _namecontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
                        color: Constant.appColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(

                keyboardType: TextInputType.emailAddress,
                controller: _emailcontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Constant.appColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _liccontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "License Number",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Constant.appColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                obscureText: true,
                controller: _passwordcontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.lock,
                        color: Constant.appColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Constant.appColor),
                child: FlatButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    setState(() {
                      signUp();
                    });
                  },
                ),
              )),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "I have an Account ? ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
              GestureDetector(
                child: Text("Already Sign in ",
                    style: TextStyle(
                        color: Constant.appColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        decoration: TextDecoration.underline)),
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Client_Login()));
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void signUp() async {

    _email = _emailcontroller.text;
    _password = _passwordcontroller.text;
    _name = _namecontroller.text;

    try{

      pr.style(
          message: 'Please Wait...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
      );
      await pr.show();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

      String mUid = (await FirebaseAuth.instance.currentUser()).uid;
      //Firestore
       await databaseReference.collection("Lawyers")
          .document(mUid).setData({
        'username': _namecontroller.text,
        'email': _email,
        'password': _password,
        'user_uid': mUid,
         'licencenumber': _liccontroller.text
      });
      pr.hide().then((isHidden) {
        print(isHidden);
      });

//        Firestore.instance.collection('users').document()
//            .setData({ 'user_email': _email, 'user_password': _password , 'user_name' : _name});
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile_Setting()));
    }catch(e){

      pr.hide().then((isHidden) {
        print(isHidden);
      });
      print(e.message);
    }

  }
}
