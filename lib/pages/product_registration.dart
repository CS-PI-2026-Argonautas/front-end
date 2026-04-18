import 'package:flutter/material.dart';
import 'package:frontend/pages/product_form.dart';
import 'product_header.dart';

class ProductRegistration extends StatelessWidget {
  const ProductRegistration({super.key});

  static const Color backgroundColor = Color.fromARGB(255, 208, 217, 220);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductHeader(
                    onBack: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 24),
                  ProductForm(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onSave: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
