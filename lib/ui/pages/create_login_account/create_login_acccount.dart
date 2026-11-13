import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/password_setting/password_setting.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/form/form_section_tile.dart';
import 'package:frontend/ui/widgets/form/labeled_form.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/utils/validators/validators.dart';
import 'package:frontend/ui/widgets/show_dialog/show_no_connection_dialog.dart';

class CreateLoginAccount extends StatefulWidget {
  const CreateLoginAccount({super.key});

  @override
  State<CreateLoginAccount> createState() => CreateLoginAccountState();
}

class CreateLoginAccountState extends State<CreateLoginAccount> {
  final colors = custom_colors.colorScheme;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();

  bool get _formValido {
    return _nameValidator(_nameController.text) == null &&
        _nameValidator(_surnameController.text) == null &&
        validateEmail(_emailController.text) == null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _proceed() async {
    if (!_formKey.currentState!.validate()) return;

    if (!await ensureConnection(
      context,
      message: 'É preciso estar conectado para criar uma conta.',
    )) {
      return;
    }
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordSetting(
          name: _nameController.text,
          surname: _surnameController.text,
          email: _emailController.text,
        ),
      ),
    );
  }

  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o campo';
    }
    if (value.length <= 1) {
      return 'Campo não pode conter 1 letra. Caso seja seu nome registrado, contate o suporte';
    }
    if (value.length > 50) {
      return 'Campo não pode ser maior que 50 letras. Caso seja seu nome registrado, contate o suporte';
    }
    return null;
  }

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
          onChanged: () => setState(() {}),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSectionTile(
                title: "Cadastro do seu Usuário",
                subtitle: "Informe seus dados pessoais.",
              ),
              LabeledFormField(
                icon: Icons.badge,
                label: "Nome *",
                field: TextFormField(
                  controller: _nameController,
                  decoration: customInputDecoration(
                    hintText: 'Informe seu nome',
                  ),
                  validator: (value) => _nameValidator(value),
                ),
              ),

              LabeledFormField(
                icon: Icons.badge,
                label: "Sobrenome *",
                field: TextFormField(
                  controller: _surnameController,
                  decoration: customInputDecoration(
                    hintText: 'Informe seu sobrenome',
                  ),
                  validator: (value) => _nameValidator(value),
                ),
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
                  validator: (value) => validateEmail(value),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _formValido ? _proceed : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onSecondary,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward_outlined),
                    label: const Text(
                      "Prosseguir",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
