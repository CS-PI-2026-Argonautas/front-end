import 'package:flutter/material.dart';

class ProductForm extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ProductForm({super.key, required this.onSave, required this.onCancel});

  static const Color cardShadow = Colors.black26;
  static const Color titleColor = Color.fromARGB(255, 46, 45, 45);
  static const Color subtitleColor = Color.fromARGB(137, 3, 3, 3);

  static const Color fieldFill1 = Color.fromARGB(255, 244, 246, 250);
  static const Color fieldFill2 = Color.fromARGB(255, 246, 247, 251);
  static const Color fieldFill3 = Color.fromARGB(255, 247, 248, 252);

  static const Color lightBorder = Colors.black12;
  static const Color lighterBorder = Color.fromARGB(31, 6, 6, 6);
  static const Color focusBlue1 = Color.fromARGB(255, 67, 86, 210);
  static const Color focusBlue2 = Color.fromARGB(255, 69, 89, 217);
  static const Color focusBlue3 = Color.fromARGB(255, 67, 87, 212);

  static const Color buttonBlue = Color.fromARGB(255, 68, 87, 212);
  static const Color whiteColor = Colors.white;
  static const Color cancelText = Colors.black87;
  static const Color cancelBorder = Colors.black26;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: cardShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Informações do produto",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Complete os campos abaixo com os dados necessários.",
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
              const SizedBox(height: 30),

              const Row(
                children: [
                  Icon(Icons.description_outlined, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Descrição do produto",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Ex.: marca, tamanho, peso máximo...',
                  filled: true,
                  fillColor: fieldFill1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: lighterBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: lighterBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: focusBlue1, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Row(
                children: [
                  Icon(Icons.inventory_outlined, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Quantidade em estoque",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '10',
                  prefixIcon: const Icon(Icons.numbers),
                  filled: true,
                  fillColor: fieldFill2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: lightBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: focusBlue2, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Quantidade mínima",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '10',
                  prefixIcon: const Icon(Icons.numbers),
                  filled: true,
                  fillColor: fieldFill3,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: lighterBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: lightBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: focusBlue3, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onSave,
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: buttonBlue,
                        foregroundColor: whiteColor,
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
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cancelText,
                        side: const BorderSide(color: cancelBorder),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: onCancel,
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
