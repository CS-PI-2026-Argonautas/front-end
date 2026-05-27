import 'package:flutter/material.dart';
import 'package:frontend/pages/authentication.dart';
import 'package:frontend/services/password_recovery/code_service.dart';
import 'package:frontend/utils/password_recovery/validators.dart';
import 'package:frontend/widgets/password_recovery/typing_text_field.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors; 
import 'package:frontend/style/inputDecorationStyles.dart'; 
class ResetPassword extends StatefulWidget {
  final CodeService codeService;

  const ResetPassword({super.key, required this.codeService});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool? isCodeValid;
  bool canResend = true;
  bool validateCodeField = false;

  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme; 

  void _clearFields() {
    codeController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() {
      isCodeValid = null;
      validateCodeField = false;
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
                child: Icon(Icons.security, color: colors.primary, size: 30),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text('Nova Senha',
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
            'Um e-mail com o código foi enviado. Verifique sua caixa de entrada e defina sua nova senha abaixo.',
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
              _buildSectionTitle("Segurança", "Insira o código e sua nova senha."),
              const SizedBox(height: 30),

              _buildFieldLabel(Icons.dialpad, "Código de Verificação"),
              const SizedBox(height: 10),
              TextFormField(
                controller: codeController,
                autovalidateMode: validateCodeField ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                validator: (value) {
                  final formatError = codeFormatValidator(value);
                  if (formatError != null) return formatError;
                  return widget.codeService.validateCode(value!);
                },
                onChanged: (value) {
                  final error = widget.codeService.validateCode(value);
                  setState(() {
                    validateCodeField = true;
                    isCodeValid = (error == null);
                  });
                },
                decoration: customInputDecoration(
                  hintText: 'Digite o código aqui...',
                ).copyWith(
                  suffixIcon: isCodeValid == null ? null : Icon(
                    isCodeValid! ? Icons.check_circle : Icons.error,
                    color: isCodeValid! ? Colors.green : Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              _buildFieldLabel(Icons.lock_outline, "Nova Senha"),
              const SizedBox(height: 10),
              TypingTextField(
                controller: passwordController,
                enabled: isCodeValid == true,
                validator: (value) => passwordValidator(value),
                hintText: 'Mínimo 6 caracteres...',
                sensitiveContent: true,
                isPassword: true,
              ),

              const SizedBox(height: 25),

              _buildFieldLabel(Icons.lock_reset, "Repetir Senha"),
              const SizedBox(height: 10),
              TypingTextField(
                controller: confirmPasswordController,
                enabled: isCodeValid == true,
                validator: (value) => confirmPassword(value, passwordController.text),
                hintText: 'Confirme sua senha...',
                sensitiveContent: true,
                isPassword: true,
              ),

              const SizedBox(height: 40),

              Center(
                child: TextButton(
                  onPressed: canResend ? () {
                    _clearFields();
                    widget.codeService.createCode();
                    setState(() => canResend = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Código reenviado: ${widget.codeService.code}'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 10),
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    Future.delayed(const Duration(seconds: 30), () => setState(() => canResend = true));
                  } : null,
                  child: Text(
                    canResend ? "Reenviar código por e-mail" : "Aguarde para reenviar...",
                    style: TextStyle(color: canResend ? colors.primary : Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isCodeValid == true ? () {
                    if (_formKey.currentState!.validate()) {
                      print('senha alterada');
                      _clearFields();
                      widget.codeService.invalidate();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Senha alterada com sucesso!'),
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
                      print('senha não alterada');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Não foi possível alterar a senha!'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text("Alterar Senha", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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