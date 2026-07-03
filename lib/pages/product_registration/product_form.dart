import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/Enums/TiposItens.dart' as tipos;

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

    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),

        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Informações do produto",

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),

              Text(
                "Complete os campos abaixo com os dados necessários.",

                style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
              ),

              Row(
                spacing: 6,
                children: [
                  Icon(Icons.inventory_2, size: 20, color: colors.primary),

                  Text(
                    "Nome do Produto",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                decoration: customInputDecoration(hintText: 'Balança'),
              ),

              Row(
                spacing: 6,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 20,
                    color: colors.primary,
                  ),

                  Text(
                    "Descrição do produto",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),

              TextFormField(
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                decoration: customInputDecoration(
                  hintText: 'Ex.: marca, tamanho, peso máximo...',
                ),
              ),

              Row(
                spacing: 6,
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 20,
                    color: colors.primary,
                  ),

                  Text(
                    "Valor",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                ],

                decoration: customInputDecoration(
                  hintText: '0,00',

                  prefixIcon: Icon(Icons.attach_money, color: colors.primary),
                ),
              ),

              Row(
                spacing: 6,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: colors.primary,
                  ),

                  Text(
                    "Quantidade mínima",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                maxLength: 2,
                keyboardType: TextInputType.number,

                inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                decoration: customInputDecoration(
                  hintText: '10',

                  prefixIcon: Icon(Icons.numbers, color: colors.primary),
                ),
              ),

              Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<tipos.TipoProduto>(
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
                  ),
                ],
              ),

              Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        bool valido = _formKey.currentState!.validate();
                        widget.onSave(valido);
                      },

                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onSecondary,

                        padding: const EdgeInsets.symmetric(vertical: 18),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      icon: const Icon(Icons.save_outlined),

                      label: const Text(
                        "Salvar",

                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: widget.onCancel,

                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.onSurface,

                        side: BorderSide(color: colors.surfaceContainerHigh),

                        padding: const EdgeInsets.symmetric(vertical: 18),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      icon: const Icon(Icons.cancel_outlined),

                      label: const Text("Cancelar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
