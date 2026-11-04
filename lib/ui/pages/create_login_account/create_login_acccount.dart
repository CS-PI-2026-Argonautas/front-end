import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/pages/password_setting/password_setting.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/form/form_section_tile.dart';
import 'package:frontend/ui/widgets/appBar.dart';

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
        _emailValidator(_emailController.text) == null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (!_formKey.currentState!.validate()) return;

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

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o campo';
    }

    final bool emailValido = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);

    if (!emailValido) {
      return 'Insira um formato de email válido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Cadastrar Usuário',
      ),
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
            spacing: 18,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSectionTile(
                title: "Cadastro do seu Usuário",
                subtitle: "Informe seus dados pessoais.",
              ),
              _buildFieldLabel(Icons.badge, "Nome *"),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  fillColor: colors.surface,
                  hintText: 'Insira seu nome',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.primary, width: 2.0),
                  ),
                ),
                validator: (value) => _nameValidator(value),
              ),

              _buildFieldLabel(Icons.badge, "Sobrenome *"),

              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  fillColor: colors.surface,
                  hintText: 'Insira seu sobrenome',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.primary, width: 2.0),
                  ),
                ),
                validator: (value) => _nameValidator(value),
              ),

              _buildFieldLabel(Icons.email, "Email *"),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.primary, width: 2.0),
                  ),
                  fillColor: colors.surface,
                  hintText: 'Ex.: nome@exemplo.com',
                  filled: true,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (value) => _emailValidator(value),
              ),

              SizedBox(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
