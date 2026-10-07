import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/Enums/TipoPessoa.dart'; 
import 'package:frontend/fire_base/models/contato.dart'; 
import 'package:frontend/fire_base/services/cliente_service.dart';
import 'package:frontend/ui/pages/person_registration/person_registration_contact.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/pages/person_registration/person_registration_address.dart';
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/action_buttons.dart';
import 'package:frontend/ui/widgets/form_card.dart';
import 'package:frontend/ui/widgets/form_field_label.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/widgets/header.dart';
import 'package:frontend/ui/widgets/show_dialog/show_duplicate_document_dialog.dart'; 
import 'package:frontend/ui/widgets/enderecos_editor.dart';
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

  final List<Endereco> _enderecos = [];

  Contato? _contato;

  TipoPessoa get _tipoPessoa =>
      _isPessoaFisica ? TipoPessoa.fisica : TipoPessoa.juridica;

  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

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
          FormSectionTile(
            title: "Informações Pessoais",
            subtitle: "Complete os campos de identificação abaixo.",
          ),

          FormFieldLabel(icon: Icons.person_outline, label: "Nome completo *"),

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

          EnderecosEditor(
            enderecos: _enderecos,
            abrirFormulario: (inicial) => Navigator.push<Endereco>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PersonRegistrationAddress(enderecoInicial: inicial),
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
                  final resultadoContato = await Navigator.push<Contato>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PersonRegistrationContact(contatoInicial: _contato),
                    ),
                  );

                  if (resultadoContato != null && mounted) {
                    setState(() {
                      _contato = resultadoContato;
                    });
                  }
                },
              ),
            ],
          ),

          FormField<String>(
            key: ValueKey('contato_${(_contato?.resumo ?? '')}'),
            initialValue: (_contato?.resumo ?? ''),
            validator: (value) {
              if (_contato == null) {
                return 'Informe as informações de contato';
              }
              return null;
            },
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: customInputDecoration(
                  hintText: _contato == null
                      ? "Inserir contato"
                      : null,
                ).copyWith(errorText: state.errorText),
                child: Text(
                  _contato == null
                      ? "Inserir contato"
                      : (_contato?.resumo ?? ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: _contato == null
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
            validator: (value) =>
                ClienteService.validarDocumento(value ?? '', _tipoPessoa),
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

    final contato = _contato;
    if (contato == null) return; 

    setState(() => _salvando = true);

    final cliente = Cliente(
      nome: _nomeController.text.trim(),
      tipoPessoa: _tipoPessoa,
      documento: _documentoController.text,
      contato: contato,
    );

    try {
      final duplicado = await _service.buscarDuplicado(cliente.documento);

      if (duplicado != null) {
        if (!mounted) return;

        final gravar =
            await showDialog<bool>(
              context: context,
              builder: (_) => ShowDuplicateDocumentDialog(
                nomeCliente: duplicado.nome,
                tipo: _tipoPessoa,
              ),
            ) ??
            false;

        if (!gravar) {
          if (mounted) setState(() => _salvando = false);
          return;
        }
      }

      await _service.cadastrar(cliente, _enderecos);

      if (!mounted) return;

      if (widget.retornarDadosAoFechar) {
        Navigator.pop(context, {
          'id': cliente.id,
          'nome': cliente.nome,
          'telefone': cliente.contato.telefone,
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

      debugPrint('Erro ao cadastrar cliente: $e');
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
