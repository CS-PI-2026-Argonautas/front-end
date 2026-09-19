import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

// usar este componente para criar titulos de secoes dentro de formularios, passando o icone e o texto desejado
class SectionLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  const SectionLabel({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Row(
      spacing: 6,
      children: [
        Icon(
          icon,
          size: 20,
          color: colors.primary,
        ),
        Text(
          text,
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