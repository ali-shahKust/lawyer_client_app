import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lawyer_client_app/Profile_Setting.dart';
import 'package:lawyer_client_app/client_chat_page.dart';
import 'package:lawyer_client_app/client_login_page.dart';
import 'package:lawyer_client_app/client_session_page.dart';
import 'package:lawyer_client_app/homepage.dart';
import 'package:lawyer_client_app/request_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Profile_Setting(),
      ),
    );
  }
}
