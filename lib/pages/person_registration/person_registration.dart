import 'package:flutter/material.dart';
import 'package:frontend/pages/person_registration/person_registration_contact.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/pages/person_registration/person_registration_address.dart';
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/widgets/action_buttons.dart';
import 'package:frontend/widgets/form_card.dart';
import 'package:frontend/widgets/form_field_label.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/form_section_tile.dart';

class PersonRegistration extends StatefulWidget {
  const PersonRegistration({super.key});

  @override
  State<PersonRegistration> createState() => _PersonRegistrationState1();
}

class _PersonRegistrationState1 extends State<PersonRegistration> {
  final _formKey = GlobalKey<FormState>();
  bool _isPessoaFisica = false;
  final colors = custom_colors.colorScheme;

  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _enderecoController = TextEditingController();
  final _contatoController = TextEditingController();

  String? _erroEndereco;
  String? _erroContato;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      //widget da appbar
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        }, //voltar para a tela anterior
        title: 'Cadastro de clientes', //titulo personalizado
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
      child: Column(
        spacing: 18,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSectionTile(
            title: "Informações Pessoais", //titulo do card
            subtitle:
                "Complete os campos de identificação abaixo.", //subtitulo do card
          ),

          FormFieldLabel(
            icon: Icons.person_outline, //icone do campo do input
            label: "Nome completo *", //label do campo do input
          ),

          TextFormField(
            decoration: customInputDecoration(
              hintText: "Digite o nome aqui", //placeholder do campo do input
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o nome'; //mensagem de erro
              }
              return null;
            },
          ),

          Row(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const FormFieldLabel(
                icon: Icons.home_outlined,
                label: "Endereço",
              ),

              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.add_box_rounded,
                  color: colors.secondary,
                  size: 26,
                ),
                onPressed: () async {
                  final resultadoEndereco = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonRegistrationAddress(),
                    ),
                  );

                  if (resultadoEndereco != null && mounted) {
                    setState(() {
                      _enderecoController.text = resultadoEndereco;
                    });
                  }
                },
              ),
            ],
          ),

          FormField<String>(
            key: ValueKey(
              'endereco_${_enderecoController.text}',
            ), // Prefixo exclusivo
            initialValue: _enderecoController.text,
            validator: (value) {
              if (_enderecoController.text.isEmpty) {
                return 'Informe o endereço';
              }
              return null;
            },
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: customInputDecoration(
                  hintText: _enderecoController.text.isEmpty
                      ? "Inserir o endereço"
                      : null,
                ).copyWith(errorText: state.errorText),
                child: Text(
                  _enderecoController.text.isEmpty
                      ? "Inserir o endereço"
                      : _enderecoController.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: _enderecoController.text.isEmpty
                        ? colors.onSurfaceVariant.withOpacity(0.6)
                        : colors.onSurface,
                  ),
                ),
              );
            },
          ),

          Row(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const FormFieldLabel(
                icon: Icons.phone_android_outlined,
                label: "Informações de contato",
              ),

              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.add_box_rounded,
                  color: colors.secondary,
                  size: 26,
                ),
                onPressed: () async {
                  final resultadoContato = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonRegistrationContact(),
                    ),
                  );

                  if (resultadoContato != null && mounted) {
                    setState(() {
                      _contatoController.text = resultadoContato;
                    });
                  }
                },
              ),
            ],
          ),

          FormField<String>(
            key: ValueKey('contato_${_contatoController.text}'),
            initialValue: _contatoController.text,
            validator: (value) {
              if (_contatoController.text.isEmpty) {
                return 'Informe as informações de contato';
              }
              return null;
            },
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: customInputDecoration(
                  hintText: _contatoController.text.isEmpty
                      ? "Inserir contato"
                      : null,
                ).copyWith(errorText: state.errorText),
                child: Text(
                  _contatoController.text.isEmpty
                      ? "Inserir contato"
                      : _contatoController.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: _contatoController.text.isEmpty
                        ? colors.onSurfaceVariant.withOpacity(0.6)
                        : colors.onSurface,
                  ),
                ),
              );
            },
          ),

          FormFieldLabel(
            icon: Icons.badge_outlined,
            label: _isPessoaFisica ? "CPF *" : "CNPJ *",
          ),

          TextFormField(
            key: ValueKey(_isPessoaFisica),
            decoration: customInputDecoration(hintText: "000.000.000-00"),
            keyboardType: TextInputType.number,
            inputFormatters: [_isPessoaFisica ? _cpfFormatter : _cnpjFormatter],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o documento';
              }
              return null;
            },
          ),

          CheckboxListTile(
            value: _isPessoaFisica,
            onChanged: (value) =>
                setState(() => _isPessoaFisica = value ?? false),
            activeColor: colors.secondary,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              "Pessoa física?",
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          //botões de ação
          ActionButtons(
            formKey: _formKey,
            colors: colors,
            onCancel: () {
              //botão de cancelar
              MaterialPageRoute(builder: (context) => const Dashboard());
              Navigator.pop(context);
            },
            onCadastrar: () {
              // botão de cadastrar
              if (_formKey.currentState!.validate()) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
