import 'package:frontend/pages/authentication.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/person_registration/teste.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
