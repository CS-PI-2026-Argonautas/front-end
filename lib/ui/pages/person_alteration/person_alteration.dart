import 'package:flutter/material.dart';
import 'package:frontend/fire_base/Enums/PersonType.dart';
import 'package:frontend/fire_base/models/client.dart';
import 'package:frontend/fire_base/models/contact.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/services/client_service.dart';
import 'package:frontend/fire_base/services/address_service.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration_address.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration_contact.dart';
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

  bool get _possuiAlteracoes {
    final original = widget.cliente;
    final docOriginal = original.document.replaceAll(RegExp(r'[^0-9]'), '');
    final docAtual =
        _documentoController.text.replaceAll(RegExp(r'[^0-9]'), '');

    final enderecosAlterados = _enderecos.length != _originais.length ||
        List.generate(
          _enderecos.length,
          (i) => i >= _originais.length || _enderecos[i] != _originais[i],
        ).any((diff) => diff);

    return _nomeController.text.trim() != original.name.trim() ||
        _tipoPessoa != original.personType ||
        docAtual != docOriginal ||
        _contato != original.contact ||
        enderecosAlterados;
  }

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

  Future<void> _confirmarSaidaSeNecessario() async {
    if (_salvando || !_possuiAlteracoes) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar alterações?'),
        content: const Text(
          'Você possui alterações não salvas. Deseja realmente sair e descartá-las?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuar editando'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      Navigator.pop(context);
    }
  }

  String? _validarCpfCnpj(String value, PersonType tipo) {
    final erroService = ClientService.validarDocumento(value, tipo);
    if (erroService != null) return erroService;

    final digitos = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (tipo == PersonType.physical) {
      if (!_isCpfValido(digitos)) return 'CPF inválido';
    } else {
      if (!_isCnpjValido(digitos)) return 'CNPJ inválido';
    }
    return null;
  }

  bool _isCpfValido(String cpf) {
    if (cpf.length != 11 || RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
      return false;
    }

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int digito1 = (soma * 10) % 11;
    if (digito1 == 10) digito1 = 0;
    if (digito1 != int.parse(cpf[9])) return false;

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int digito2 = (soma * 10) % 11;
    if (digito2 == 10) digito2 = 0;
    return digito2 == int.parse(cpf[10]);
  }

  bool _isCnpjValido(String cnpj) {
    if (cnpj.length != 14 || RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) {
      return false;
    }

    const pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int soma = 0;
    for (int i = 0; i < 12; i++) {
      soma += int.parse(cnpj[i]) * pesos1[i];
    }
    int resto = soma % 11;
    final digito1 = resto < 2 ? 0 : 11 - resto;
    if (digito1 != int.parse(cnpj[12])) return false;

    const pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    soma = 0;
    for (int i = 0; i < 13; i++) {
      soma += int.parse(cnpj[i]) * pesos2[i];
    }
    resto = soma % 11;
    final digito2 = resto < 2 ? 0 : 11 - resto;
    return digito2 == int.parse(cnpj[13]);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _confirmarSaidaSeNecessario();
        }
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: Header(
          onBack: _confirmarSaidaSeNecessario,
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
        const FormFieldLabel(
          icon: Icons.person_outline,
          label: "Nome completo *",
        ),

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

        const FormFieldLabel(
          icon: Icons.swap_horiz_outlined,
          label: "Tipo de pessoa *",
        ),

        SegmentedButton<bool>(
          segments: const [
            ButtonSegment<bool>(
              value: false,
              label: Text("Pessoa Jurídica"),
              icon: Icon(Icons.business_outlined),
            ),
            ButtonSegment<bool>(
              value: true,
              label: Text("Pessoa Física"),
              icon: Icon(Icons.person_outline),
            ),
          ],
          selected: {_isPessoaFisica},
          onSelectionChanged: (selection) {
            final novoValor = selection.first;
            if (novoValor == _isPessoaFisica) return;
            setState(() {
              _isPessoaFisica = novoValor;
              _documentoController.clear();
              _cpfFormatter.clear();
              _cnpjFormatter.clear();
            });
          },
          style: SegmentedButton.styleFrom(
            side: const BorderSide(color: Colors.transparent),
            backgroundColor: colors.surfaceContainerHighest,
            foregroundColor: colors.onSurfaceVariant,
            selectedBackgroundColor: colors.secondary,
            selectedForegroundColor: colors.onSecondary,
          ),
        ),

        FormFieldLabel(
          icon: Icons.badge_outlined,
          label: _isPessoaFisica ? "CPF *" : "CNPJ *",
        ),

        TextFormField(
          key: ValueKey(_isPessoaFisica),
          controller: _documentoController,
          decoration: customInputDecoration(
            hintText: _isPessoaFisica ? "000.000.000-00" : "00.000.000/0000-00",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [_isPessoaFisica ? _cpfFormatter : _cnpjFormatter],
          validator: (value) => _validarCpfCnpj(value ?? '', _tipoPessoa),
        ),

        if (_carregandoEnderecos)
          const Center(child: CircularProgressIndicator())
        else
          SelectionField<Address>(
            label: 'Endereço *',
            iconeLabel: Icons.home_outlined,
            itens: _enderecos,
            tituloItem: (endereco) {
              final complementoStr = endereco.complement.trim().isNotEmpty
                  ? ' (${endereco.complement.trim()})'
                  : '';
              final numeroStr = endereco.number.trim().isNotEmpty
                  ? ', ${endereco.number.trim()}'
                  : '';
              return '${endereco.publicPlace}$numeroStr$complementoStr - ${endereco.city}/${endereco.uf.name}';
            },
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
          label: 'Informações de contato *',
          iconeLabel: Icons.phone_android_outlined,
          itens: _contato != null ? [_contato!] : [],
          tituloItem: (contato) => contato.resumo,
          textoVazio: 'Nenhum contato adicionado.',
          permitirExclusao: true,
          onPressed: () async {
            final resultadoContato = await Navigator.push<Contact>(
              context,
              MaterialPageRoute(
                builder: (context) => PersonAlterationContact(
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
                builder: (context) => PersonAlterationContact(
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

        ActionButtons(
          formKey: _formKey,
          colors: colors,
          textoConfirmar: 'Salvar',
          onCancel: _confirmarSaidaSeNecessario,
          onSave: _salvar,
        ),
      ],
    );
  }

  Future<void> _salvar() async {
    if (_salvando) return;

    final formValido = _formKey.currentState?.validate() ?? false;
    if (!formValido) return;

    if (!_enderecosCarregados) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aguarde o carregamento dos endereços.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_enderecos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione ao menos um endereço'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final contato = _contato;
    if (contato == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione ao menos um contato'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    final original = widget.cliente;
    final nomeLimpo = _nomeController.text.trim();
    final documentoLimpo = _documentoController.text.trim();

    final atualizado = Client(
      id: original.id,
      name: nomeLimpo,
      personType: _tipoPessoa,
      document: documentoLimpo,
      contact: contato,
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cliente ${atualizado.name} atualizado'),
          behavior: SnackBarBehavior.floating,
        ),
      );
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