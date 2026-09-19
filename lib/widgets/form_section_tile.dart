import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class FormSectionTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const FormSectionTile({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}



