import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';
import 'package:frontend/Enums/TiposItens.dart' as tipos ;

class ProductForm extends StatefulWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ProductForm({super.key, required this.onSave, required this.onCancel});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  bool marcado = false;
  String? tipoSelecionado;

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
          child: Column(
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

              const SizedBox(height: 6),

              Text(
                "Complete os campos abaixo com os dados necessários.",
                style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Icon(Icons.inventory_2, size: 20, color: colors.primary),
                  const SizedBox(width: 8),
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

              const SizedBox(height: 10),

              TextFormField(
                decoration: customInputDecoration(hintText: 'Balança'),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 20,
                    color: colors.primary,
                  ),

                  const SizedBox(width: 8),

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

              const SizedBox(height: 10),

              TextFormField(
                maxLines: 4,
                decoration: customInputDecoration(
                  hintText: 'Ex.: marca, tamanho, peso máximo...',
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 20,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
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

              const SizedBox(height: 10),

              TextFormField(
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

              const SizedBox(height: 30),

              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
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

              const SizedBox(height: 10),

              TextFormField(
                maxLength: 2,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: customInputDecoration(
                  hintText: '10',
                  prefixIcon: Icon(Icons.numbers, color: colors.primary),
                ),
              ),

              const SizedBox(width: 10),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: tipoSelecionado,
                      decoration: customInputDecoration(
                        hintText: "Selecione o tipo",
                        prefixIcon: Icon(Icons.category, color: colors.primary),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "pecas",
                          child: Text("Peças para consertos"),
                        ),
                        DropdownMenuItem(
                          value: "balancas",
                          child: Text("Balanças"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          tipoSelecionado = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                children: [
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.onSave,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
