import 'package:flutter/material.dart';

class ShowDeleteClientSnackbar extends SnackBar {
  ShowDeleteClientSnackbar({
    super.key,
    required Color color,
    required VoidCallback onPressed,
    required Duration duration,
  }) : super(
         backgroundColor: color,
         behavior: SnackBarBehavior.floating,
         margin: const EdgeInsets.all(16),
         duration: duration,
         showCloseIcon: true,
         content: Row(
           children: [
             const Icon(Icons.check_circle, color: Colors.white),
             const SizedBox(width: 6),
             const Expanded(
               child: Text(
                 'Cliente foi removido com sucesso!',
                 style: TextStyle(color: Colors.white),
               ),
             ),
             TextButton(
               onPressed: onPressed,
               child: const Text(
                 'DESFAZER',
                 style: TextStyle(color: Colors.white),
               ),
             ),
           ],
         ),
       );
}
