import 'package:flutter/material.dart';
import 'package:frontend/fire_base/exceptions/login_exception.dart';
import 'package:frontend/fire_base/services/authentication_service.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/form/form_section_tile.dart';
import 'package:frontend/ui/widgets/form/labeled_form.dart';
import 'package:frontend/ui/widgets/password_recovery/password_strength_meter.dart';
import 'package:frontend/ui/widgets/password_recovery/typing_text_field.dart';
import 'package:frontend/utils/password_recovery/password_tip.dart';
import 'package:frontend/utils/password_recovery/validators.dart';
import 'package:frontend/ui/widgets/show_dialog/show_no_connection_dialog.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final _service = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    if (!await ensureConnection(
      context,
      message: 'É preciso estar conectado para salvar a senha nova.',
    )) {
      return;
    }
    if (!mounted) return;

    setState(() => _isLoading = true);

    String message = '';

    try {
      await _service.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
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
        content: Text(
          message.isEmpty ? 'Senha alterada com sucesso!' : message,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: message.isEmpty ? Colors.green : Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    if (message.isEmpty) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        onBack: () => Navigator.pop(context),
        title: 'Alterar Senha',
      ),
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionTile(
                title: "Alterar Senha",
                subtitle: PasswordTip.subtitle,
              ),

              LabeledFormField(
                icon: Icons.lock_open,
                label: "Senha Atual *",
                field: TypingTextField(
                  controller: _currentPasswordController,
                  enabled: true,
                  validator: requiredField,
                  hintText: 'Digite sua senha atual...',
                  sensitiveContent: true,
                  isPassword: true,
                ),
              ),

              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledFormField(
                    icon: Icons.lock_outline,
                    label: "Nova Senha *",
                    field: TypingTextField(
                      controller: _newPasswordController,
                      enabled: true,
                      validator: (value) {
                        final error = passwordValidator(
                          value,
                          comparisonValue: PasswordTip.exampleText,
                          nameComparisonValue: "à frase-passe de exemplo",
                        );
                        if (error != null) return error;

                        if (value == _currentPasswordController.text) {
                          return 'A nova senha deve ser diferente da atual';
                        }

                        return null;
                      },
                      hintText: 'Mínimo 8 caracteres...',
                      sensitiveContent: true,
                      isPassword: true,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  PasswordStrengthMeter(password: _newPasswordController.text),
                ],
              ),

              LabeledFormField(
                icon: Icons.lock_reset,
                label: "Repetir Nova Senha *",
                field: TypingTextField(
                  controller: _confirmPasswordController,
                  enabled: true,
                  validator: (value) => confirmPassword(
                    value,
                    _newPasswordController.text,
                    comparisonValue: PasswordTip.exampleText,
                    nameComparisonValue: 'à frase-passe de exemplo',
                  ),
                  hintText: 'Confirme sua nova senha...',
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
                        icon: const Icon(Icons.arrow_back),
                        label: const Text(
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
                        onPressed: _isLoading ? null : _changePassword,
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
                            : const Icon(Icons.check),
                        label: Text(
                          _isLoading ? "Alterando..." : "Alterar senha",
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
            ],
          ),
        ),
      ),
    );
  }
}
