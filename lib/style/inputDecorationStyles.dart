// lib/style/input_decoration_style.dart
import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart';

InputDecoration customInputDecoration({String? hintText, Widget? prefixIcon, String? prefixText}) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: prefixIcon,
    prefixText: prefixText,
    fillColor: colorScheme.surfaceContainer, // Padronizado com o estilo de produtos
    filled: true,
    errorStyle: TextStyle(
      color: colorScheme.error,
      fontWeight: FontWeight.bold,
    ),
    // Bordas baseadas no estilo refinado de Product Registration
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.surfaceContainerHigh),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.surfaceContainerHigh),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.error, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colorScheme.error, width: 2),
    ),
  );
}