import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Widget child;

  const FormCard({
    super.key,
    required this.formKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Form(
          key: formKey,
          child: child,
        ),
      ),
    );
  }
}