import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/contact.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/form/action_buttons.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/form_field_label.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/utils/validators/validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonRegistrationContact extends StatefulWidget {
  final Contact? contatoInicial;
  final String titulo;

  const PersonRegistrationContact({
    super.key,
    this.contatoInicial,
    this.titulo = 'Contato',
  });

  @override
  State<PersonRegistrationContact> createState() => _PersonRegistration3State();
}

class _PersonRegistration3State extends State<PersonRegistrationContact> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  late final _phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    initialText: (widget.contatoInicial?.phone ?? '').replaceAll(
      RegExp(r'[^0-9]'),
      '',
    ),
  );

  late final _telefoneController = TextEditingController(
    text: _phoneFormatter.getMaskedText(),
  );
  late final _emailController = TextEditingController(
    text: widget.contatoInicial?.email ?? '',
  );
  late final _contatoAdicionalController = TextEditingController(
    text: widget.contatoInicial?.additionalContact ?? '',
  );
  late final _setorController = TextEditingController(
    text: widget.contatoInicial?.sector ?? '',
  );
  late final _observacoesController = TextEditingController(
    text: widget.contatoInicial?.observations ?? '',
  );

  @override
  void dispose() {
    _telefoneController.dispose();
    _emailController.dispose();
    _contatoAdicionalController.dispose();
    _setorController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: widget.titulo,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(spacing: 24, children: [_buildFormCard()]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return FormCard(
      formKey: _formKey,
      title: "Canais de Comunicação",
      subtitle: "O telefone principal e o email são obrigatórios.",
      fieldSpacing: 18,
      autovalidateMode: AutovalidateMode.disabled,
      children: [
        const FormFieldLabel(
          icon: Icons.phone_outlined,
          label: "Telefone principal *",
        ),

        TextFormField(
          controller: _telefoneController,
          decoration: customInputDecoration(hintText: "(44) 99999-9999"),
          inputFormatters: [_phoneFormatter],
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o telefone';
            }
            if (value.length < 15) return 'Telefone incompleto';
            return null;
          },
        ),

        const FormFieldLabel(icon: Icons.email_outlined, label: "Email *"),

        TextFormField(
          controller: _emailController,
          decoration: customInputDecoration(hintText: "exemplo@email.com"),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            final email = (value ?? '').trim();
            if (email.isEmpty) {
              return 'Informe o email';
            }
            return validateEmail(email);
          },
        ),

        const FormFieldLabel(
          icon: Icons.contact_phone_outlined,
          label: "Contato adicional",
        ),

        TextFormField(
          controller: _contatoAdicionalController,
          decoration: customInputDecoration(
            hintText: "Nome ou telefone extra",
          ),
          maxLength: 50,
        ),

        const FormFieldLabel(icon: Icons.business_outlined, label: "Setor"),

        TextFormField(
          controller: _setorController,
          decoration: customInputDecoration(
            hintText: "Exemplo: Financeiro, Compras...",
          ),
          maxLength: 50,
        ),

        const FormFieldLabel(icon: Icons.comment_outlined, label: "Observações"),

        TextFormField(
          controller: _observacoesController,
          maxLines: 4,
          maxLength: 255,
          keyboardType: TextInputType.multiline,
          decoration: customInputDecoration(
            hintText: "Digite observações relevantes aqui",
          ),
        ),

        ActionButtons(
          formKey: _formKey,
          colors: colors,
          textoConfirmar:
              widget.contatoInicial == null ? 'Adicionar' : 'Salvar',
          onCancel: () => Navigator.pop(context),
          onSave: () {
            if (!(_formKey.currentState?.validate() ?? false)) {
              return;
            }

            Navigator.pop(
              context,
              Contact(
                phone: _telefoneController.text.trim(),
                email: _emailController.text.trim(),
                additionalContact: _contatoAdicionalController.text.trim(),
                sector: _setorController.text.trim(),
                observations: _observacoesController.text.trim(),
              ),
            );
          },
        ),
      ],
    );
  }
}
