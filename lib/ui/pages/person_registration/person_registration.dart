import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/client.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/Enums/PersonType.dart';
import 'package:frontend/fire_base/models/contact.dart';
import 'package:frontend/fire_base/services/client_service.dart';
import 'package:frontend/ui/pages/lists/item_list.dart';
import 'package:frontend/ui/pages/lists/os_list_page.dart';
import 'package:frontend/ui/pages/lists/service_list.dart';
import 'package:frontend/ui/pages/person_registration/person_registration_contact.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/pages/person_registration/person_registration_address.dart';
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/form/action_buttons.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/form_field_label.dart';
import 'package:frontend/ui/widgets/fields/selection_field.dart';
import 'package:frontend/ui/widgets/menu.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:frontend/ui/widgets/appBar.dart';

class PersonRegistration extends StatefulWidget {
  final bool retornarDadosAoFechar;
  final bool abertoPelaOS;
  const PersonRegistration({
    super.key,
    this.retornarDadosAoFechar = false,
    this.abertoPelaOS = false,
  });

  @override
  State<PersonRegistration> createState() => _PersonRegistrationState1();
}

class _PersonRegistrationState1 extends State<PersonRegistration> {
  final _formKey = GlobalKey<FormState>();

  bool _isPessoaFisica = false;
  final colors = custom_colors.colorScheme;

  final List<Address> _enderecos = [];
  Contact? _contato;

  PersonType get _tipoPessoa =>
      _isPessoaFisica ? PersonType.physical : PersonType.legal;

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

  final ClientService _service = ClientService();
  bool _salvando = false;

  bool get _possuiDadosPreenchidos {
    return _nomeController.text.trim().isNotEmpty ||
        _documentoController.text.replaceAll(RegExp(r'[^0-9]'), '').isNotEmpty ||
        _enderecos.isNotEmpty ||
        _contato != null;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  Future<void> _confirmarSaidaSeNecessario() async {
    if (_salvando || !_possuiDadosPreenchidos) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar alterações?'),
        content: const Text(
          'Você possui dados preenchidos. Deseja realmente sair e descartar o cadastro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuar editando'),
            style: TextButton.styleFrom(
              foregroundColor: colors.onSurfaceVariant,
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Descartar'),
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
            ),
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
           )
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

        SelectionField<Address>(
          label: 'Endereço *',
          iconeLabel: Icons.home_outlined,
          textoBotao: 'Cadastrar endereço',
          iconeBotao: Icons.add,
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
            final enderecoEditado = await Navigator.push<Address>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PersonRegistrationAddress(enderecoInicial: endereco),
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
          textoBotao: _contato == null ? 'Adicionar contato' : 'Alterar contato',
          iconeBotao: _contato == null ? Icons.add : Icons.swap_horiz_outlined,
          itens: _contato != null ? [_contato!] : [],
          tituloItem: (contato) => contato.resumo,
          textoVazio: 'Nenhum contato adicionado.',
          permitirExclusao: true,
          onPressed: () async {
            final resultadoContato = await Navigator.push<Contact>(
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
          onEdit: (contato, index) async {
            final contatoEditado = await Navigator.push<Contact>(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PersonRegistrationContact(contatoInicial: contato),
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

    final nomeLimpo = _nomeController.text.trim();
    final documentoLimpo = _documentoController.text.trim();

    final cliente = Client(
      name: nomeLimpo,
      personType: _tipoPessoa,
      document: documentoLimpo,
      contact: contato,
    );

    try {
      final duplicado = await _service.buscarDuplicado(documentoLimpo);
      if (duplicado != null) {
        throw ArgumentError(
          'Já existe um cliente cadastrado com este ${_isPessoaFisica ? 'CPF' : 'CNPJ'}.',
        );
      }

      await _service.cadastrar(cliente, _enderecos);

      if (!mounted) return;

      final mensagemSucesso = 'Cliente ${cliente.name} cadastrado';

      if (widget.retornarDadosAoFechar) {
        Navigator.pop(context, {
          'id': cliente.id,
          'name': cliente.name,
          'phone': cliente.contact.phone,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensagemSucesso),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    } on ArgumentError catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message?.toString() ?? 'Dados inválidos.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
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