import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/pages/password_setting/password_setting.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/password_recovery/typing_text_field.dart';
import 'package:frontend/utils/validators/validators.dart';

class CreateLoginAccount extends StatefulWidget {
  const CreateLoginAccount({super.key});

  @override
  State<CreateLoginAccount> createState() => CreateLoginAccountState();
}

class CreateLoginAccountState extends State<CreateLoginAccount> {
  final colors = custom_colors.colorScheme;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Cadastrar Usuário',
      ),
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: _buildFormCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 18,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                'Cadastro do seu Usuário',
                'Informe seus dados pessoais.',
              ),

              _buildFieldLabel(Icons.badge, 'Nome*'),

              TypingTextField(
                controller: null, 
                hintText: 'Informe seu nome', 
                enabled: true, 
                sensitiveContent: false, 
                isPassword: false,
                validator: (value){
                  return emptyMandatoryField(value);
                },
              ),

              _buildFieldLabel(Icons.badge, 'Sobrenome*'),

              TypingTextField(
                controller: null, 
                hintText: 'Informe seu sobrenome', 
                enabled: true, 
                sensitiveContent: false, 
                isPassword: false,
                validator: (value) {
                  return emptyMandatoryField(value);
                },
              ),

              _buildFieldLabel(Icons.person_3, 'Nome usuário*'),

              TypingTextField(
                controller: null, 
                hintText: 'Informe seu sobrenome', 
                enabled: true, 
                sensitiveContent: false, 
                isPassword: false,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Mínimo de 3 caracteres';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9._\-]'),
                  ),
                  FilteringTextInputFormatter.deny(
                    RegExp(r'\s'),
                  ),
                ],
                maxLength: 25,
              ),

              _buildFieldLabel(Icons.email, 'Email*'),

              TypingTextField(
                controller: null, 
                hintText: 'Ex: nome@exemplo.com', 
                enabled: true, 
                sensitiveContent: false, 
                isPassword: false,
                validator: (value){
                  return validateEmail(value);
                },
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasswordSetting(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward_outlined),
                  label: const Text(
                    'Prosseguir',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Row(
      spacing: 6,
      children: [
        Icon(
          icon,
          size: 20,
          color: colors.primary,
        ),
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

  InputDecoration _buildInputDecoration({
    required String hintText,
    String? counterText,
  }) {
    return InputDecoration(
      counterText: counterText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colors.primary,
          width: 2,
        ),
      ),
      fillColor: colors.surfaceContainerHigh,
      hintText: hintText,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
