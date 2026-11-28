import 'package:flutter/services.dart';
import 'package:frontend/fire_base/models/dinheiro.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Aceita somente os números digitados.
    final numeros = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final centavos = int.tryParse(numeros);

    if (centavos == null) {
      return oldValue;
    }

    // Formata automaticamente no padrão brasileiro.
    final valorFormatado = Dinheiro(
      centavos,
    ).formatado().replaceFirst('R\$', '').trim();

    return TextEditingValue(
      text: valorFormatado,
      selection: TextSelection.collapsed(offset: valorFormatado.length),
    );
  }
}
