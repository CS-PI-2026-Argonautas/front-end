import 'package:frontend/pages/product_registration.dart';
import 'package:flutter/material.dart';

import 'package:frontend/pages/password_recovery/user_information.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductRegistration(),
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 64, 126, 207),
        ),
      ),
    );
  }
}



