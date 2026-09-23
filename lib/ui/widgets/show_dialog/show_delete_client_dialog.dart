import 'package:flutter/material.dart';

class ShowDeleteClientDialog extends StatelessWidget {
  final String nome;
  const ShowDeleteClientDialog({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remover Cliente'),
      content: Text('Deseja remover ${nome}?'),
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
              Icon(Icons.cancel_outlined, color: Colors.black),
              Text('Cancelar'),
            ],
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(Icons.delete, color: Colors.white),
              Text('Remover'),
            ],
          ),
        ),
      ],
    );
  }
}
