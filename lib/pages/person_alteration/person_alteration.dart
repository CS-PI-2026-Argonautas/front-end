import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class PersonAlteration extends StatefulWidget {
  const PersonAlteration({super.key});

  @override
  State<PersonAlteration> createState() => _PersonAlterationState();
}

class _PersonAlterationState extends State<PersonAlteration> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_colors.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Form(
                key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const SizedBox(height: 24),
                  _buildFieldLabel(Icons.person_outline, "Nome *"),
                  TextFormField(decoration: inputStyle("Exemplo"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe o nome';
                        }
                       return null;
                      },
                  ),
                ],
              )
              ),
            ),
          ),
        ),
      ),
    );
    }
}

 Widget _buildFieldLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: custom_colors.colorScheme.primary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  InputDecoration inputStyle(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: custom_colors.colorScheme.surfaceContainer,
    errorStyle: TextStyle(
      color: custom_colors.colorScheme.error,
      fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    // Borda vermelha quando houver erro
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: custom_colors.colorScheme.error, width: 2),
    ),
  );
}
