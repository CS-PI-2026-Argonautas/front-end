import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/widgets/action_buttons.dart';
import 'package:frontend/widgets/form_section_tile.dart' as FormSectionTitle;
import 'package:frontend/widgets/header.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonRegistrationContact extends StatefulWidget {
  const PersonRegistrationContact({super.key});

  @override
  State<PersonRegistrationContact> createState() => _PersonRegistration3State();
}

class _PersonRegistration3State extends State<PersonRegistrationContact> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _contatoAdicionalController = TextEditingController();
  final _observacoesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar : Header(
        onBack: () { Navigator.pop(context);},
        title: 'Contato',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildFormCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Cabeçalho baseado no ProductHeader[cite: 14]
 

  Widget _buildFormCard() {
    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSectionTitle.FormSectionTile(
                title: "Canais de Comunicação",
                subtitle: "Informe pelo menos um contato principal.",
              ),
              const SizedBox(height: 30),

              _buildFieldLabel(Icons.phone_outlined, "Telefone principal *"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _telefoneController, // VINCULADO AQUI
                decoration: customInputDecoration(hintText: "(44) 98765-4321"),
                inputFormatters: [_phoneFormatter],
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o telefone';
                  if (value.length < 15) return 'Telefone incompleto';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildFieldLabel(Icons.email_outlined, "Email *"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController, // VINCULADO AQUI
                decoration: customInputDecoration(hintText: "exemplo@email.com"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o email';
                  final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value);
                  if (!emailValid) return 'Informe um email válido';
                  return null;
                },
              ),

               _buildFieldLabel(
                Icons.contact_phone_outlined,
                "Contato adicional",
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _contatoAdicionalController,
                decoration: customInputDecoration(
                  hintText: "Nome ou telefone extra",
                ),
                maxLength: 50,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) => null,
              ),

              const SizedBox(height: 20),

              _buildFieldLabel(Icons.comment_outlined, "Observações"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _observacoesController,
                maxLines: 4,
                maxLength: 255,
                keyboardType: TextInputType.multiline,
                decoration: customInputDecoration(
                  hintText: "Digite observações relevantes aqui...",
                ),
              ),

              const SizedBox(height: 30),

              
              ActionButtons(
                formKey: _formKey,
                colors: colors,
                onCancel: () {
                  Navigator.pop(context); 
                },
                onCadastrar: () {
                  if (_formKey.currentState!.validate()) {
                    String telefone = _telefoneController.text.trim();
                    String email = _emailController.text.trim();

                    String contatoFormatado = "$telefone / $email";

                    Navigator.pop(context, contatoFormatado);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}
