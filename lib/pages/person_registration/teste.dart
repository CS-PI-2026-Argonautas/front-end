import 'package:flutter/material.dart';
import 'package:frontend/pages/person_registration/person_registration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonRegistration(),
    );
  }
}