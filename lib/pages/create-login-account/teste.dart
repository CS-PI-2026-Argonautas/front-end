import 'package:flutter/material.dart';
import 'package:frontend/pages/create-login-account/create_login_acccount.dart';
import 'package:frontend/widgets/bottom_bar.dart';

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
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 0,
          onTap: (index) {
            // Handle navigation tap
          },
        ),
      ),
    );
  }
}