import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/firestore_paths.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/repositories/leitura_firestore.dart'; 

class EnderecoRepository {
  final FirebaseFirestore _db;

  EnderecoRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> colecao(
    FirebaseFirestore db,
    String clienteId,
  ) {
    return db.collection(colecaoClientes).doc(clienteId).collection(subcolecaoEnderecos);
  }

  CollectionReference<Map<String, dynamic>> _col(String clienteId) =>
      colecao(_db, clienteId);

  void _log(Object erro, String operacao) {
    debugPrint('Firestore (endereco/$operacao): $erro');
  }

  Future<List<Address>> listar(String clienteId) async {
    final snapshot = await lerComFallback(_col(clienteId));

    final lista = snapshot.docs
        .map(Address.fromFirestore)
        .where((e) => e.ativo)
        .toList();

    lista.sort(
      (a, b) =>
          a.publicPlace.toLowerCase().compareTo(b.publicPlace.toLowerCase()),
    );

    return lista;
  }

  Future<void> salvar(String clienteId, Address endereco) async {
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

  Future<void> atualizar(String clienteId, Address endereco) async {
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
