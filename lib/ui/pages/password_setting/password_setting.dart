import "package:flutter/material.dart";
import 'package:frontend/fire_base/exceptions/login_exception.dart';
import 'package:frontend/fire_base/services/authentication_service.dart';
import 'package:frontend/ui/pages/auth_gate.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/password_recovery/typing_text_field.dart';
import 'package:frontend/utils/password_recovery/validators.dart';
import 'package:frontend/utils/password_strength/password_strength.dart';

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
  _TipText tip = _TipText();

  final passwordStrength = PasswordStrength();
  final zxcvbn = PasswordStrength().zxcvbn;
  int passwordScore = 0;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _service = AuthenticationService();

  bool _isLoading = false;

  Future<void> _validateAndSignin() async {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate() ||
        passwordController.text == tip.exampleText) {
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
            spacing: 18,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                "Cadastrar Senha",
                "${tip.tip}${tip.tipText} \n \n ${tip.example}${tip.exampleText}",
              ),

              _buildFieldLabel(Icons.lock_outline, "Nova Senha *"),
              TypingTextField(
                controller: passwordController,
                enabled: true,
                validator: (value) {
                  final error = passwordValidator(
                    value,
                    comparisonValue: tip.exampleText,
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
              Column(
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

              _buildFieldLabel(Icons.lock_reset, "Repetir Senha *"),
              TypingTextField(
                controller: confirmPasswordController,
                enabled: true,
                validator: (value) {
                  final error = confirmPassword(
                    value,
                    passwordController.text,
                    comparisonValue: tip.exampleText,
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _validateAndSignin,
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
                    "Cadastrar Senha",
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

class _TipText {
  String tip = "Dica: ";
  String tipText =
      'use frases-passe ao invés de senhas padrões para criar credenciais mais longas, seguras e fáceis de memorizar.';
  String example = "Exemplo: ";
  String exampleText = 'cachorro#passeia@parque23';
}
