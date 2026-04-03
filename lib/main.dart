import 'package:bernadelli_balancas/widgets/product_registration.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ProductRegistration());
  }
}
