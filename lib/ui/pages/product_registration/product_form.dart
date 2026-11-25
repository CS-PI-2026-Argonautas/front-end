import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/fire_base/Enums/ProductType.dart' as tipos;
import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/ui/widgets/form/validator.dart';
import 'package:frontend/ui/widgets/form/form_card.dart';
import 'package:frontend/ui/widgets/form/labeled_form.dart';
import 'package:frontend/ui/widgets/form/action_buttons.dart';
import 'package:frontend/utils/formatters/currency_input_formatter.dart';

class ProductForm extends StatefulWidget {
  final ValueChanged<Item> onSave;
  final VoidCallback onCancel;
  final Item? itemEdicao;

  const ProductForm({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.itemEdicao,
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

  tipos.ProductType? tipoSelecionado;

  bool get modoEdicao => widget.itemEdicao != null;

  @override
  void initState() {
    super.initState();

    _preencherFormulario();
  }

  void _preencherFormulario() {
    final item = widget.itemEdicao;

    if (item == null) return;
    _nameController.text = item.name;
    _descriptionController.text = item.description ?? '';
    _valueController.text = Dinheiro(
      item.valueInCents,
    ).formatado().replaceFirst('R\$', '').trim();
    _minimumQuantityController.text = item.minimumQuantity.toString();
    tipoSelecionado = item.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _minimumQuantityController.dispose();

    super.dispose();
  }

  int _parseValueInCents(String value) {
    return Dinheiro.fromTexto(value).centavos;
  }

  void _save() {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    final String description = _descriptionController.text.trim();

    final item = Item(
      // Preserva o identificador durante a edição.
      id: widget.itemEdicao?.id,
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

      title: modoEdicao ? "Editar produto" : "Informações do produto",

      subtitle: modoEdicao
          ? "Altere os dados do produto selecionado."
          : "Complete os campos abaixo com os dados necessários.",

      children: [
        LabeledFormField(
          icon: Icons.inventory_2,
          label: "Nome do Produto",
          field: TextFormField(
            controller: _nameController,
            validator: requiredValidator,
            decoration: customInputDecoration(hintText: 'Balança'),
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [CurrencyInputFormatter()],
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
            controller: _minimumQuantityController,
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

        DropdownButtonFormField<tipos.ProductType>(
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

          items: tipos.ProductType.values.map((tipo) {
            return DropdownMenuItem(value: tipo, child: Text(tipo.label));
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

          textoConfirmar: modoEdicao ? 'Salvar alterações' : 'Cadastrar',

          onCancel: widget.onCancel,
          onSave: _save,
        ),
      ],
    );
  }
}
