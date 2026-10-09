import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/ItemType.dart';

class Item {
  final String? id;
  final String name;
  final String? description;
  final int valueInCents;
  final int minimumQuantity;
  final ItemType type;
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
  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return Item(
      id: document.id,
      name: data['name'] as String,
      description: data['description'] as String?,
      valueInCents: data['value_in_cents'] as int,
      minimumQuantity: data['minimum_quantity'] as int,
      type: _typeFromFirestore(data['type'] as String),
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
      deletedAt: data['deleted_at'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'value_in_cents': valueInCents,
      'minimum_quantity': minimumQuantity,
      'type': _typeToFirestore(type),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  static ItemType _typeFromFirestore(String value) {
    switch (value) {
      case 'PECAS':
        return ItemType.parts;

      case 'BALANCAS':
        return ItemType.scales;

      default:
        throw ArgumentError('Invalid product type: $value');
    }
  }

  static String _typeToFirestore(ItemType type) {
    switch (type) {
      case ItemType.parts:
        return 'PECAS';

      case ItemType.scales:
        return 'BALANCAS';
    }
  }

  Item copyWith({
    String? id,
    String? name,
    String? description,
    int? valueInCents,
    int? minimumQuantity,
    ItemType? type,
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
