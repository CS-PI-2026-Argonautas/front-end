import 'dart:io';
import 'package:frontend/pages/authentication.dart';
import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class Menu extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Menu({superkey, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Drawer(
      width: 200,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.primary, colors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Menu",
                        style: TextStyle(
                          color: colors.onTertiary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Divider(color: Colors.white24),

                    _buildDrawerItem(
                      icon: Icons.person_outline,
                      label: "Clientes",
                      index: 0,
                      colors: colors,
                    ),

                    _buildDrawerItem(
                      icon: Icons.scale_outlined,
                      label: "Peças",
                      index: 1,
                      colors: colors,
                    ),

                    _buildDrawerItem(
                      icon: Icons.assignment_outlined,
                      label: "Ordens",
                      index: 2,
                      colors: colors,
                    ),
                    _buildDrawerItem(
                      icon: Icons.edit,
                      label: "Editar peças",
                      index: 3,
                      colors: colors,
                    ),

                    _buildDrawerItem(
                      icon: Icons.home_outlined,
                      label: "Início",
                      index: 4,
                      colors: colors,
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white24),

              ListTile(
                leading: Icon(Icons.logout, color: colors.onTertiary),
                title: Text(
                  "Sair",
                  style: TextStyle(
                    color: colors.onTertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Authentication(),
                    ),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required int index,
    required ColorScheme colors,
  }) {
    final isSelected = currentIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? colors.onTertiary
            : Colors.white.withValues(alpha: 0.8),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? colors.onTertiary
              : Colors.white.withValues(alpha: 0.8),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => onTap(index),
    );
  }
}
