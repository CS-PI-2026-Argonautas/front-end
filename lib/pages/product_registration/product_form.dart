import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/Enums/TiposItens.dart' as tipos;
import 'package:frontend/widgets/form/validator.dart';
import 'package:frontend/widgets/form/form_card.dart';
import 'package:frontend/widgets/form/form_action_button.dart';
import 'package:frontend/widgets/form/labeled_form.dart';

class ProductForm extends StatefulWidget {
  final ValueChanged<bool> onSave;
  final VoidCallback onCancel;

  const ProductForm({super.key, required this.onSave, required this.onCancel});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  tipos.TipoProduto? tipoSelecionado;
  final _formKey = GlobalKey<FormState>();

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
            validator: requiredValidator,
            decoration: customInputDecoration(hintText: 'Balança'),
          ),
        ),

        LabeledFormField(
          icon: Icons.description_outlined,
          label: "Descrição do produto",
          field: TextFormField(
            maxLines: 4,
            validator: requiredValidator,
            decoration: customInputDecoration(
              hintText: 'Ex.: marca, tamanho, peso máximo...',
            ),
          ),
        ),

        LabeledFormField(
          icon: Icons.payments_outlined,
          label: "Valor",
          field: TextFormField(
            validator: requiredValidator,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
            ],
            decoration: customInputDecoration(
              hintText: '0,00',
              prefixIcon: Icon(Icons.attach_money, color: colors.primary),
            ),
          ),
        ),

        LabeledFormField(
          icon: Icons.warning_amber_rounded,
          label: "Quantidade mínima",
          field: TextFormField(
            validator: requiredValidator,
            maxLength: 2,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: customInputDecoration(
              hintText: '10',
              prefixIcon: Icon(Icons.numbers, color: colors.primary),
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
            prefixIcon: Icon(Icons.category, color: colors.primary),
          ),
          items: tipos.TipoProduto.values.map((tipo) {
            return DropdownMenuItem(value: tipo, child: Text(tipo.label));
          }).toList(),
          onChanged: (value) {
            setState(() {
              tipoSelecionado = value;
            });
          },
        ),

        FormActionButtons(
          onSave: () {
            bool valido = _formKey.currentState!.validate();
            widget.onSave(valido);
          },
          onCancel: widget.onCancel,
        ),
      ],
    );
  }
}
