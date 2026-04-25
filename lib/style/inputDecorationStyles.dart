import 'package:flutter/material.dart';
import 'package:frontend/style/colorScheme.dart';

final inputDecorationStyle = InputDecoration(
  fillColor: colorScheme.surfaceContainer,
  filled: true,
  labelStyle: TextStyle(color: colorScheme.onSurface),
  floatingLabelStyle: TextStyle(color: colorScheme.surfaceContainerHigh),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: colorScheme.secondary),
    borderRadius: BorderRadius.circular(8.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: colorScheme.tertiary),
    borderRadius: BorderRadius.circular(8.0),
  ),
);