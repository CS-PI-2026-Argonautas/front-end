import 'package:flutter/material.dart';
import 'package:frontend/pages/client-list/client_list.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ClientList(),
      ),
    );
  }
}