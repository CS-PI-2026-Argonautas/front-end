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
              _buildLabel(
                'Cliente *',
                colors,
                onAdd: () {},
                addLabel: 'Adicionar cliente',
              ),
              const SizedBox(height: 24),
              _buildLabel(
                'Endereço *',
                colors,
                onAdd: () {},
                addLabel: 'Adicionar Endereço',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(
    String text,
    ColorScheme colors, {
    VoidCallback? onAdd,
    String addLabel = 'Adicionar',
  }) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (onAdd != null)
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: Text(addLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E9E5F),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }
}
