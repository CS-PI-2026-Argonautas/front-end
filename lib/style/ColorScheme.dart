import 'dart:ui';

import 'package:flutter/material.dart';


final colorScheme = ColorScheme(
  brightness: Brightness.light, //tema claro
  primary: const Color(0xFF2596be), //cor primária do app
  onPrimary: Colors.blueGrey.shade100, //elementos em cima da cor primária
  secondary: const Color(0xFF2582BE),//cor secundária
  onSecondary: Colors.white,//elementos em cima da cor secundária
  tertiary: const Color(0x256CBE),
  onTertiary: Colors.white,
  error: const Color(0xFFd93c26),//mensagens de erro
  onError: Colors.white,//elementos em cima do erro
  surface: const Color(0xFFd8e1e4),//cor de fundo
  surfaceContainer: const Color(0xFFf6f8f9),//cor de fundo de componentes
  surfaceContainerHigh: const Color(0xFFcfdde5),//cor de fundo de componentes em destaque
  onSurface: Colors.blueGrey.shade900,//textos
  onSurfaceVariant: Colors.blueGrey.shade400,//textos secundários
);