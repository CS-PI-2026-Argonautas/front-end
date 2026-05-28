import 'package:flutter/material.dart';
import 'package:frontend/pages/create-login-account/create_login_acccount.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CreateLoginAccount(),
      ),
    );
  }
}