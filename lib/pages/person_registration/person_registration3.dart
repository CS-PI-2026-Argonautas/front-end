import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Necessário adicionar ao pubspec.yaml

class PersonRegistration3 extends StatefulWidget {
  const PersonRegistration3({super.key});

  @override
  State<PersonRegistration3> createState() => _PersonRegistration3State();
}

class _PersonRegistration3State extends State<PersonRegistration3> {
  final _formKey = GlobalKey<FormState>();

  final _phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back), 
                          onPressed: () => Navigator.pop(context)
                        ),
                        const Text(
                          "Cadastro", 
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ),
                        IconButton(
                          icon: const Icon(Icons.close), 
                          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst)
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _buildFieldLabel(Icons.phone_outlined, "Contato"),
                    TextFormField(
                      decoration: _inputStyle("(44) 98765-4321"),
                      inputFormatters: [_phoneFormatter],
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o telefone';
                        }
                        if (value.length < 15) {
                          return 'Telefone incompleto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    _buildFieldLabel(Icons.email_outlined, "Email"),
                    TextFormField(
                      decoration: _inputStyle("exemplo@email.com"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o email';
                        }
                        // Regex simples para validação de email[cite: 10]
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'Informe um email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    _buildFieldLabel(Icons.contact_phone_outlined, "Contato adicional"),
                    TextFormField(
                      decoration: _inputStyle("Nome do contato"),
                      maxLength: 50,
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null, // Oculta contador visual
                    ),
                    const SizedBox(height: 15),

                    // Observação com limite de 255 caracteres e expansível[cite: 10]
                    _buildFieldLabel(Icons.comment_outlined, "Observação"),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: null, 
                      minLines: 1,    
                      maxLength: 255,
                      keyboardType: TextInputType.multiline,
                      decoration: _inputStyle("Digite as observações aqui..."),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: custom_colors.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () { 
                          if (_formKey.currentState!.validate()) {
                          }
                        },
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

  InputDecoration _inputStyle(String hint) {
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: custom_colors.colorScheme.error, width: 2),
      ),
    );
  }
}