import 'package:flutter/material.dart';
import 'package:frontend/fire_base/Enums/TipoPessoa.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/contato.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/services/cliente_service.dart';
import 'package:frontend/fire_base/services/endereco_service.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration_address.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration_contact.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/form/action_buttons.dart';
import 'package:frontend/ui/widgets/adress_editor.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/form_field_label.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/show_dialog/show_duplicate_document_dialog.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonAlteration extends StatefulWidget {
  final Cliente cliente;

  const PersonAlteration({super.key, required this.cliente});

  @override
  State<PersonAlteration> createState() => _PersonAlterationState();
}

class _PersonAlterationState extends State<PersonAlteration> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;
  final ClienteService _service = ClienteService();
  final EnderecoService _enderecoService = EnderecoService(); 

  late bool _isPessoaFisica;
  late Contato _contato; 
  List<Endereco> _originais = [];
  final List<Endereco> _enderecos = [];
  bool _carregandoEnderecos = true;
  bool _enderecosCarregados = false;

  late final TextEditingController _nomeController;
  late final TextEditingController _documentoController;
  late final MaskTextInputFormatter _cpfFormatter;
  late final MaskTextInputFormatter _cnpjFormatter;

  bool _salvando = false;

  TipoPessoa get _tipoPessoa =>
      _isPessoaFisica ? TipoPessoa.fisica : TipoPessoa.juridica;

  @override
  void initState() {
    super.initState();

    final cliente = widget.cliente;

    _isPessoaFisica = cliente.tipoPessoa == TipoPessoa.fisica;
    _contato = cliente.contato;

    _cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: _isPessoaFisica ? cliente.documento : '',
    );
    _cnpjFormatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: _isPessoaFisica ? '' : cliente.documento,
    );

    _nomeController = TextEditingController(text: cliente.nome);
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
        _originais = List<Endereco>.of(lista);
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
                final resultadoContato = await Navigator.push<Contato>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonAlterationContact(contatoInicial: _contato),
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
          key: ValueKey('contato_${_contato.resumo}'),
          initialValue: _contato.resumo,
          validator: (value) {
            if (_contato.telefone.trim().isEmpty) {
              return 'Informe as informações de contato';
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            final vazio = _contato.resumo.isEmpty;

            return InputDecorator(
              decoration: customInputDecoration(
                hintText: vazio ? "Inserir contato" : null,
              ).copyWith(errorText: state.errorText),
              child: Text(
                vazio ? "Inserir contato" : _contato.resumo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: vazio
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
          textoConfirmar: 'Salvar',
          onCancel: () => Navigator.pop(context),
          onCadastrar: _salvar,
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

    final atualizado = Cliente(
      id: original.id,
      nome: _nomeController.text.trim(),
      tipoPessoa: _tipoPessoa,
      documento: _documentoController.text,
      contato: _contato,
    );

    try {
      final duplicado = await _service.buscarDuplicado(
        atualizado.documento,
        ignorarId: original.id,
      );

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
