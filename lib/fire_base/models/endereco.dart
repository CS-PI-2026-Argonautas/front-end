import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/Uf.dart';
import 'package:uuid/uuid.dart';

class Endereco {
  final String id;

  String cep;
  String logradouro;
  String numero;
  String complemento;
  String cidade;
  Uf uf;

  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;

  Endereco({
    String? id,
    required this.cep,
    required this.logradouro,
    this.numero = '',
    this.complemento = '',
    required this.cidade,
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

  Map<String, dynamic> toFirestore() {
    return {
      'cep': _nulo(cep),
      'logradouro': logradouro.trim(),
      'numero': _nulo(numero),
      'complemento': _nulo(complemento),
      'cidade': cidade.trim(),
      'uf': uf.name,
    };
  }

  static String _texto(Object? valor) => (valor ?? '').toString().trim();
  static Timestamp? _ts(Object? valor) => valor is Timestamp ? valor : null;

  factory Endereco.fromMap(Map<String, dynamic> data, {String? id}) {
    final ufTexto = _texto(data['uf']).toUpperCase();

    return Endereco(
      id: id,
      cep: _texto(data['cep']),
      logradouro: _texto(data['logradouro']),
      numero: _texto(data['numero']),
      complemento: _texto(data['complemento']),
      cidade: _texto(data['cidade']),
      uf: Uf.values.firstWhere((u) => u.name == ufTexto, orElse: () => Uf.PR),
      createdAt: _ts(data['created_at']),
      updatedAt: _ts(data['updated_at']),
      deletedAt: _ts(data['deleted_at']),
    );
  }

  factory Endereco.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Endereco.fromMap(doc.data() ?? <String, dynamic>{}, id: doc.id);
  }

  bool mesmosDados(Endereco outro) {
    return cep.trim() == outro.cep.trim() &&
        logradouro.trim() == outro.logradouro.trim() &&
        numero.trim() == outro.numero.trim() &&
        complemento.trim() == outro.complemento.trim() &&
        cidade.trim() == outro.cidade.trim() &&
        uf == outro.uf;
  }
}
