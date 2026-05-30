import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class BuildFieldLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const BuildFieldLabel({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}

