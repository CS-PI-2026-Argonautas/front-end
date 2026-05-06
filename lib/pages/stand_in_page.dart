import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:flutter/material.dart';

class StandInPage extends StatelessWidget {
  const StandInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Text(
          "Em construção",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.onSurface),
        ),
      ),
    );
  }
}