import 'package:flutter/material.dart';

class ProductTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData? icon;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const ProductTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: maxLines == 1 && keyboardType == TextInputType.number
                ? const Icon(Icons.numbers)
                : null,
            filled: true,
            fillColor: const Color(0xFFF7F8FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF4458D6), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
