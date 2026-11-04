import 'package:flutter/material.dart';

class ShowConfirmEmailDialog extends StatelessWidget {
  final String email;
  const ShowConfirmEmailDialog({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar e-mail'),
      content: Text('O link de redefinição será enviado para $email.'),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context, false),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.black,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(Icons.edit_outlined, color: Colors.black),
              Text('Corrigir'),
            ],
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(Icons.send, color: Colors.white),
              Text('Enviar'),
            ],
          ),
        ),
      ],
    );
  }
}
