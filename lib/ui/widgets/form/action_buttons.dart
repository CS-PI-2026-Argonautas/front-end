import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final dynamic colors; 
  final String textoConfirmar;

  const ActionButtons({
    super.key,
    required this.formKey,
    required this.onCancel,
    required this.onSave,
    required this.colors,
    this.textoConfirmar = 'Cadastrar',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Cancelar
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
              foregroundColor: colors.onSurface,
              backgroundColor: colors.surfaceContainerLow,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.close),
            label: const Text("Cancelar"),
          ),
        ),
        
        const SizedBox(width: 14),
        
        //Cadastrar
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onSave();
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: colors.primary,
              foregroundColor: colors.onSecondary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.check_circle_outline),
            label: Text(
              textoConfirmar,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}