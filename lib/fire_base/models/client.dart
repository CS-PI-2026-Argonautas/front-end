import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/PersonType.dart';
import 'package:frontend/fire_base/models/contact.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:uuid/uuid.dart';

class Client {
  final String id;

  String name;
  PersonType personType;
  String document;
  Contact contact;

  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;

  List<Address> addresses;

  Client({
    String? id,
    required this.name,
    required this.personType,
    required String document,
    required this.contact,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    List<Address>? addresses,
  }) : id = id ?? const Uuid().v4(),
       document = somenteDigitos(document),
       addresses = addresses ?? [];

  static String somenteDigitos(String valor) {
    return valor.replaceAll(RegExp(r'[^0-9]'), '');
  }

  bool get ativo => deletedAt == null;

  Map<String, dynamic> toMap() {
    return {
      'name': name.trim(),
      'person_type': personType.value,
      'document': document,
      ...contact.toMap(),
    };
  }

  static Timestamp? _ts(Object? valor) => valor is Timestamp ? valor : null;

  factory Client.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};

    return Client(
      id: doc.id,
      name: (data['name'] ?? '').toString().trim(),
      personType: PersonType.de(data['person_type']?.toString()),
      document: (data['document'] ?? '').toString(),
      contact: Contact.fromMap(data),
      createdAt: _ts(data['created_at']),
      updatedAt: _ts(data['updated_at']),
      deletedAt: _ts(data['deleted_at']),
    );
  }
}
