import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onCancel;
  final VoidCallback onCadastrar;
  final dynamic colors; 

  const ActionButtons({
    super.key,
    required this.formKey,
    required this.onCancel,
    required this.onCadastrar,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Cancelar
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.onSurface,
              side: BorderSide(color: colors.surfaceContainerHigh),
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
                onCadastrar();
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
            label: const Text(
              "Cadastrar",
              style: TextStyle(
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