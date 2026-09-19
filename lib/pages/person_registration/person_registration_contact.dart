import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/widgets/action_buttons.dart';
import 'package:frontend/widgets/form_card.dart';
import 'package:frontend/widgets/form_field_label.dart';
import 'package:frontend/widgets/form_section_tile.dart';
import 'package:frontend/widgets/header.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonRegistrationContact extends StatefulWidget {
  const PersonRegistrationContact({super.key});

  @override
  State<PersonRegistrationContact> createState() => _PersonRegistration3State();
}

class _PersonRegistration3State extends State<PersonRegistrationContact> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _contatoAdicionalController = TextEditingController();
  final _observacoesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Contato',
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

  // Cabeçalho baseado no ProductHeader[cite: 14]

  Widget _buildFormCard() {
    return FormCard(
      formKey: _formKey,
      child: Column(
        spacing: 18,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSectionTile(
            title: "Canais de Comunicação",
            subtitle: "Informe pelo menos um contato principal.",
          ),

          FormFieldLabel(
            icon: Icons.phone_outlined,
            label: "Telefone principal *",
          ),

          TextFormField(
            controller: _telefoneController,
            decoration: customInputDecoration(hintText: "(44) 98765-4321"),
            inputFormatters: [_phoneFormatter],
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe o telefone';
              if (value.length < 15) return 'Telefone incompleto';
              return null;
            },
          ),

          FormFieldLabel(icon: Icons.email_outlined, label: "Email *"),

          TextFormField(
            controller: _emailController,
            decoration: customInputDecoration(hintText: "exemplo@email.com"),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe o email';
              final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ).hasMatch(value);
              if (!emailValid) return 'Informe um email válido';
              return null;
            },
          ),

          FormFieldLabel(
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

          FormFieldLabel(icon: Icons.comment_outlined, label: "Observações"),

          TextFormField(
            controller: _observacoesController,
            maxLines: 4,
            maxLength: 255,
            keyboardType: TextInputType.multiline,
            decoration: customInputDecoration(
              hintText: "Digite observações relevantes aqui...",
            ),
          ),

          ActionButtons(
            formKey: _formKey,
            colors: colors,
            onCancel: () => Navigator.pop(context),
            onCadastrar: () {
              if (_formKey.currentState!.validate()) {
                String telefone = _telefoneController.text.trim();
                String email = _emailController.text.trim();
                Navigator.pop(context, "$telefone / $email");
              }
            },
          ),
        ],
      ),
    );
  }
}
