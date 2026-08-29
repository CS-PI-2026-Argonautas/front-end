import 'package:flutter/material.dart';
import 'package:frontend/pages/authentication.dart';
import 'package:frontend/pages/os/tabbar/tabbar.dart';
import 'package:frontend/pages/password_recovery/user_information.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bernadelli Balanças',
      debugShowCheckedModeBanner: false,
      home: Authentication(),
      // home: Tabbar(serviceOrderNumber: -0001,),
      // home: UserInformation(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 64, 126, 207),
        ),
      ),
    );
  }
}
