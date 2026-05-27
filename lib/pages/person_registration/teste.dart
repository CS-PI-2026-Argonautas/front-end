import 'package:flutter/material.dart';
import 'package:frontend/pages/person_registration/person_registration.dart';
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
        body: PersonRegistration(),
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