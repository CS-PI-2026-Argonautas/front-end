import 'package:cloud_firestore/cloud_firestore.dart';

class Balanca {
  String? id;
  final String marca;
  final String modelo;
  final String numeroSerie;
  final String portaria;
  final String numeroInmetro;
  final String numeroVerificacao;
  final String seloAnterior;
  final String seloAtual;
  final String lacreAnterior;
  final String lacreAtual;
  final DateTime createdAt;

  Balanca({
    this.id,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    required this.portaria,
    required this.numeroInmetro,
    required this.numeroVerificacao,
    required this.seloAnterior,
    required this.seloAtual,
    required this.lacreAnterior,
    required this.lacreAtual,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toFirestore() {
    return {
      'marca': marca,
      'modelo': modelo,
      'numero_serie': numeroSerie,
      'portaria': portaria,
      'numero_inmetro': numeroInmetro,
      'numero_verificacao': numeroVerificacao,
      'selo_anterior': seloAnterior,
      'selo_atual': seloAtual,
      'lacre_anterior': lacreAnterior,
      'lacre_atual': lacreAtual,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory Balanca.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Balanca(
      id: doc.id,
      marca: (data['marca'] ?? '').toString(),
      modelo: (data['modelo'] ?? '').toString(),
      numeroSerie: (data['numero_serie'] ?? '').toString(),
      portaria: (data['portaria'] ?? '').toString(),
      numeroInmetro: (data['numero_inmetro'] ?? '').toString(),
      numeroVerificacao: (data['numero_verificacao'] ?? '').toString(),
      seloAnterior: (data['selo_anterior'] ?? '').toString(),
      seloAtual: (data['selo_atual'] ?? '').toString(),
      lacreAnterior: (data['lacre_anterior'] ?? '').toString(),
      lacreAtual: (data['lacre_atual'] ?? '').toString(),
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
