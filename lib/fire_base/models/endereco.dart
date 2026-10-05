import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/Uf.dart';

class Endereco {
  String? id;

  /// Id do documento do cliente dono do endereço (coleção `clients`).
  /// Fica null enquanto o cliente ainda não foi salvo.
  String? clienteId;

  String cep;
  String rua;
  String cidade;
  String complemento;
  String numero;
  Uf uf;

  Endereco({
    this.id,
    this.clienteId,
    required this.cep,
    required this.rua,
    required this.cidade,
    required this.complemento,
    this.numero = 'S/N',
    required this.uf,
  });

  /// Só os dados do endereço (sem id e sem clienteId).
  /// É isso que a OS grava como cópia embutida.
  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'rua': rua,
      'cidade': cidade,
      'complemento': complemento,
      'numero': numero,
      'uf': uf.name,
    };
  }

  /// Documento da coleção `addresses`: dados + vínculo com o cliente.
  Map<String, dynamic> toFirestore() {
    return {
      ...toMap(),
      'clienteId': clienteId,
    };
  }

  static String _texto(Object? valor) => (valor ?? '').toString().trim();

  factory Endereco.fromMap(
    Map<String, dynamic> data, {
    String? id,
    String? clienteId,
  }) {
    final ufTexto = _texto(data['uf']).toUpperCase();

    return Endereco(
      id: id,
      clienteId: clienteId,
      cep: _texto(data['cep']),
      rua: _texto(data['rua']),
      cidade: _texto(data['cidade']),
      complemento: _texto(data['complemento']),
      numero: _texto(data['numero']).isEmpty ? 'S/N' : _texto(data['numero']),
      // documento com UF inválida não derruba a lista inteira
      uf: Uf.values.firstWhere(
        (u) => u.name == ufTexto,
        orElse: () => Uf.PR,
      ),
    );
  }

  factory Endereco.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return Endereco.fromMap(
      data,
      id: doc.id,
      clienteId: data['clienteId'] as String?,
    );
  }

  Endereco copyWith({String? id, String? clienteId}) {
    return Endereco(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      cep: cep,
      rua: rua,
      complemento: complemento,
      cidade: cidade,
      numero: numero,
      uf: uf,
    );
  }
}