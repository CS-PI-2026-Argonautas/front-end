import 'package:flutter/material.dart';
import 'package:frontend/pages/PersonRegistration2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonRegistration2(),
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 64, 126, 207),
        ),
      ),
    );
  }
}
