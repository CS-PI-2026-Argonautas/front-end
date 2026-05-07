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
    
    final colors = custom_Colors.colorScheme;

    return Container(
      decoration: BoxDecoration(
        
        gradient: LinearGradient(
          colors: [colors.primary, colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
       
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
       
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        selectedItemColor: colors.onTertiary,
        unselectedItemColor: Colors.white.withOpacity(0.8),
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
      ),
    );
  }
}