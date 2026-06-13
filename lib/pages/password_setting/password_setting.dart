import "package:flutter/material.dart";
import 'package:frontend/pages/authentication.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/utils/password_recovery/validators.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/password_recovery/typing_text_field.dart'; 

class PasswordSetting extends StatefulWidget{

  const PasswordSetting({super.key});

  @override
  State<PasswordSetting> createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting>{

  _TipText tip = _TipText();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  @override
  void dispose(){
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        onBack: () => Navigator.pop(context),
        title: 'Cadastro de Senha'),
      backgroundColor: colors.surface, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  // _buildHeader(), 
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
              _buildSectionTitle("Cadastrar Senha", "${tip.tipText} \n \n ${tip.exampleText}"),

              const SizedBox(height: 30),

              _buildFieldLabel(Icons.lock_outline, "Nova Senha"),
              const SizedBox(height: 10),
              TypingTextField(
                controller: passwordController,
                enabled: true,
                validator: (value) => passwordValidator(value),
                hintText: 'Mínimo 8 caracteres...',
                sensitiveContent: true,
                isPassword: true,
              ),

              const SizedBox(height: 25),

              _buildFieldLabel(Icons.lock_reset, "Repetir Senha"),
              const SizedBox(height: 10),
              TypingTextField(
                controller: confirmPasswordController,
                enabled: true,
                validator: (value) => confirmPassword(value, passwordController.text),
                hintText: 'Confirme sua senha...',
                sensitiveContent: true,
                isPassword: true,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: Icon(Icons.refresh),
                  label: Text("Voltar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('senha cadastrada');
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Senha cadastrada com sucesso!'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );

                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => Authentication()),
                      );
                    }
                    else{
                      print('senha não cadastrada');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Não foi possível cadastrar a senha!'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text("Cadastrar Senha", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),

              const SizedBox(height: 16),
              
              Center(
                child: TextButton(
                  onPressed: () {
                    // Lógica de suporte
                  },
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

class _TipText extends StatelessWidget{

  String tipText = 'Dica: use frases-passe ao invés de senhas padrões para criar credenciais mais longas, seguras e fáceis de memorizar.';
  String exampleText = 'Exemplo: cachorro#morde#pelucia@23';
  @override
  Widget build(BuildContext context) {
    return _TipText();
  }
}