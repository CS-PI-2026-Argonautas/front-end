import "package:flutter/material.dart";
import 'package:frontend/fire_base/exceptions/login_exception.dart';
import 'package:frontend/fire_base/services/authentication_service.dart';
import 'package:frontend/ui/pages/auth_gate.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/form/form_section_tile.dart';
import 'package:frontend/ui/widgets/form/labeled_form.dart';
import 'package:frontend/ui/widgets/password_recovery/password_strength_meter.dart';
import 'package:frontend/ui/widgets/password_recovery/typing_text_field.dart';
import 'package:frontend/utils/password_recovery/password_tip.dart';
import 'package:frontend/utils/password_recovery/validators.dart';

class PasswordSetting extends StatefulWidget {
  const PasswordSetting({
    super.key,
    required this.name,
    required this.surname,
    required this.email,
  });

  final String name;
  final String surname;
  final String email;

  @override
  State<PasswordSetting> createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _service = AuthenticationService();

  bool _isLoading = false;

  Future<void> _validateAndSignin() async {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate() ||
        passwordController.text == PasswordTip.exampleText) {
      return;
    }

    setState(() => _isLoading = true);

    String message = '';

    try {
      await _service.signin(
        name: widget.name,
        surname: widget.surname,
        email: widget.email,
        password: passwordController.text,
      );
    } on AuthException catch (e) {
      message = e.message;
    } catch (_) {
      message = 'Erro inesperado! Entre em contato com o suporte';
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.isEmpty ? 'Conta criada com sucesso!' : message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        backgroundColor: message.isEmpty ? Colors.green : Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    if (message.isEmpty) redirect();
  }

  void redirect() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthGate()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        onBack: () => Navigator.pop(context),
        title: 'Cadastro de Senha',
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
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSectionTile(
                title: "Cadastrar Senha",
                subtitle: PasswordTip.subtitle,
              ),

              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledFormField(
                    icon: Icons.lock_outline,
                    label: "Nova Senha *",
                    field: TypingTextField(
                      controller: passwordController,
                      enabled: true,
                      validator: (value) {
                        final error = passwordValidator(
                          value,
                          comparisonValue: PasswordTip.exampleText,
                          nameComparisonValue: "à frase-passe de exemplo",
                        );

                        if (error != null) {
                          return error;
                        }

                        return null;
                      },
                      hintText: 'Mínimo 8 caracteres...',
                      sensitiveContent: true,
                      isPassword: true,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  PasswordStrengthMeter(password: passwordController.text),
                ],
              ),

              LabeledFormField(
                icon: Icons.lock_reset,
                label: "Repetir Senha *",
                field: TypingTextField(
                  controller: confirmPasswordController,
                  enabled: true,
                  validator: (value) {
                    final error = confirmPassword(
                      value,
                      passwordController.text,
                      comparisonValue: PasswordTip.exampleText,
                      nameComparisonValue: 'à frase-passe de exemplo',
                    );

                    if (error != null) {
                      return error;
                    }

                    return null;
                  },
                  hintText: 'Confirme sua senha...',
                  sensitiveContent: true,
                  isPassword: true,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: Icon(Icons.arrow_back),
                        label: Text(
                          "Voltar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _validateAndSignin,
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onSecondary,
                          disabledBackgroundColor: colors.primary.withValues(
                            alpha: 0.7,
                          ),
                          disabledForegroundColor: colors.onSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: colors.onSecondary,
                                ),
                              )
                            : const Icon(Icons.person_add),
                        label: Text(
                          _isLoading ? "Criando conta..." : "Criar conta",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //
              // Center(
              //   child: TextButton(
              //     onPressed: () {
              //       // Lógica de suporte
              //     },
              //     child: Text(
              //       'Dúvidas? Contate nosso suporte',
              //       style: TextStyle(
              //         color: colors.primary,
              //         fontSize: 14,
              //         decoration: TextDecoration.none,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
