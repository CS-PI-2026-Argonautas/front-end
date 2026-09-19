import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/widgets/action_buttons.dart';
import 'package:frontend/widgets/form_card.dart';
import 'package:frontend/widgets/form_field_label.dart';
import 'package:frontend/widgets/form_section_tile.dart';
import 'package:frontend/widgets/header.dart';

class PersonAlterationAddress extends StatefulWidget {
  const PersonAlterationAddress({super.key});

  @override
  State<PersonAlterationAddress> createState() =>
      _PersonAlterationAddressState();
}

class _PersonAlterationAddressState extends State<PersonAlterationAddress> {
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
        title: 'Edição de Endereço',
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
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe o CEP' : null,
          ),

          FormFieldLabel(icon: Icons.home_outlined, label: "Rua *"),

          TextFormField(
            controller: _ruaController,
            decoration: customInputDecoration(hintText: "Av. Brasil"),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe a rua' : null,
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
                      decoration: customInputDecoration(hintText: "PR"),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Informe a UF'
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),

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
