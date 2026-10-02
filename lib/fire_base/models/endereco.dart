import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/Uf.dart';

class Endereco {
  String? id;
  String cep;
  String rua;
  String cidade;
  String numero;
  Uf uf;

  Endereco({
    this.id,
    required this.cep,
    required this.rua,
    required this.cidade,
    this.numero = 'S/N',
    required this.uf 
  });

  Map<String, dynamic> toFirestore() {
    return {
      'cep': cep,
      'rua': rua,
      'cidade': cidade,
      'numero': numero,
      'uf': uf.name,
    };
  }

  factory Endereco.fromFirestore(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data()!;

    return Endereco(
      id: doc.id,
      cep: data['cep'] ?? '',
      rua: data['rua'] ?? '',
      cidade: data['cidade'] ?? '',
      numero: data['numero'] ?? 'S/N',
      uf: Uf.values.firstWhere(
        (uf) => uf.name == data['uf'],
      ),
    );
  }
}