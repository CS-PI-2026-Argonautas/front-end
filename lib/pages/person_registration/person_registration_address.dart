import 'package:flutter/material.dart';
import 'package:frontend/services/person_registration/uppercaser.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/widgets/action_buttons.dart';
import 'package:frontend/widgets/form_card.dart';
import 'package:frontend/widgets/form_field_label.dart';
import 'package:frontend/widgets/form_section_tile.dart';
import 'package:frontend/widgets/header.dart';
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
  const PersonRegistrationAddress({super.key});

  @override
  State<PersonRegistrationAddress> createState() => _PersonRegistration2State();
}

class _PersonRegistration2State extends State<PersonRegistrationAddress> {
  final _formKey = GlobalKey<FormState>();
  final colors = custom_colors.colorScheme;

  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _ufController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Endereço',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [const SizedBox(height: 20), _buildFormCard()],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSectionTile(
            title: "Localização",
            subtitle: "Campos obrigatórios estão marcados com *",
          ),
          const SizedBox(height: 30),

          FormFieldLabel(icon: Icons.pin_drop_outlined, label: "CEP *"),

          const SizedBox(height: 10),

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
                return 'Informe o CEP';
              }
              if (value.length != 9) {
                return 'CEP inválido';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          FormFieldLabel(icon: Icons.home_outlined, label: "Rua *"),
          const SizedBox(height: 10),
          TextFormField(
            controller: _ruaController,
            decoration: customInputDecoration(hintText: "Av. Brasil"),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe a rua' : null,
          ),

          const SizedBox(height: 20),

          FormFieldLabel(icon: Icons.location_city_outlined, label: "Cidade *"),
          const SizedBox(height: 10),
          TextFormField(
            controller: _cidadeController,
            decoration: customInputDecoration(hintText: "Paranavaí"),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe a cidade' : null,
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormFieldLabel(
                      icon: Icons.numbers_outlined,
                      label: "Número",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _numeroController,
                      decoration: customInputDecoration(hintText: "123"),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormFieldLabel(icon: Icons.flag_outlined, label: "UF *"),
                    const SizedBox(height: 10),
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
                        if (value.length != 2) {
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

          const SizedBox(height: 30),

          ActionButtons(
            formKey: _formKey,
            colors: colors,
            onCancel: () {
              Navigator.pop(context);
            },
            onCadastrar: () {
              if (_formKey.currentState!.validate()) {
                String rua = _ruaController.text.trim();
                String cidade = _cidadeController.text.trim();
                String uf = _ufController.text.trim().toUpperCase();
                String numero = _numeroController.text.trim();
                String enderecoFormatado = "$cidade - $uf, $rua";

                if (numero.isNotEmpty) {
                  enderecoFormatado += ", $numero";
                }

                Navigator.pop(context, enderecoFormatado);
              }
            },
          ),
        ],
      ),
    );
  }
}
