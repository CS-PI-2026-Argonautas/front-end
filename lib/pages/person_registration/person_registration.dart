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

import 'package:frontend/widgets/slidable/slidable_delete_card.dart';
import 'package:frontend/widgets/show_dialog/show_delete_client_dialog.dart';
import 'package:frontend/widgets/show_snackbar/show_delete_client_snackbar.dart';


class PersonRegistration extends StatefulWidget {
  const PersonRegistration({super.key});

  @override
  State<PersonRegistration> createState() => _PersonRegistrationState1();
}

class _PersonRegistrationState1 extends State<PersonRegistration> {
  final _formKey = GlobalKey<FormState>();
  bool _isPessoaFisica = false;
  final colors = custom_colors.colorScheme;
  final List<String> _enderecos = [
  'Paranavaí - PR, Av. Brasil, 123',
  'Maringá - PR, Rua Santos Dumont, 456',
];

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

          if (_enderecos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Nenhum endereço adicionado.",
                style: TextStyle(
                  color: colors.onSurfaceVariant.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _enderecos.length,
              itemBuilder: (context, index) {
                final endereco = _enderecos[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SlidableDeleteCard(
                      slidableKey: ValueKey('$endereco-$index'),
                      extentRatio: 0.20,
                      onDelete: () async {
                        // Exibe o dialog de confirmação igual ao ClientList
                        final confirmarExclusao = await showDialog<bool>(
                              context: context,
                              builder: (_) => ShowDeleteClientDialog(nome: endereco),
                            ) ??
                            false;

                        if (!confirmarExclusao) return;

                        // Remove da lista se confirmado
                        setState(() {
                          _enderecos.removeAt(index);
                        });

                        if (!mounted) return;

                        // Exibe o SnackBar com opção de desfazer
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          ShowDeleteClientSnackbar(
                            color: colors.primary,
                            onPressed: () {
                              setState(() {
                                _enderecos.insert(index, endereco);
                              });
                              messenger.hideCurrentSnackBar();
                            },
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainer,
                          border: Border.all(color: colors.primary.withOpacity(0.5), width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: colors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                endereco,
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
