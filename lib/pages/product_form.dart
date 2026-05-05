import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class ProductForm extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ProductForm({super.key, required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;
    bool marcado = false;

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
                decoration: InputDecoration(
                  hintText: 'Ex.: marca, tamanho, peso máximo...',
                  filled: true,
                  fillColor: colors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.surfaceContainerHigh),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.surfaceContainerHigh),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.primary, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Icon(
                    Icons.inventory_outlined,
                    size: 20,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Quantidade em estoque",
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
                maxLength: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: '10',
                  prefixIcon: Icon(Icons.numbers, color: colors.primary),
                  filled: true,
                  fillColor: colors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.surfaceContainerHigh),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.surfaceContainerHigh),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.primary, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 20,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Preço do produto",
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
                decoration: InputDecoration(
                  hintText: '0,00',
                  prefixText: 'R\$ ',
                  prefixIcon: Icon(Icons.attach_money, color: colors.primary),
                  filled: true,
                  fillColor: colors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.surfaceContainerHigh),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.surfaceContainerHigh),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.primary, width: 2),
                  ),
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
                decoration: InputDecoration(
                  hintText: '10',
                  prefixIcon: Icon(Icons.numbers, color: colors.primary),
                  filled: true,
                  fillColor: colors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.surfaceContainerHigh),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.surfaceContainerHigh),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.primary, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              StatefulBuilder(
                builder: (context, setStateCheckbox) {
                  return CheckboxListTile(
                    value: marcado,
                    onChanged: (value) {
                      setStateCheckbox(() {
                        marcado = value ?? false;
                      });
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Este item é uma balança",
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onSave,
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

                  const SizedBox(width: 14),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCancel,
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
