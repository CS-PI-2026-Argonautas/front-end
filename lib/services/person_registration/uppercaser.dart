import 'package:flutter/services.dart';


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue semFormatar, 
    TextEditingValue comFormatacao,
  ) {
    return TextEditingValue(
      text: comFormatacao.text.toUpperCase(),
      selection: comFormatacao.selection,
    );
  }
}