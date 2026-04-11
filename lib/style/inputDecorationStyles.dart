import 'package:flutter/material.dart';
import 'package:frontend/style/colorScheme.dart';

final inputDecorationStyle = InputDecoration(
  fillColor: colorScheme.onPrimary,
  filled: true,
  labelStyle: TextStyle(color: colorScheme.onSurface),
  floatingLabelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: colorScheme.primary),
    borderRadius: BorderRadius.circular(8.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: colorScheme.primary),
    borderRadius: BorderRadius.circular(8.0),
  ),
);