import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_Colors;
import 'package:frontend/pages/product_registration.dart';
import 'package:frontend/widgets/bottom_bar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_Colors.colorScheme.surface,

      appBar: AppBar(title: const Text("Dashboard")),

      body: SafeArea(
        child: Column(children: const [Text("Conteúdo da Dashboard")]),
      ),

      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,

        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductRegistration(),
              ),
            );
          }

          if (index == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("COLOCAR TELA DE CLIENTES")),
            );
          }

          if (index == 2) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("COLOCAR TELA DE OS")));
          }

          if (index == 3) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
