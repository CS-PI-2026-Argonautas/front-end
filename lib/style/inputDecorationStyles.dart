import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart';

InputDecoration customInputDecoration({String? hintText, Widget? prefixIcon, String? prefixText}) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: prefixIcon,
    prefixText: prefixText,
    isDense: true, 
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    prefixStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    
    fillColor: colorScheme.surfaceContainer,
    filled: true,
    errorStyle: TextStyle(
      color: colorScheme.error,
      fontWeight: FontWeight.bold,
    ),
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
      borderSide: colorScheme.error != null ? BorderSide(color: colorScheme.error, width: 2) : BorderSide.none,
    ),
  );
}