import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/fire_base/Enums/TiposItens.dart' as tipos;
import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/ui/widgets/form/validator.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/labeled_form.dart';
import 'package:frontend/ui/widgets/action_buttons.dart';

class ProductForm extends StatefulWidget {
  final ValueChanged<Item> onSave;
  final VoidCallback onCancel;

  const ProductForm({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  final _minimumQuantityController = TextEditingController();

  tipos.TipoProduto? tipoSelecionado;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _minimumQuantityController.dispose();

    super.dispose();
  }

  int _parseValueInCents(String value) {
  final input = value.trim();

  if (input.isEmpty) {
    throw const FormatException('Valor vazio.');
  }

  String integerPart;
  String decimalPart;

  if (input.contains(',')) {
    final parts = input.split(',');

    if (parts.length != 2) {
      throw const FormatException('Valor inválido.');
    }

    integerPart = parts[0].replaceAll('.', '');
    decimalPart = parts[1];
  } else if (input.contains('.')) {
   
    final parts = input.split('.');

    if (parts.length == 2 && parts[1].length <= 2) {
      integerPart = parts[0];
      decimalPart = parts[1];
    } else {

      integerPart = input.replaceAll('.', '');
      decimalPart = '00';
    }
  } else {
  
    integerPart = input;
    decimalPart = '00';
  }

  if (integerPart.isEmpty) {
    integerPart = '0';
  }

  if (decimalPart.length == 1) {
    decimalPart += '0';
  }

  if (decimalPart.length != 2 ||
      !RegExp(r'^\d+$').hasMatch(integerPart) ||
      !RegExp(r'^\d{2}$').hasMatch(decimalPart)) {
    throw const FormatException('Valor inválido.');
  }

  return int.parse(integerPart) * 100 + int.parse(decimalPart);
}
  void _save() {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final String description = _descriptionController.text.trim();

    final item = Item(
      name: _nameController.text.trim(),
      description: description.isEmpty ? null : description,
      valueInCents: _parseValueInCents(_valueController.text),
      minimumQuantity: int.parse(_minimumQuantityController.text),
      type: tipoSelecionado!,
    );

    widget.onSave(item);
  }

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return FormCard(
      formKey: _formKey,
      title: "Informações do produto",
      subtitle: "Complete os campos abaixo com os dados necessários.",
      children: [
        LabeledFormField(
          icon: Icons.inventory_2,
          label: "Nome do Produto",
          field: TextFormField(
            controller: _nameController,
            validator: requiredValidator,
            decoration: customInputDecoration(
              hintText: 'Balança',
            ),
          ),
        ),

        LabeledFormField(
          icon: Icons.description_outlined,
          label: "Descrição do produto",
          field: TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            maxLength: 50,
            decoration: customInputDecoration(
              hintText: 'Ex.: marca, tamanho, peso máximo...',
            ),
          ),
        ),

        LabeledFormField(
          icon: Icons.payments_outlined,
          label: "Valor",
          field: TextFormField(
            controller: _valueController,
            validator: requiredValidator,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9,.]'),
              ),
            ],
            decoration: customInputDecoration(
              hintText: '0,00',
              prefixIcon: Icon(
                Icons.attach_money,
                color: colors.primary,
              ),
            ),
          ),
        ),

        LabeledFormField(
          icon: Icons.warning_amber_rounded,
          label: "Quantidade mínima",
          field: TextFormField(
            controller: _minimumQuantityController,
            validator: requiredValidator,
            maxLength: 2,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: customInputDecoration(
              hintText: '10',
              prefixIcon: Icon(
                Icons.numbers,
                color: colors.primary,
              ),
            ),
          ),
        ),

        DropdownButtonFormField<tipos.TipoProduto>(
          value: tipoSelecionado,
          validator: (value) {
            if (value == null) {
              return 'Campo obrigatório';
            }

            return null;
          },
          decoration: customInputDecoration(
            hintText: "Selecione o tipo",
            prefixIcon: Icon(
              Icons.category,
              color: colors.primary,
            ),
          ),
          items: tipos.TipoProduto.values.map((tipo) {
            return DropdownMenuItem(
              value: tipo,
              child: Text(tipo.label),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              tipoSelecionado = value;
            });
          },
        ),

       ActionButtons(
          formKey: _formKey,
          colors: colors,
          textoConfirmar: 'Salvar',
          onCancel: widget.onCancel,
          onCadastrar: _save,
        ),
      ],
    );
  }
}