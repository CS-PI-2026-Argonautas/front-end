import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dinheiro {
  final int centavos;

  Dinheiro(int centavos)
      : centavos = centavos < 0 ? 0 : centavos; 

  factory Dinheiro.fromReais(double reais) {
    if (reais < 0) return Dinheiro(0);
    final centavosCalculados = (reais * 100).round();
    return Dinheiro(centavosCalculados);
  }

  factory Dinheiro.fromTexto(String texto) {
    if (texto.trim().isEmpty) return Dinheiro(0);

    String limpo = texto.replaceAll(RegExp(r'[^\d,\.]'), '').trim();
    if (limpo.isEmpty) return Dinheiro(0);

    limpo = limpo.replaceAll(',', '.');

    final valorDouble = double.tryParse(limpo) ?? 0.0;
    return Dinheiro.fromReais(valorDouble);
  }

  double toReais() => centavos / 100.0;

  String formatado() {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(toReais());
  }

  int toMap() => centavos;

  static int _inteiro(Object? valor) {
    if (valor is int) return valor < 0 ? 0 : valor;
    if (valor is double) return (valor * 100).round() < 0 ? 0 : (valor * 100).round();
    return int.tryParse((valor ?? '').toString().trim()) ?? 0;
  }

  factory Dinheiro.fromMap(Object? data) {
    final centavosLidos = _inteiro(data);
    return Dinheiro(centavosLidos);
  }

  Dinheiro copyWith({int? centavos}) {
    return Dinheiro(centavos ?? this.centavos);
  }

  @override
  String toString() => formatado();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dinheiro &&
          runtimeType == other.runtimeType &&
          centavos == other.centavos;

  @override
  int get hashCode => centavos.hashCode;
}