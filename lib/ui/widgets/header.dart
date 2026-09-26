import 'package:flutter/material.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;

class Header extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final String title;

  const Header({super.key, required this.onBack, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: colors.onPrimary,
      centerTitle: true,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.5),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.primary,
              colors.tertiary,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }
}