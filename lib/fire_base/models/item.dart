import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/TiposItens.dart';

class Item {
  final String? id;
  final String name;
  final String? description;
  final int valueInCents;
  final int minimumQuantity;
  final TipoProduto type;
final Timestamp? createdAt;
final Timestamp? updatedAt;
  final Timestamp? deletedAt;
Item({
  this.id,
  required this.name,
  this.description,
  required this.valueInCents,
  required this.minimumQuantity,
  required this.type,
  this.createdAt,
  this.updatedAt,
  this.deletedAt,
});
  factory Item.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return Item(
      id: document.id,
      name: data['nome'] as String,
      description: data['descricao'] as String?,
      valueInCents: data['valor_centavos'] as int,
      minimumQuantity: data['quantidade_minima'] as int,
      type: _typeFromFirestore(data['tipo'] as String),
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
      deletedAt: data['deleted_at'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': name,
      'descricao': description,
      'valor_centavos': valueInCents,
      'quantidade_minima': minimumQuantity,
      'tipo': _typeToFirestore(type),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  static TipoProduto _typeFromFirestore(String value) {
    switch (value) {
      case 'PECAS':
        return TipoProduto.pecas;

      case 'BALANCAS':
        return TipoProduto.balancas;

      default:
        throw ArgumentError('Invalid product type: $value');
    }
  }

  static String _typeToFirestore(TipoProduto type) {
    switch (type) {
      case TipoProduto.pecas:
        return 'PECAS';

      case TipoProduto.balancas:
        return 'BALANCAS';
    }
  }

  Item copyWith({
    String? id,
    String? name,
    String? description,
    int? valueInCents,
    int? minimumQuantity,
    TipoProduto? type,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Timestamp? deletedAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      valueInCents: valueInCents ?? this.valueInCents,
      minimumQuantity: minimumQuantity ?? this.minimumQuantity,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

