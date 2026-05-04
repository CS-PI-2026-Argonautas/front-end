import 'package:flutter/material.dart';
import 'package:frontend/pages/person_registration/person_registration3.dart';
import 'package:frontend/style/colorScheme.dart' as custom_colors;


class PersonRegistration2 extends StatefulWidget {
  const PersonRegistration2({super.key});

  @override
  State<PersonRegistration2> createState() => _PersonRegistration2State();
}

class _PersonRegistration2State extends State<PersonRegistration2> {
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
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                      const Text("Cadastro", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst)),
                    ],
                  ),
                  _buildFieldLabel(Icons.map_outlined, "CEP"),
                  TextFormField(decoration: _inputStyle("12312312")),
                  const SizedBox(height: 15),
                  _buildFieldLabel(Icons.home_outlined, "Rua"),
                  TextFormField(decoration: _inputStyle("Rua exemplo")),
                  const SizedBox(height: 15),
                  _buildFieldLabel(Icons.add_location_alt_outlined, "Complemento"),
                  TextFormField(decoration: _inputStyle("")),
                  const SizedBox(height: 15),
                  _buildFieldLabel(Icons.location_city, "Cidade *"),
                  TextFormField(decoration: _inputStyle(""),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe a cidade';
                        }
                       return null;
                      },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Número"), TextFormField(decoration: _inputStyle(""))])),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("UF *"), TextFormField(decoration: _inputStyle(""),
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe a UF';
                        }
                       return null;
                      },
                      )])),
                       
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
           
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const PersonRegistration3())
                          );
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Preencha todos os campos obrigatórios!'),
                          backgroundColor: custom_colors.colorScheme.error, // Sua cor de erro[cite: 2]
                          behavior: SnackBarBehavior.floating,
                        ),
                        );
                        }
                      },
                      child: const Text("Próximo"),
                    )
                  ),
                ],
              )
              )
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}