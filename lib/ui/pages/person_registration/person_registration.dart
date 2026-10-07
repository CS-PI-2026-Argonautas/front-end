import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/models/pessoa_fisica.dart';
import 'package:frontend/fire_base/models/pessoa_juridica.dart';
import 'package:frontend/fire_base/services/cliente_service.dart';
import 'package:frontend/ui/pages/person_registration/person_registration_contact.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/pages/person_registration/person_registration_address.dart';
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/action_buttons.dart';
import 'package:frontend/ui/widgets/form_card.dart';
import 'package:frontend/ui/widgets/form_field_label.dart';
import 'package:frontend/ui/widgets/selection_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/widgets/header.dart';
import 'package:frontend/ui/widgets/form_section_tile.dart';

class PersonRegistration extends StatefulWidget {
  final bool retornarDadosAoFechar;
  const PersonRegistration({super.key, this.retornarDadosAoFechar = false});

  @override
  State<PersonRegistration> createState() => _PersonRegistrationState1();
}

class _PersonRegistrationState1 extends State<PersonRegistration> {
  final _formKey = GlobalKey<FormState>();

  bool _isPessoaFisica = false;
  final colors = custom_colors.colorScheme;

  // Endereços ficam só em memória enquanto o cliente ainda não existe no
  // banco. Ao cadastrar, o cliente é salvo primeiro e cada endereço é gravado
  // com o clienteId gerado (ver ClienteRepository.cadastrar).
  final List<Endereco> _enderecos = [];

  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _contatoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _documentoController = TextEditingController();

  final ClienteService _service = ClienteService();
  bool _salvando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Cadastro de clientes',
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
          const FormSectionTile(
            title: "Informações Pessoais",
            subtitle: "Complete os campos de identificação abaixo.",
          ),

          const FormFieldLabel(
            icon: Icons.person_outline,
            label: "Nome completo *",
          ),

          TextFormField(
            controller: _nomeController,
            decoration: customInputDecoration(hintText: "Digite o nome aqui"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o nome';
              }
              return null;
            },
          ),

          SelectionField<Endereco>(
            label: 'Endereço',
            iconeLabel: Icons.home_outlined,
            itens: _enderecos,
            tituloItem: (endereco) =>
    '${endereco.rua}, ${endereco.numero} - ${endereco.cidade}/${endereco.uf.name}',
            textoVazio: 'Nenhum endereço adicionado.',
            permitirExclusao: true,
            onPressed: () async {
              final novoEndereco = await Navigator.push<Endereco>(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonRegistrationAddress(),
                ),
              );

              if (novoEndereco != null && mounted) {
                setState(() {
                  _enderecos.add(novoEndereco);
                });
              }
            },
            onEdit: (endereco, index) async {
              final enderecoEditado = await Navigator.push<Endereco>(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonRegistrationAddress(
                    enderecoInicial: endereco,
                  ),
                ),
              );

              if (enderecoEditado != null && mounted) {
                setState(() {
                  _enderecos[index] = enderecoEditado;
                });
              }
            },
            onDelete: (endereco, index) {
              setState(() {
                _enderecos.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Endereço removido.'),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      setState(() {
                        _enderecos.insert(index, endereco);
                      });
                    },
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
            controller: _documentoController,
            decoration: customInputDecoration(
              hintText: _isPessoaFisica
                  ? "000.000.000-00"
                  : "00.000.000/0000-00",
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [_isPessoaFisica ? _cpfFormatter : _cnpjFormatter],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o documento';
              }
              if (value.length != (_isPessoaFisica ? 14 : 18)) {
                return _isPessoaFisica ? 'CPF incompleto' : 'CNPJ incompleto';
              }
              return null;
            },
          ),

          CheckboxListTile(
            value: _isPessoaFisica,
            onChanged: (value) => setState(() {
              _isPessoaFisica = value ?? false;
              _documentoController.clear();
              _cpfFormatter.clear();
              _cnpjFormatter.clear();
            }),
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

          ActionButtons(
            formKey: _formKey,
            colors: colors,
            onCancel: () => Navigator.pop(context),
            onCadastrar: _salvar,
          ),
        ],
      ),
    );
  }

  Future<void> _salvar() async {
    if (_salvando) return;
    setState(() => _salvando = true);

    final nome = _nomeController.text.trim();
    final contato = _contatoController.text.trim();
    final documento = _documentoController.text.trim();

    final Cliente cliente = _isPessoaFisica
        ? PessoaFisica(nome: nome, info_contato: contato, cpf: documento)
        : PessoaJuridica(nome: nome, info_contato: contato, cnpj: documento);

    try {
      final id = await _service.cadastrar(cliente, _enderecos);

      if (!mounted) return;

      if (widget.retornarDadosAoFechar) {
        Navigator.pop(context, {
          'id': id,
          'nome': nome,
          'telefone': contato,
        });
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar o cliente.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}