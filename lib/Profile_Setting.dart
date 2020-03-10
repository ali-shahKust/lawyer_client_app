import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_client_app/client_login_page.dart';
import 'package:lawyer_client_app/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart';

import 'homepage.dart';

class Profile_Setting extends StatefulWidget {


  @override
  _Profile_SettingState createState() => _Profile_SettingState();
}

class _Profile_SettingState extends State<Profile_Setting> {

  bool isloading = true;
  String dropdownValue = 'Major';
  String mName = '';
  String mType = '';
  String mPhoneNum = '';
  String mLicenceNumber = '';
  String mYearExperience = '';
  String mDescription = '';
  DocumentSnapshot mRef;
  final _namecontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
//  final _licencecontroller = TextEditingController();
  final _majorcontroller = TextEditingController();
  final _xpcontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();
  final _feescontroller = TextEditingController();
  final databaseReference = Firestore.instance;

  final snackBar = SnackBar(content: Text('Successfully Updated!'));

  File _image;
  String _uploadedFileURL;
  String url;
  @override
  void initState() {
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if(mRef != null){
      _namecontroller.text = mRef['username'];
      _phonecontroller.text = mRef['phonenumber'];
      _majorcontroller.text = mRef['type'];
      _xpcontroller.text = mRef['year_experience'];
      _feescontroller.text = mRef['fees'];
      _descriptioncontroller.text = mRef['description'];

    }


    return Scaffold(
      backgroundColor: Colors.white,

      body: isloading ? Container() : ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 250,
                color: Constant.appColor,
              ),
              Center(
                child: Column(
                    children: <Widget>[

                      Container(
                          height: 90,
                          margin: EdgeInsets.only(top: 60),
                          child: GestureDetector(
                            onTap: () {
                              uploadPic();                            },
                            child: CircleAvatar(

                              radius: 50,
                              backgroundColor: Colors.white,

                              backgroundImage: mRef['user_dp'] == null
                                  ? AssetImage('/images/1.jpg')
                                  : NetworkImage(mRef['user_dp']),

                            ),
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        mName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        mType,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ]),
              )
            ],
          ),
          SizedBox(
            height: 15,
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
                  //  prefixText:mRef['username'] ,
                    hintText: "Name",
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
                maxLength: 10,
                controller: _phonecontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Phone Number",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.phone,
                        color: Constant.appColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),

//          Padding(
//            padding: EdgeInsets.symmetric(horizontal: 32),
//            child: Material(
//
//              elevation: 2.0,
//              borderRadius: BorderRadius.all(Radius.circular(10)),
//
//              child: Text( 'Licence# ${mRef['licencenumber']}',
//                style: TextStyle(
//
//                ),
//              )
//                 ,
////              textStyle: TextStyle(
////
////                fontSize: 28,
////                color: Colors.black,
////
////              ),
//
//            ),
//          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                controller: _majorcontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Major",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.library_books,
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
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                controller: _xpcontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Experience Year",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.event,
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
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: TextField(
                controller: _feescontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                decoration: InputDecoration(
                    hintText: "Fees Price in \$",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.attach_money,
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
                controller: _descriptioncontroller,
                onChanged: (String value) {},
                cursorColor: Constant.appColor,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: "Description",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.description,
                        color: Constant.appColor,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ), SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.shade50),
                child: FlatButton(

                  child: Row(
                    children: <Widget>[
                      Icon(Icons.library_books,
                        color: Constant.appColor,
                      ),
                      SizedBox(width: 12,),
                      Text(
                        "Lic# ${mRef['licencenumber']}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ],
                  ),

                ),
              )),
          SizedBox(height: 20,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Constant.appColor),
                child: FlatButton(

                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    createRecord();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHomePage()));
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                ),
              )),
        ],
      ),
    );
  }

  void getData() async {
    mRef = await Firestore.instance
        .collection("Lawyers")
        .document((await FirebaseAuth.instance.currentUser()).uid)
        .get();
    setState(() {
      isloading = false;
      mName = mRef['username'];
      mType = mRef['type'];
    });
  }

  void createRecord() async {
    try {
      String mUid = (await FirebaseAuth.instance.currentUser()).uid;
      //Firestore
      await databaseReference.collection("Lawyers").document(mUid).setData({
        'username': _namecontroller.text,
        'phonenumber': _phonecontroller.text,
        'year_experience': _xpcontroller.text,
        'type': _majorcontroller.text,
        'description': _descriptioncontroller.text,
        'fees':_feescontroller.text
      }, merge: true);

    }
    catch (e) {
      print(e.message);
    }
  }

  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Uri> uploadPic() async {

    //Get the file from the image picker and store it
     _image = await ImagePicker.pickImage(source: ImageSource.gallery);

     String mUid = (await FirebaseAuth.instance.currentUser()).uid;

     //Create a reference to the location you want to upload to in firebase
     StorageReference reference = _storage.ref().child("Profile/").child((await FirebaseAuth.instance.currentUser()).uid);

     //Upload the file to firebase
     StorageUploadTask uploadTask = reference.putFile(_image);
     uploadTask.onComplete.then((result) async {
       url = await result.ref.getDownloadURL();

       await databaseReference.collection("Lawyers").document(mUid).updateData({

         'user_dp': url,
       });
       setState(() {

       });
     });

  }


}
