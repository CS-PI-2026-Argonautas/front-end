import 'package:flutter/material.dart';
import 'package:frontend/pages/password_recovery/reset_password.dart';
import 'package:frontend/services/password_recovery/code_service.dart';
import 'package:frontend/utils/password_recovery/validators.dart';
import 'package:frontend/widgets/password_recovery/digitation_text_field.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
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
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  _buildHeader(), 
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.lock_reset, color: colors.primary, size: 30),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text('Recuperar Senha',
                    style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: colors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Informe seu nome de usuário e enviaremos um código para redefinir sua senha.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
          ),
        ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Dados de Acesso", "Identifique sua conta para continuar."),
              const SizedBox(height: 30),

              _buildFieldLabel(Icons.person_outline, "Nome de Usuário"),
              const SizedBox(height: 10),
              
              TextFormField(
                decoration: customInputDecoration(
                  hintText: 'Digite seu nome de usuário...',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Informe o usuário' : null,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleProsseguir,
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Prosseguir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {
                    
                  },
                  child: Text(
                    'Dúvidas? Contate nosso suporte',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.onSurface)),
        const SizedBox(height: 6),
        Text(subtitle, style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colors.onSurface)),
      ],
    );
  }
}