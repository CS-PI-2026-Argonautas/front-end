import 'package:flutter/material.dart';
import 'package:frontend/fire_base/exceptions/login_exception.dart';
import 'package:frontend/fire_base/services/authentication_service.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/form/form_section_tile.dart';
import 'package:frontend/ui/widgets/form/labeled_form.dart';
import 'package:frontend/ui/widgets/show_dialog/show_confirm_email_dialog.dart';
import 'package:frontend/utils/password_recovery/validators.dart';
import 'package:frontend/ui/widgets/show_dialog/show_no_connection_dialog.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final _service = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final colors = custom_colors.colorScheme;

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    if (!await ensureConnection(
      context,
      message: 'É preciso estar conectado para enviar o link de redefinição.',
    )) {
      return;
    }
    if (!mounted) return;

    final choice = await showDialog<bool>(
      context: context,
      builder: (_) => ShowConfirmEmailDialog(email: email),
    );

    if (choice != true || !mounted) return;

    setState(() => _isLoading = true);

    String message = '';

    try {
      await _service.sendPasswordResetEmail(email: email);
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
          message.isEmpty
              ? 'Se o e-mail estiver cadastrado, você receberá um link para criar uma senha nova.'
              : message,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
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
        title: 'Redefinição de Senha',
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
                title: "Redefinir senha",
                subtitle:
                    "Informe seu e-mail. Enviaremos um link para você criar uma senha nova.",
              ),

              LabeledFormField(
                icon: Icons.email,
                label: "Email *",
                field: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: customInputDecoration(
                    hintText: 'Ex.: nome@exemplo.com',
                  ),
                  validator: (value) => emailValidator(value),
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
                        onPressed: _isLoading ? null : _sendResetEmail,
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
                            : const Icon(Icons.send),
                        label: Text(
                          _isLoading ? "Enviando..." : "Enviar link",
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
}
