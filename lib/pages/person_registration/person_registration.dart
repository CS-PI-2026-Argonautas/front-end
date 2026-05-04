import 'package:flutter/material.dart';
import 'package:frontend/style/colorScheme.dart' as custom_colors;
import 'package:frontend/pages/person_registration/person_registration2.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
class PersonRegistration extends StatefulWidget {
  const PersonRegistration({super.key});

  @override
  State<PersonRegistration> createState() => _PersonRegistrationState1();
}

class _PersonRegistrationState1 extends State<PersonRegistration> {
  final _formKey = GlobalKey<FormState>();
  bool _isPessoaFisica = false;

  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##', 
    filter: {"#": RegExp(r'[0-9]')}
  );

  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##', 
    filter: {"#": RegExp(r'[0-9]')}
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
                      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
                      const Text("Cadastro", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFieldLabel(Icons.person_outline, "Nome *"),
                  TextFormField(decoration: _inputStyle("Exemplo"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe o nome';
                        }
                       return null;
                      },
                  ),
                  const SizedBox(height: 20),
                  _buildFieldLabel(
                    Icons.badge_outlined, 
                    _isPessoaFisica ? "CPF *" : "CNPJ *" // Label dinâmico
                  ),
                  TextFormField(
                    key: ValueKey(_isPessoaFisica), // Força o Flutter a redesenhar o campo ao mudar o tipo
                    decoration: _inputStyle(_isPessoaFisica ? "000.000.000-00" : "00.000.000/0000-00"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [_isPessoaFisica ? _cpfFormatter : _cnpjFormatter], // Máscara dinâmica
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe o ${_isPessoaFisica ? "CPF" : "CNPJ"}';
                      }
                      return null;
                     },
                  ),
                  const SizedBox(height: 10),
                 Row(
  children: [
    Checkbox(
      value: _isPessoaFisica, 
      onChanged: (bool? value) {
        setState(() {
          _isPessoaFisica = value ?? false; // Atualiza o estado
        });
      }
    ),
    const Text("Pessoa física?"),
  ],
),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
           
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const PersonRegistration2())
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

  // Helper para labels
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
    // Borda vermelha quando houver erro
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: custom_colors.colorScheme.error, width: 2),
    ),
  );
}
}
