import 'package:flutter/material.dart';
import 'package:frontend/fire_base/Enums/TipoPessoa.dart';

class ShowDuplicateDocumentDialog extends StatelessWidget {
  final String nomeCliente;
  final TipoPessoa tipo;

  const ShowDuplicateDocumentDialog({
    super.key,
    required this.nomeCliente,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    final rotulo = tipo.rotuloDocumento;

    return AlertDialog(
      title: Text('$rotulo já cadastrado'),
      content: Text(
        'O $rotulo informado já pertence a $nomeCliente. '
        'Deseja gravar mesmo assim?',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context, false),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.black,
          ),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Gravar mesmo assim'),
        ),
      ],
    );
  }
}
