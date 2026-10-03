import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/endereco.dart';

class Cliente {
  String? id;
  final String nome;
  final String info_contato;

  /// NÃO é gravada no documento do cliente. É preenchida depois, a partir
  /// da coleção `addresses` (where clienteId == id).
  List<Endereco> enderecos;

  // usado para o soft delete
  bool removido;

  Cliente({
    this.id,
    required this.nome,
    required this.info_contato,
    this.enderecos = const [],
    this.removido = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'info_contato': info_contato,
      'removido': removido,
    };
  }

  factory Cliente.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return Cliente(
      id: doc.id,
      nome: (data['nome'] ?? '').toString(),
      info_contato: (data['info_contato'] ?? '').toString(),
      removido: data['removido'] == true,
    );
  }
}