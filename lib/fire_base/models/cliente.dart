import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/TipoPessoa.dart';
import 'package:frontend/fire_base/models/contato.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:uuid/uuid.dart';

class Cliente {
  final String id;

  String nome;
  TipoPessoa tipoPessoa;

  String documento;

  /// [NOVO] telefone, email, contato_adicional, setor e observacoes.
  Contato contato;

  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;

  List<Endereco> enderecos;

  Cliente({
    String? id,
    required this.nome,
    required this.tipoPessoa,
    required String documento,
    required this.contato,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    List<Endereco>? enderecos,
  }) : id = id ?? const Uuid().v4(),
       documento = somenteDigitos(documento),
       enderecos = enderecos ?? [];

  static String somenteDigitos(String valor) {
    return valor.replaceAll(RegExp(r'[^0-9]'), '');
  }

  bool get ativo => deletedAt == null;

  Map<String, dynamic> toMap() {
    return {
      'nome': nome.trim(),
      'tipo_pessoa': tipoPessoa.valor,
      'documento': documento,
      ...contato.toMap(),
    };
  }

  static Timestamp? _ts(Object? valor) => valor is Timestamp ? valor : null;

  factory Cliente.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};

    return Cliente(
      id: doc.id,
      nome: (data['nome'] ?? '').toString().trim(),
      tipoPessoa: TipoPessoa.de(data['tipo_pessoa']?.toString()),
      documento: (data['documento'] ?? '').toString(),
      contato: Contato.fromMap(data),
      createdAt: _ts(data['created_at']),
      updatedAt: _ts(data['updated_at']),
      deletedAt: _ts(data['deleted_at']),
    );
  }
}
