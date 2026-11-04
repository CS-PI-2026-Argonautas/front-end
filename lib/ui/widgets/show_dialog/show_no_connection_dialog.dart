import 'package:flutter/material.dart';
import 'package:frontend/utils/connectivity/connectivity_checker.dart';

class ShowNoConnectionDialog extends StatelessWidget {
  final String message;
  final String? confirmLabel;
  final IconData confirmIcon;

  const ShowNoConnectionDialog({
    super.key,
    required this.message,
    this.confirmLabel,
    this.confirmIcon = Icons.check,
  });

  @override
  Widget build(BuildContext context) {
    final hasConfirm = confirmLabel != null;

    return AlertDialog(
      icon: const Icon(Icons.wifi_off, size: 32),
      title: const Text('Sem conexão com a internet'),
      content: Text(message),
      actions: [
        if (hasConfirm)
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
          onPressed: () => Navigator.pop(context, hasConfirm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Icon(hasConfirm ? confirmIcon : Icons.check, color: Colors.white),
              Text(confirmLabel ?? 'Entendi'),
            ],
          ),
        ),
      ],
    );
  }
}

Future<bool> ensureConnection(
  BuildContext context, {
  required String message,
}) async {
  if (await hasConnection()) return true;
  if (!context.mounted) return false;

  await showDialog<bool>(
    context: context,
    builder: (_) => ShowNoConnectionDialog(message: message),
  );
  return false;
}
