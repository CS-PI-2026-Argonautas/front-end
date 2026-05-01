import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final VoidCallback onBack;

  const ProductHeader({super.key, required this.onBack});

  static const Color primaryBlue = Color.fromARGB(255, 38, 49, 140);
  static const Color secondaryBlue = Color.fromARGB(255, 77, 91, 173);
  static const Color whiteColor = Colors.white;
  static const Color whiteSoft = Colors.white70;
  static const Color whiteBorder = Colors.white54;
  static const Color iconBackground = Color.fromARGB(56, 19, 42, 104);
  static const Color shadowColor = Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryBlue, secondaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: shadowColor, blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: whiteColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cadastro de produtos',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Preencha as informações para adicionar um novo produto ao estoque.',
                  style: TextStyle(color: whiteSoft, fontSize: 14),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: (onBack),
            icon: const Icon(Icons.arrow_back),
            label: const Text("Voltar"),
          ),
        ],
      ),
    );
  }
}
