import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/Uf.dart';
import 'package:uuid/uuid.dart';

class Address {
  final String id;

  String zipCode;
  String publicPlace;
  String number;
  String complement;
  String city;
  Uf uf;

  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;

  Address({
    String? id,
    required this.zipCode,
    required this.publicPlace,
    this.number = '',
    this.complement = '',
    required this.city,
    required this.uf,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) : id = id ?? const Uuid().v4();

  bool get active => deletedAt == null;

  static String? _nullIfEmpty(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  Map<String, dynamic> toMap() {
    return {
      'zip_code': _nullIfEmpty(zipCode),
      'public_place': publicPlace.trim(),
      'number': _nullIfEmpty(number),
      'complement': _nullIfEmpty(complement),
      'city': city.trim(),
      'uf': uf.name,
    };
  }

  static String _text(Object? value) =>
      (value ?? '').toString().trim();

  static Timestamp? _timestamp(Object? value) =>
      value is Timestamp ? value : null;

  factory Address.fromMap(Map<String, dynamic> data, {String? id}) {
    final stateText = _text(data['uf']).toUpperCase();

    return Address(
      id: id,
      zipCode: _text(data['zip_code']),
      publicPlace: _text(data['public_place']),
      number: _text(data['number']),
      complement: _text(data['complement']),
      city: _text(data['city']),
      uf: Uf.values.firstWhere(
        (state) => state.name == stateText,
        orElse: () => Uf.PR,
      ),
      createdAt: _timestamp(data['created_at']),
      updatedAt: _timestamp(data['updated_at']),
      deletedAt: _timestamp(data['deleted_at']),
    );
  }

  factory Address.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return Address.fromMap(
      doc.data() ?? <String, dynamic>{},
      id: doc.id,
    );
  }

  bool hasSameData(Address other) {
    return zipCode.trim() == other.zipCode.trim() &&
        publicPlace.trim() == other.publicPlace.trim() &&
        number.trim() == other.number.trim() &&
        complement.trim() == other.complement.trim() &&
        city.trim() == other.city.trim() &&
        uf == other.uf;
  }
}