import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/fire_base/Enums/Uf.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/services/person_registration/uppercaser.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/lists/item_list.dart';
import 'package:frontend/ui/pages/lists/os_list_page.dart';
import 'package:frontend/ui/pages/lists/service_list.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/form/action_buttons.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/form_field_label.dart';
import 'package:frontend/ui/widgets/appBar.dart';
<<<<<<< HEAD
import 'package:http/http.dart' as http;
=======
import 'package:flutter/services.dart';
import 'package:frontend/ui/widgets/menu.dart';
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    if (text.length > 5) {
      text = '${text.substring(0, 5)}-${text.substring(5)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class PersonRegistrationAddress extends StatefulWidget {
  final Address? enderecoInicial;
  final String titulo;
  final bool abertoPelaOS;

  const PersonRegistrationAddress({
    super.key,
    this.enderecoInicial,
    this.titulo = 'Endereço',
    this.abertoPelaOS = false,
  });

  @override
  State<PersonRegistrationAddress> createState() => _PersonRegistration2State();
}

class _PersonRegistration2State extends State<PersonRegistrationAddress> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();

  bool _buscandoCep = false;
  String? _erroCepRemoto;
  String? _ultimoCepConsultado;

  bool get _cepEhOpcionalNaEdicao {
    final inicial = widget.enderecoInicial;
    return inicial != null && inicial.zipCode.trim().isEmpty;
  }

  @override
  void initState() {
    super.initState();
    _preencherCamposSeEdicao();
  }

  @override
  void dispose() {
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _cidadeController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  void _preencherCamposSeEdicao() {
    final endereco = widget.enderecoInicial;
    if (endereco == null) return;

    _cepController.text = endereco.zipCode;
    _ruaController.text = endereco.publicPlace;
<<<<<<< HEAD
    _numeroController.text = endereco.number;
=======
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
    _complementoController.text = endereco.complement;
    _cidadeController.text = endereco.city;
    _ufController.text = endereco.uf.name;
    final digitos = endereco.zipCode.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitos.length == 8) {
      _ultimoCepConsultado = digitos;
    }
  }

  Future<bool> _consultarViaCep(String cepFormatadoOuBruto, {bool forcar = false}) async {
    final digitos = cepFormatadoOuBruto.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitos.length != 8) return false;
    if (!forcar && _ultimoCepConsultado == digitos && _erroCepRemoto == null) {
      return true;
    }

    setState(() {
      _buscandoCep = true;
      _erroCepRemoto = null;
    });

    try {
      final uri = Uri.parse('https://viacep.com.br/ws/$digitos/json/');
      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (!mounted) return false;

      if (response.statusCode != 200) {
        setState(() {
          _buscandoCep = false;
          _erroCepRemoto = 'Não foi possível consultar o CEP';
        });
        return false;
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['erro'] == true || data['erro'] == 'true') {
        setState(() {
          _buscandoCep = false;
          _ultimoCepConsultado = digitos;
          _erroCepRemoto = 'CEP inexistente';
        });
        _formKey.currentState?.validate();
        return false;
      }

      final logradouro = (data['logradouro'] ?? '').toString().trim();
      final cidade = (data['localidade'] ?? '').toString().trim();
      final ufSigla = (data['uf'] ?? '').toString().trim().toUpperCase();

      setState(() {
        _buscandoCep = false;
        _ultimoCepConsultado = digitos;
        _erroCepRemoto = null;

        if (logradouro.isNotEmpty) {
          _ruaController.text = logradouro;
        }
        if (cidade.isNotEmpty) {
          _cidadeController.text = cidade;
        }
        if (ufSigla.isNotEmpty && Uf.values.any((u) => u.name == ufSigla)) {
          _ufController.text = ufSigla;
        }
      });

      _formKey.currentState?.validate();
      return true;
    } catch (_) {
      if (!mounted) return false;
      setState(() {
        _buscandoCep = false;
        _erroCepRemoto = 'Falha ao consultar CEP';
      });
      _formKey.currentState?.validate();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Header(
        onBack: () => Navigator.pop(context),
        title: widget.titulo,
      ),
      endDrawer: widget.abertoPelaOS
          ? null
          : Menu(
              currentIndex: 3,
              onTap: (index) {
                Navigator.pop(context);

                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ItemList()),
                  );
                }

                if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OsListPage()),
                  );
                }

                if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceList(),
                    ),
                  );
                }

                if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
                }
              },
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
      title: "Localização",
      subtitle: "Campos obrigatórios estão marcados com *",
      fieldSpacing: 18,
      autovalidateMode: AutovalidateMode.disabled,
      children: [
<<<<<<< HEAD
        FormFieldLabel(
          icon: Icons.pin_drop_outlined,
          label: _cepEhOpcionalNaEdicao ? "CEP" : "CEP *",
        ),
=======
        FormFieldLabel(icon: Icons.pin_drop_outlined, label: "CEP *"),
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec

        TextFormField(
          controller: _cepController,
          decoration: customInputDecoration(hintText: "00000-000").copyWith(
            suffixIcon: _buscandoCep
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    tooltip: 'Buscar CEP',
                    icon: const Icon(Icons.search),
                    onPressed: () =>
                        _consultarViaCep(_cepController.text, forcar: true),
                  ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CepInputFormatter(),
          ],
          onChanged: (value) {
            if (_erroCepRemoto != null) {
              setState(() => _erroCepRemoto = null);
            }
            final digitos = value.replaceAll(RegExp(r'[^0-9]'), '');
            if (digitos.length == 8 && digitos != _ultimoCepConsultado) {
              _consultarViaCep(value);
            }
          },
          validator: (value) {
            final texto = (value ?? '').trim();
            if (texto.isEmpty) {
              if (_cepEhOpcionalNaEdicao) return null;
              return 'Preencha o CEP';
            }
            if (texto.length != 9) {
              return 'CEP inválido';
            }
            if (_erroCepRemoto != null) {
              return _erroCepRemoto;
            }
            return null;
          },
        ),

        const FormFieldLabel(icon: Icons.home_outlined, label: "Logradouro *"),

        TextFormField(
          controller: _ruaController,
          decoration: customInputDecoration(
            hintText: "Rua, avenida ou rodovia do endereço",
          ),
          validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Informe a rua' : null,
        ),

        const FormFieldLabel(icon: Icons.numbers_outlined, label: "Número"),

        TextFormField(
          controller: _numeroController,
          decoration: customInputDecoration(
            hintText: "Ex: 123, 12A ou S/N",
          ),
          keyboardType: TextInputType.text,
        ),

        const FormFieldLabel(
          icon: Icons.apartment_outlined,
          label: "Complemento",
        ),

        TextFormField(
          controller: _complementoController,
          decoration: customInputDecoration(
            hintText: "Ex: apartamento, bloco, sala",
          ),
        ),

        Row(
          spacing: 18,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                spacing: 18,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
<<<<<<< HEAD
                  const FormFieldLabel(
                    icon: Icons.location_city_outlined,
                    label: "Cidade *",
                  ),

                  TextFormField(
                    controller: _cidadeController,
                    decoration: customInputDecoration(
                      hintText: "Informe a cidade",
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Informe a cidade'
                        : null,
=======
                  FormFieldLabel(icon: Icons.numbers_outlined, label: "Número"),

                  TextFormField(
                    controller: _numeroController,
                    decoration: customInputDecoration(
                      hintText: "Informe o número",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 1,
              child: Column(
                spacing: 18,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormFieldLabel(icon: Icons.flag_outlined, label: "UF *"),

                  TextFormField(
                    controller: _ufController,
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      LengthLimitingTextInputFormatter(2),
                    ],
                    decoration: customInputDecoration(hintText: "UF"),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      final uf = (value ?? '').trim().toUpperCase();
                      if (uf.isEmpty) {
                        return 'Informe a UF';
                      }
                      if (!Uf.values.any((u) => u.name == uf)) {
                        return 'UF inválida';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        ActionButtons(
          formKey: _formKey,
          colors: colors,
          textoConfirmar:
              widget.enderecoInicial == null ? 'Adicionar' : 'Salvar',
          onCancel: () => Navigator.pop(context),
          onSave: () async {
            final cepTexto = _cepController.text.trim();
            final digitosCep = cepTexto.replaceAll(RegExp(r'[^0-9]'), '');

            if (digitosCep.length == 8 &&
                (digitosCep != _ultimoCepConsultado || _erroCepRemoto != null)) {
              await _consultarViaCep(cepTexto, forcar: true);
            }

            if (!_formKey.currentState!.validate()) {
              return;
            }

            final rua = _ruaController.text.trim();
            final numero = _numeroController.text.trim();
            final complemento = _complementoController.text.trim();
            final cidade = _cidadeController.text.trim();
            final ufTexto = _ufController.text.trim().toUpperCase();

            final uf = Uf.values.firstWhere((u) => u.name == ufTexto);

            final endereco = Address(
              id: widget.enderecoInicial?.id,
              zipCode: cepTexto,
              publicPlace: rua,
              complement: complemento,
              city: cidade,
              number: numero,
              uf: uf,
            );

            if (mounted) {
              Navigator.pop(context, endereco);
            }
          },
        ),
      ],
    );
  }
}
