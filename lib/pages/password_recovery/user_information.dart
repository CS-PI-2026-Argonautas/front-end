import 'package:flutter/material.dart';
import 'package:frontend/pages/password_recovery/reset_password.dart';
import 'package:frontend/services/password_recovery/code_service.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/password_recovery/modal.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final CodeService codeService = CodeService();
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        onBack: () => Navigator.pop(context),
        title: 'Redefinição de Senha',
      ),
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                spacing: 24,
                children: [
                  // _buildHeader(),
                  _buildFormCard(),
                ],
              ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 18,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                "Dados de Acesso",
                "Informe seu nome de usuário para que o código de redefinição de senha seja enviado para seu e-mail.",
              ),

              _buildFieldLabel(Icons.person_outline, "Nome de Usuário"),

              TextFormField(
                decoration: customInputDecoration(
                  hintText: 'Digite seu nome de usuário...',
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Informe o usuário'
                    : null,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleProsseguir,
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(
                    "Prosseguir",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Dúvidas? Contate nosso suporte',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 14,
                      decoration: TextDecoration.none,
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

  void _handleProsseguir() async {
    if (_formKey.currentState!.validate()) {
      final choice = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Confirmação de e-mail',
        pageBuilder: (_, __, ___) {
          return Modal(
            titleText: 'Seu e-mail está correto? ',
            questionText: 'em*****ail@exem****plo.com',
          );
        },
      );

      if (choice == true) {
        codeService.createCode();
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPassword(codeService: codeService),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código gerado: ${codeService.code}'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 10),
            backgroundColor: Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      spacing: 6,
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
          style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Row(
      spacing: 6,
      children: [
        Icon(icon, size: 20, color: colors.primary),
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
