import 'package:flutter/material.dart';
import 'package:frontend/pages/product_form.dart';
import 'package:frontend/pages/product_header.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class ProductRegistration extends StatelessWidget {
  const ProductRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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

                  const SizedBox(height: 20),

                  ProductForm(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onSave: () {},
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
