import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

// use este componente para criar os botoes de salvar e cancelar de formularios, passando as funcoes onSave e onCancel e podendo alterar textos e icones
class FormActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String saveLabel;
  final String cancelLabel;
  final IconData saveIcon;
  final IconData cancelIcon;

  const FormActionButtons({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.saveLabel = "Salvar",
    this.cancelLabel = "Cancelar",
    this.saveIcon = Icons.save_outlined,
    this.cancelIcon = Icons.cancel_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Row(
      spacing: 6,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: colors.primary,
              foregroundColor: colors.onSecondary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: Icon(saveIcon),
            label: Text(
              saveLabel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.onSurface,
              side: BorderSide(
                color: colors.surfaceContainerHigh,
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: Icon(cancelIcon),
            label: Text(cancelLabel),
          ),
        ),
      ],
    );
  }
}