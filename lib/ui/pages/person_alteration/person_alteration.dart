import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/models/pessoa_fisica.dart';
import 'package:frontend/fire_base/models/pessoa_juridica.dart';
import 'package:frontend/fire_base/services/cliente_service.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration_address.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration_contact.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/action_buttons.dart';
import 'package:frontend/ui/widgets/enderecos_editor.dart';
import 'package:frontend/ui/widgets/form_card.dart';
import 'package:frontend/ui/widgets/form_field_label.dart';
import 'package:frontend/ui/widgets/form_section_tile.dart';
import 'package:frontend/ui/widgets/header.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonAlteration extends StatefulWidget {
  /// Cliente a editar, já com os endereços preenchidos (ClienteRepository.listar).
  final Cliente cliente;

  const PersonAlteration({super.key, required this.cliente});

  @override
  State<PersonAlteration> createState() => _PersonAlterationState();
}

class _PersonAlterationState extends State<PersonAlteration> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;
  final ClienteService _service = ClienteService();

  late bool _isPessoaFisica;

  // cópia da lista: o formulário edita aqui e só grava ao confirmar
  late final List<Endereco> _enderecos;

  late final TextEditingController _nomeController;
  late final TextEditingController _contatoController;
  late final TextEditingController _documentoController;
  late final MaskTextInputFormatter _cpfFormatter;
  late final MaskTextInputFormatter _cnpjFormatter;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    final cliente = widget.cliente;

    _isPessoaFisica = cliente is! PessoaJuridica;
    _enderecos = List<Endereco>.of(cliente.enderecos);

    final documento = cliente is PessoaFisica
        ? cliente.cpf
        : cliente is PessoaJuridica
        ? cliente.cnpj
        : '';
    final digitos = documento.replaceAll(RegExp(r'[^0-9]'), '');

    _cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: _isPessoaFisica ? digitos : '',
    );
    _cnpjFormatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: _isPessoaFisica ? '' : digitos,
    );

    _nomeController = TextEditingController(text: cliente.nome);
    _contatoController = TextEditingController(text: cliente.info_contato);
    _documentoController = TextEditingController(
      text: (_isPessoaFisica ? _cpfFormatter : _cnpjFormatter).getMaskedText(),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _contatoController.dispose();
    _documentoController.dispose();
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
        title: 'Edição de clientes',
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
            title: "Informações Pessoais",
            subtitle: "Complete os campos de identificação abaixo.",
          ),

          FormFieldLabel(icon: Icons.person_outline, label: "Nome completo *"),

          TextFormField(
            controller: _nomeController,
            decoration: customInputDecoration(hintText: "Digite o nome aqui"),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Informe o nome';
              }
              return null;
            },
          ),

          EnderecosEditor(
            enderecos: _enderecos,
            abrirFormulario: (inicial) => Navigator.push<Endereco>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PersonAlterationAddress(enderecoInicial: inicial),
              ),
            ),
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
                      builder: (context) => const PersonAlterationContact(),
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
                        ? colors.onSurfaceVariant.withValues(alpha: 0.6)
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
            textoConfirmar: 'Salvar',
            onCancel: () => Navigator.pop(context),
            onCadastrar: _salvar,
          ),
        ],
      ),
    );
  }

  Future<void> _salvar() async {
    if (_salvando) return;

    final id = widget.cliente.id;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este cliente ainda não foi salvo no banco.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    final nome = _nomeController.text.trim();
    final contato = _contatoController.text.trim();
    final documento = _documentoController.text.trim();
    final original = widget.cliente;

    final Cliente atualizado = _isPessoaFisica
        ? PessoaFisica(
            id: id,
            nome: nome,
            info_contato: contato,
            cpf: documento,
          )
        : PessoaJuridica(
            id: id,
            nome: nome,
            info_contato: contato,
            cnpj: documento,
            setor: original is PessoaJuridica ? original.setor : '',
          );

    try {
      await _service.atualizar(atualizado, _enderecos);

      if (!mounted) return;

      // true avisa a listagem para recarregar
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar as alterações.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}