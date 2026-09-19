import 'package:flutter/material.dart';
import 'package:frontend/pages/os/tabbar/tabbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ordem de serviço',
      debugShowCheckedModeBanner: false,
      home: Tabbar(serviceOrderNumber: 1233),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 64, 126, 207),
        ),
      ),
    );
  }
}
