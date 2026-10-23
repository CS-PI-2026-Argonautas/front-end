import 'package:flutter/material.dart';
import 'package:frontend/fire_base/Enums/PersonType.dart';
import 'package:frontend/fire_base/models/client.dart';
import 'package:frontend/fire_base/models/contact.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/services/client_service.dart';
import 'package:frontend/fire_base/services/address_service.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration_address.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration_contact.dart';
import 'package:frontend/ui/pages/person_registration/person_registration_contact.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/form/action_buttons.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/form_field_label.dart';
import 'package:frontend/ui/widgets/fields/selection_field.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/show_dialog/show_duplicate_document_dialog.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonAlteration extends StatefulWidget {
  final Client cliente;

  const PersonAlteration({super.key, required this.cliente});

  @override
  State<PersonAlteration> createState() => _PersonAlterationState();
}

class _PersonAlterationState extends State<PersonAlteration> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;
  final ClientService _service = ClientService();
  final AddressService _enderecoService = AddressService(); 

  late bool _isPessoaFisica;
  Contact? _contato;
  List<Address> _originais = [];
  final List<Address> _enderecos = [];
  bool _carregandoEnderecos = true;
  bool _enderecosCarregados = false;

  late final TextEditingController _nomeController;
  late final TextEditingController _documentoController;
  late final MaskTextInputFormatter _cpfFormatter;
  late final MaskTextInputFormatter _cnpjFormatter;

  bool _salvando = false;

  PersonType get _tipoPessoa =>
      _isPessoaFisica ? PersonType.physical : PersonType.legal;

  @override
  void initState() {
    super.initState();

    final cliente = widget.cliente;

    _isPessoaFisica = cliente.personType == PersonType.physical;
    _contato = cliente.contact;

    _cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: _isPessoaFisica ? cliente.document : '',
    );
    _cnpjFormatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: _isPessoaFisica ? '' : cliente.document,
    );

    _nomeController = TextEditingController(text: cliente.name);
    _documentoController = TextEditingController(
      text: (_isPessoaFisica ? _cpfFormatter : _cnpjFormatter).getMaskedText(),
    );

    _carregarEnderecos();
  }

  Future<void> _carregarEnderecos() async {
    try {
      final lista = await _enderecoService.listar(widget.cliente.id);

      if (!mounted) return;

      setState(() {
        _originais = List<Address>.of(lista);
        _enderecos
          ..clear()
          ..addAll(lista);
        _enderecosCarregados = true;
        _carregandoEnderecos = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar endereços: $e');

      if (!mounted) return;

      setState(() => _carregandoEnderecos = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível carregar os endereços do cliente.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
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
      title: "Informações Pessoais",
      subtitle: "Complete os campos de identificação abaixo.",
      fieldSpacing: 18,
      autovalidateMode: AutovalidateMode.disabled,
      children: [
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

        if (_carregandoEnderecos)
          const Center(child: CircularProgressIndicator())
        else
          SelectionField<Address>(
            label: 'Endereço',
            iconeLabel: Icons.home_outlined,
            itens: _enderecos,
            tituloItem: (endereco) =>
                '${endereco.publicPlace}, ${endereco.number} - ${endereco.city}/${endereco.uf.name}',
            textoVazio: 'Nenhum endereço adicionado.',
            permitirExclusao: true,
            onPressed: () async {
              final novoEndereco = await Navigator.push<Address>(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonAlterationAddress(),
                ),
              );

              if (novoEndereco != null && mounted) {
                setState(() {
                  _enderecos.add(novoEndereco);
                });
              }
            },
            onEdit: (endereco, index) async {
              final enderecoEditado = await Navigator.push<Address>(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonAlterationAddress(
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

       SelectionField<Contact>(
          label: 'Informações de contato',
          iconeLabel: Icons.phone_android_outlined,
          itens: _contato != null ? [_contato!] : [],
          tituloItem: (contato) => contato.resumo,
          textoVazio: 'Nenhum contato adicionado.',
          permitirExclusao: true,
          onPressed: () async {
            final resultadoContato = await Navigator.push<Contact>(
              context,
              MaterialPageRoute(
                builder: (context) => PersonAlterationContact( // ou PersonRegistrationContact
                  contatoInicial: _contato,
                ),
              ),
            );

            if (resultadoContato != null && mounted) {
              setState(() {
                _contato = resultadoContato;
              });
            }
          },
          onEdit: (contato, index) async {
            final contatoEditado = await Navigator.push<Contact>(
              context,
              MaterialPageRoute(
                builder: (context) => PersonAlterationContact( // ou PersonRegistrationContact
                  contatoInicial: contato,
                ),
              ),
            );

            if (contatoEditado != null && mounted) {
              setState(() {
                _contato = contatoEditado;
              });
            }
          },
          onDelete: (contato, index) {
            final contatoRemovido = _contato;
            setState(() {
              _contato = null;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Contato removido.'),
                action: SnackBarAction(
                  label: 'Desfazer',
                  onPressed: () {
                    setState(() {
                      _contato = contatoRemovido;
                    });
                  },
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
              ClientService.validarDocumento(value ?? '', _tipoPessoa),
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
          onSave: _salvar,
        ),
      ],
    );
  }

  Future<void> _salvar() async {
    if (_salvando) return;

    if (!_enderecosCarregados) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aguarde o carregamento dos endereços.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    final original = widget.cliente;

    final atualizado = Client(
      id: original.id,
      name: _nomeController.text.trim(),
      personType: _tipoPessoa,
      document: _documentoController.text,
      contact: _contato!,
    );

    try {
      final duplicado = await _service.buscarDuplicado(
        atualizado.document,
        ignorarId: original.id,
      );

      if (duplicado != null) {
        if (!mounted) return;

        final gravar =
            await showDialog<bool>(
              context: context,
              builder: (_) => ShowDuplicateDocumentDialog(
                nomeCliente: duplicado.name,
                tipo: _tipoPessoa,
              ),
            ) ??
            false;

        if (!gravar) {
          if (mounted) setState(() => _salvando = false);
          return;
        }
      }

      await _service.atualizar(atualizado, _originais, _enderecos);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Erro ao salvar cliente: $e');

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