import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/authentication.dart';
import 'package:frontend/services/password_recovery/code_service.dart';
import 'package:frontend/utils/password_recovery/validators.dart';
import 'package:frontend/utils/password_strength/password_strength.dart';
import 'package:frontend/widgets/header.dart';
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

  final passwordStrength = PasswordStrength();
  final zxcvbn = PasswordStrength().zxcvbn;
  int passwordScore = 0;

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
                "Nova Senha",
                "Um e-mail com o código foi enviado. Verifique sua caixa de entrada, insira o código enviado e defina sua nova senha abaixo.",
              ),

              _buildFieldLabel(Icons.dialpad, "Código de Verificação"),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                controller: codeController,
                autovalidateMode: validateCodeField
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
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
                decoration:
                    customInputDecoration(
                      hintText: 'Digite o código aqui...',
                    ).copyWith(
                      suffixIcon: isCodeValid == null
                          ? null
                          : Icon(
                              isCodeValid! ? Icons.check_circle : Icons.error,
                              color: isCodeValid! ? Colors.green : Colors.red,
                            ),
                    ),
              ),

              _buildFieldLabel(Icons.lock_outline, "Nova Senha *"),
              TypingTextField(
                controller: passwordController,
                enabled: isCodeValid == true,
                validator: (value) => passwordValidator(value),
                hintText: 'Mínimo 8 caracteres...',
                sensitiveContent: true,
                isPassword: true,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      passwordScore = 0;
                      return;
                    }
                    final result = zxcvbn.evaluate(value);
                    passwordScore = result.score!.toInt();
                  });
                },
              ),
              Opacity(
                opacity: isCodeValid == true ? 1 : 0.4,
                child: Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Segurança da Senha",
                      style: TextStyle(fontSize: 14),
                    ),

                    Row(
                      spacing: 6,
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: passwordController.text.isEmpty
                                ? 0
                                : (passwordScore + 1) / 5,
                            minHeight: 6,
                            color: passwordStrength.passwordStrengthColor(
                              passwordScore,
                            ),
                            backgroundColor: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        Text(
                          passwordController.text.isEmpty
                              ? "Digite uma senha"
                              : "${passwordStrength.passwordStrengthText(passwordScore)}",
                          style: TextStyle(
                            color: passwordController.text.isEmpty
                                ? Colors.grey
                                : passwordStrength.passwordStrengthColor(
                                    passwordScore,
                                  ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              _buildFieldLabel(Icons.lock_reset, "Repetir Senha *"),
              TypingTextField(
                controller: confirmPasswordController,
                enabled: isCodeValid == true,
                validator: (value) =>
                    confirmPassword(value, passwordController.text),
                hintText: 'Confirme sua senha...',
                sensitiveContent: true,
                isPassword: true,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: canResend
                      ? () {
                          _clearFields();
                          widget.codeService.createCode();
                          setState(() => canResend = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Código reenviado: ${widget.codeService.code}',
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 10),
                              backgroundColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          Future.delayed(
                            const Duration(seconds: 30),
                            () => setState(() => canResend = true),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Icon(canResend ? Icons.refresh : Icons.square),
                  label: Text(
                    canResend
                        ? "Reenviar código por e-mail"
                        : "Aguarde para reenviar...",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isCodeValid == true
                      ? () {
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
                              MaterialPageRoute(
                                builder: (context) => Authentication(),
                              ),
                            );
                          } else {
                            print('senha não alterada');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Não foi possível alterar a senha!',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text(
                    "Alterar Senha",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),

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
