import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/TipoPessoa.dart';
import 'package:frontend/fire_base/models/contato.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:uuid/uuid.dart';

class Cliente {
  final String id;

  String name;
  TipoPessoa personType;

  String document;

  Contato contact;

  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;

  List<Endereco> addresses;

  Cliente({
    String? id,
    required this.name,
    required this.personType,
    required String document,
    required this.contact,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    List<Endereco>? addresses,
  }) : id = id ?? const Uuid().v4(),
       document = onlyDigits(document),
       addresses = addresses ?? [];

  static String onlyDigits(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  bool get isActive => deletedAt == null;

  Map<String, dynamic> toFirestore() {
    return {
      'nome': name.trim(),
      'tipo_pessoa': personType.valor,
      'documento': document,
      ...contact.toFirestore(),
    };
  }

  static Timestamp? _ts(Object? value) => value is Timestamp ? value : null;

  factory Cliente.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};

    return Cliente(
      id: doc.id,
      name: (data['nome'] ?? '').toString().trim(),
      personType: TipoPessoa.de(data['tipo_pessoa']?.toString()),
      document: (data['documento'] ?? '').toString(),
      contact: Contato.fromFirestore(data),
      createdAt: _ts(data['created_at']),
      updatedAt: _ts(data['updated_at']),
      deletedAt: _ts(data['deleted_at']),
    );
  }
}
