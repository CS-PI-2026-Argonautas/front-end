import 'package:flutter/material.dart';

import 'package:frontend/pages/password_recovery/user_information.dart';
import 'package:frontend/pages/person_registration.dart';
import 'package:frontend/pages/product_form.dart';
import 'package:frontend/pages/product_header.dart';
import 'package:frontend/pages/product_registration.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Recuperação de Senha',
      debugShowCheckedModeBanner: false,
      home: UserInformation(),
    );
  }
}



