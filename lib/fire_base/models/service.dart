import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String? id;
  final String name;
  final String description;
  final int valueInCents;

  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deletedAt;

  const Service({
    this.id,
    required this.name,
    required this.description,
    required this.valueInCents,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  bool get ativo => deletedAt == null;

  factory Service.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw StateError('Documento de serviço sem dados.');
    }

    final valor = data['value_in_cents'];

    if (valor is! int) {
      throw FormatException('Valor do serviço inválido: value_in_cents.');
    }

    return Service(
      id: document.id,
      name: data['name'] as String,
      description: data['description'] as String? ?? '',
      valueInCents: valor,
      createdAt: data['created_at'] as Timestamp?,
      updatedAt: data['updated_at'] as Timestamp?,
      deletedAt: data['deleted_at'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name.trim(),
      'description': description.trim(),
      'value_in_cents': valueInCents,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  Service copyWith({
    String? id,
    String? name,
    String? description,
    int? valueInCents,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Timestamp? deletedAt,
    bool limparDeletedAt = false,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      valueInCents: valueInCents ?? this.valueInCents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: limparDeletedAt ? null : deletedAt ?? this.deletedAt,
    );
  }
}
