import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/Uf.dart';

class Endereco {
  String? id;
  String? clienteId;
  String cep;
  String rua;
  String cidade;
  String numero;
  Uf uf;

  Endereco({
    this.id,
    this.clienteId,
    required this.cep,
    required this.rua,
    required this.cidade,
    this.numero = 'S/N',
    required this.uf 
  });

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'rua': rua,
      'cidade': cidade,
      'numero': numero,
      'uf': uf.name,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      ...toMap(),
      'clienteId': clienteId,
    };
  }

  factory Endereco.fromFirestore(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
    final data = {
      for (final e in doc.data()!.entries) e.key.trim(): e.value,
    };

    return Endereco(
      id: doc.id,
      clienteId: data['clienteId']?.toString(),
      cep: (data['cep'] ?? '').toString().trim(),
      rua: (data['rua'] ?? '').toString().trim(),
      cidade: (data['cidade'] ?? '').toString().trim(),
      numero: (data['numero'] ?? 'S/N').toString(),
      uf: Uf.values.firstWhere((u) => u.name == (data['uf'] as String?)?.toUpperCase(), orElse: () => Uf.PR)
    );
  }
}