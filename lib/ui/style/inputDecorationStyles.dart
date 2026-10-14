import 'package:flutter/material.dart';
import 'package:frontend/ui/style/ColorScheme.dart';

TextStyle customInputTextStyle({Color? color}) {
  return TextStyle(
    color: color ?? colorScheme.onSurface,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

InputDecoration customInputDecoration({
  String? hintText,
  Widget? prefixIcon,
  String? prefixText,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: colorScheme.onSurfaceVariant,
    ),
    prefixIcon: prefixIcon,
    prefixText: prefixText,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    prefixStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

    fillColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return colorScheme.surfaceContainerHighest; // Cor quando está focado
      }
      return colorScheme.surfaceContainerHigh; // Cor padrão (sem foco)
    }),
    filled: true,

    errorStyle: TextStyle(
      color: colorScheme.error,
      fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.error, width: 1),
    ),
  );
}