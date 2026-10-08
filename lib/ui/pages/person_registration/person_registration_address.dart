import 'package:flutter/material.dart';
import 'package:frontend/fire_base/Enums/Uf.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/services/person_registration/uppercaser.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/action_buttons.dart';
import 'package:frontend/ui/widgets/form_card.dart';
import 'package:frontend/ui/widgets/form_field_label.dart';
import 'package:frontend/ui/widgets/form_section_tile.dart';
import 'package:frontend/ui/widgets/header.dart';
import 'package:flutter/services.dart';

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
  final Endereco? enderecoInicial;
  final String titulo;

  const PersonRegistrationAddress({
    super.key,
    this.enderecoInicial,
    this.titulo = 'Endereço',
  });

  @override
  State<PersonRegistrationAddress> createState() => _PersonRegistration2State();
}

class _PersonRegistration2State extends State<PersonRegistrationAddress> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _complementoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _ufController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _preencherCamposSeEdicao();
  }

  void _preencherCamposSeEdicao() {
    final endereco = widget.enderecoInicial;

    if (endereco == null) {
      return;
    }

    _cepController.text = endereco.cep;
    _ruaController.text = endereco.logradouro; 
    _complementoController.text = endereco.complemento;
    _cidadeController.text = endereco.cidade;
    _numeroController.text = endereco.numero;
    _ufController.text = endereco.uf.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: widget.titulo,
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
            title: "Localização",
            subtitle: "Campos obrigatórios estão marcados com *",
          ),

          FormFieldLabel(icon: Icons.pin_drop_outlined, label: "CEP *"), 

          TextFormField(
            controller: _cepController,
            decoration: customInputDecoration(hintText: "12345-678"),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha o CEP';
              }
              if (value.length != 9) {
                return 'CEP inválido';
              }
              return null;
            },
          ),

          FormFieldLabel(icon: Icons.home_outlined, label: "Logradouro *"),

          TextFormField(
            controller: _ruaController,
            decoration: customInputDecoration(hintText: "Av. Brasil"),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe a rua' : null,
          ),

          FormFieldLabel(icon: Icons.apartment_outlined, label: "Complemento"),

          TextFormField(
            controller: _complementoController,
            decoration: customInputDecoration(hintText: "Sala 2, fundos..."),
          ),

          FormFieldLabel(icon: Icons.location_city_outlined, label: "Cidade *"),

          TextFormField(
            controller: _cidadeController,
            decoration: customInputDecoration(hintText: "Paranavaí"),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe a cidade' : null,
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
                    FormFieldLabel(
                      icon: Icons.numbers_outlined,
                      label: "Número",
                    ),

                    TextFormField(
                      controller: _numeroController,
                      decoration: customInputDecoration(hintText: "123"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    FormFieldLabel(icon: Icons.flag_outlined, label: "UF *"),

                    TextFormField(
                      controller: _ufController,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: customInputDecoration(hintText: "PR"),
                      textCapitalization: TextCapitalization.characters,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a UF';
                        }
                        if (!Uf.values.any(
                          (u) => u.name == value.toUpperCase(),
                        )) {
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
            textoConfirmar: widget.enderecoInicial == null
                ? 'Cadastrar'
                : 'Salvar',
            onCancel: () {
              Navigator.pop(context);
            },
            onCadastrar: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              final cep = _cepController.text.trim();
              final rua = _ruaController.text.trim();
              final complemento = _complementoController.text.trim();
              final cidade = _cidadeController.text.trim();
              final numero = _numeroController.text.trim();
              final ufTexto = _ufController.text.trim().toUpperCase();

              final uf = Uf.values.firstWhere((u) => u.name == ufTexto);

              final endereco = Endereco(
                id: widget.enderecoInicial?.id,
                cep: cep,
                logradouro: rua,
                complemento: complemento,
                cidade: cidade,
                numero: numero,
                uf: uf,
              );

              Navigator.pop(context, endereco);
            },
          ),
        ],
      ),
    );
  }
}
