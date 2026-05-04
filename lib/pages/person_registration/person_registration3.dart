import 'package:flutter/material.dart';
import 'package:frontend/style/colorScheme.dart' as custom_colors;

// Alterado para ser uma classe pública e um StatefulWidget independente
class PersonRegistration3 extends StatefulWidget {
  const PersonRegistration3({super.key});

  @override
  State<PersonRegistration3> createState() => _PersonRegistration3State();
}

class _PersonRegistration3State extends State<PersonRegistration3> {
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
                  TextFormField(decoration: _inputStyle("(44) 98765-4321")),
                  const SizedBox(height: 15),
                  _buildFieldLabel(Icons.email_outlined, "Email"),
                  TextFormField(decoration: _inputStyle("")),
                  const SizedBox(height: 15),
                  _buildFieldLabel(Icons.contact_phone_outlined, "Contato adicional"),
                  TextFormField(decoration: _inputStyle("")),
                  const SizedBox(height: 15),
                  _buildFieldLabel(Icons.comment_outlined, "Observação"),
                  const SizedBox(height: 10),
                  // Campo que expande para baixo conforme o conteúdo aumenta
                  TextFormField(
                    maxLines: null, 
                    minLines: 1,    
                    keyboardType: TextInputType.multiline,
                    decoration: _inputStyle("Digite as observações aqui..."),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: custom_colors.colorScheme.primary, // Usando cor do tema
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () { 
                        // Lógica de finalização do cadastro
                      },
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }

  // Métodos auxiliares movidos para dentro da classe do Estado
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}