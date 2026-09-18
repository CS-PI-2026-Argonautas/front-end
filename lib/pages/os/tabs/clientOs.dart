import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class ClientOs extends StatelessWidget {
  final VoidCallback onNext;

  const ClientOs({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(children: [Text("Cliente *"), Text("Endereço *")]),
      ),
    );
  }
}
