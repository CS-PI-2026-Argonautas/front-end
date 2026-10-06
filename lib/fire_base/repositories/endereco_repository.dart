import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/repositories/leitura_firestore.dart'; // [NOVO]

class EnderecoRepository {
  final FirebaseFirestore _db;

  EnderecoRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> colecao(
    FirebaseFirestore db,
    String clienteId,
  ) {
    return db.collection('clientes').doc(clienteId).collection('enderecos');
  }

  CollectionReference<Map<String, dynamic>> _col(String clienteId) =>
      colecao(_db, clienteId);

  void _log(Object erro, String operacao) {
    debugPrint('Firestore (endereco/$operacao): $erro');
  }

  Future<List<Endereco>> listar(String clienteId) async {
    final snapshot = await lerComFallback(_col(clienteId));

    final lista = snapshot.docs
        .map(Endereco.fromFirestore)
        .where((e) => e.ativo)
        .toList();

    lista.sort(
      (a, b) =>
          a.logradouro.toLowerCase().compareTo(b.logradouro.toLowerCase()),
    );

    return lista;
  }

  Future<void> salvar(String clienteId, Endereco endereco) async {
    final agora = FieldValue.serverTimestamp();

    unawaited(
      _col(clienteId)
          .doc(endereco.id)
          .set({
            ...endereco.toMap(),
            'created_at': agora,
            'updated_at': agora,
            'deleted_at': null,
          })
          .catchError((Object e) => _log(e, 'salvar')),
    );
  }

  Future<void> atualizar(String clienteId, Endereco endereco) async {
    unawaited(
      _col(clienteId)
          .doc(endereco.id)
          .update({
            ...endereco.toMap(),
            'updated_at': FieldValue.serverTimestamp(),
          })
          .catchError((Object e) => _log(e, 'atualizar')),
    );
  }

  Future<void> excluir(String clienteId, String enderecoId) async {
    unawaited(
      _col(clienteId)
          .doc(enderecoId)
          .update({
            'deleted_at': Timestamp.now(),
            'updated_at': FieldValue.serverTimestamp(),
          })
          .catchError((Object e) => _log(e, 'excluir')),
    );
  }
}
