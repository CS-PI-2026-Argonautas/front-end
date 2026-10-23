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

  bool get ativo => deletedAt == null;

  static String? _nulo(String valor) {
    final texto = valor.trim();
    return texto.isEmpty ? null : texto;
  }

  Map<String, dynamic> toMap() {
    return {
      'zip_code': _nulo(zipCode),
      'public_place': publicPlace.trim(),
      'number': _nulo(number),
      'complement': _nulo(complement),
      'city': city.trim(),
      'uf': uf.name,
    };
  }

  static String _texto(Object? valor) => (valor ?? '').toString().trim();
  static Timestamp? _ts(Object? valor) => valor is Timestamp ? valor : null;

  factory Address.fromMap(Map<String, dynamic> data, {String? id}) {
    final ufTexto = _texto(data['uf']).toUpperCase();

    return Address(
      id: id,
      zipCode: _texto(data['zip_code']),
      publicPlace: _texto(data['public_place']),
      number: _texto(data['number']),
      complement: _texto(data['complement']),
      city: _texto(data['city']),
      uf: Uf.values.firstWhere((u) => u.name == ufTexto, orElse: () => Uf.PR),
      createdAt: _ts(data['created_at']),
      updatedAt: _ts(data['updated_at']),
      deletedAt: _ts(data['deleted_at']),
    );
  }

  factory Address.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Address.fromMap(doc.data() ?? <String, dynamic>{}, id: doc.id);
  }

  bool mesmosDados(Address outro) {
    return zipCode.trim() == outro.zipCode.trim() &&
        publicPlace.trim() == outro.publicPlace.trim() &&
        number.trim() == outro.number.trim() &&
        complement.trim() == outro.complement.trim() &&
        city.trim() == outro.city.trim() &&
        uf == outro.uf;
  }
}
