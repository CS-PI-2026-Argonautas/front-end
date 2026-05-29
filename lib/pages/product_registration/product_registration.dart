import 'package:flutter/material.dart';
import 'package:frontend/pages/product_registration/product_form.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class ProductRegistration extends StatelessWidget {
  const ProductRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        }, title: 'Cadastro de produtos',
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ProductForm(
                      onCancel: () {
                        Navigator.pop(context);
                      },

                      onSave: () {
                        showDialog(
                          context: context,

                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),

                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 28,
                                  ),

                                  SizedBox(width: 10),

                                  Text("Envio confirmado"),
                                ],
                              ),

                              content: const Text(
                                "O produto foi enviado com sucesso.",
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },

                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
