import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class ClientOs extends StatefulWidget {
  final VoidCallback onNext;

  const ClientOs({super.key, required this.onNext});

  @override
  State<ClientOs> createState() => _ClientOsState();
}

class _ClientOsState extends State<ClientOs> {
  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Container(
      color: colors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Cliente *', colors),
              const SizedBox(height: 24),
              _buildLabel('Endereço *', colors),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ColorScheme colors) {
    return Text(
      text,
      style: TextStyle(
        color: colors.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
