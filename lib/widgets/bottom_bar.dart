import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_Colors;

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: custom_Colors.colorScheme.primary,
      selectedItemColor: custom_Colors.colorScheme.onTertiary,
      unselectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTap,

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
    );
  }
}
