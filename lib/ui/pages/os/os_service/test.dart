import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/os/os_service/os_service.dart';
import 'package:frontend/ui/pages/os/os_service/serviceregistration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recuperação de Senha',
      debugShowCheckedModeBanner: false,
      home: ServiceRegistration(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 64, 126, 207),
        ),
      ),
    );
  }
}
