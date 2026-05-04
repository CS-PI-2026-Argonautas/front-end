import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_Corlors;

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_Corlors.colorScheme.surface,

      appBar: AppBar(title: const Text("Dashboard")),

      body: SafeArea(
        child: Column(children: const [Text("Conteúdo da Dashboard")]),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: custom_Corlors.colorScheme.primary,
        selectedItemColor: custom_Corlors.colorScheme.onTertiary,
        unselectedItemColor: Colors.white,

        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Clientes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.scale_outlined),
            label: "Peças",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: "Ordens",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Início",
          ),
        ],
      ),
    );
  }
}
