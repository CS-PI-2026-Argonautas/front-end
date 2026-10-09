import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/firestore_paths.dart';
import 'package:frontend/fire_base/models/client.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/repositories/endereco_repository.dart';
import 'package:frontend/fire_base/repositories/leitura_firestore.dart'; 

class ClienteRepository {
  final FirebaseFirestore _db;

  ClienteRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _clientes =>
      _db.collection(colecaoClientes);

  CollectionReference<Map<String, dynamic>> _enderecos(String clienteId) =>
      EnderecoRepository.colecao(_db, clienteId);

  void _enviar(WriteBatch batch, String operacao) {
    unawaited(
      batch.commit().catchError((Object e) {
        debugPrint('Firestore (cliente/$operacao): $e');
      }),
    );
  }

  List<Client> _ativos(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final lista = snapshot.docs
        .map(Client.fromFirestore)
        .where((c) => c.ativo)
        .toList();

    lista.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return lista;
  }

  Stream<List<Client>> observar() => _clientes.snapshots().map(_ativos);

  Future<List<Client>> listar() async => _ativos(await lerComFallback(_clientes));

  Future<List<Client>> listarDoCache() async {
    try {
      final snapshot = await _clientes.get(
        const GetOptions(source: Source.cache),
      );
      return _ativos(snapshot);
    } catch (_) {
      return [];
    }
  }

  Future<void> cadastrar(Client cliente, List<Address> enderecos) async {
    final batch = _db.batch();
    final agora = FieldValue.serverTimestamp();

    batch.set(_clientes.doc(cliente.id), {
      ...cliente.toMap(),
      'created_at': agora,
      'updated_at': agora,
      'deleted_at': null,
    });

    for (final endereco in enderecos) {
      batch.set(_enderecos(cliente.id).doc(endereco.id), {
        ...endereco.toMap(),
        'created_at': agora,
        'updated_at': agora,
        'deleted_at': null,
      });
    }

    _enviar(batch, 'cadastrar');
  }

  Future<void> atualizar(
    Client cliente,
    List<Address> originais,
    List<Address> atuais,
  ) async {
    final batch = _db.batch();
    final agora = FieldValue.serverTimestamp();

    batch.update(_clientes.doc(cliente.id), {
      ...cliente.toMap(),
      'updated_at': agora,
    });

    final antigos = {for (final e in originais) e.id: e};
    final idsAtuais = {for (final e in atuais) e.id};

    for (final endereco in atuais) {
      final ref = _enderecos(cliente.id).doc(endereco.id);
      final antigo = antigos[endereco.id];

      if (antigo == null) {
        batch.set(ref, {
          ...endereco.toMap(),
          'created_at': agora,
          'updated_at': agora,
          'deleted_at': null,
        });
      } else if (!antigo.mesmosDados(endereco)) {
        batch.update(ref, {...endereco.toMap(), 'updated_at': agora});
      }
    }

    final exclusao = Timestamp.now();
    for (final removido in originais.where((e) => !idsAtuais.contains(e.id))) {
      batch.update(_enderecos(cliente.id).doc(removido.id), {
        'deleted_at': exclusao,
        'updated_at': agora,
      });
    }

    _enviar(batch, 'atualizar');
  }

  Future<void> excluir(String id) async {
    final enderecos = await lerComFallback(_enderecos(id));
    final batch = _db.batch();
    final agora = FieldValue.serverTimestamp();
    final exclusao = Timestamp.now();

    batch.update(_clientes.doc(id), {
      'deleted_at': exclusao,
      'updated_at': agora,
    });

    for (final doc in enderecos.docs) {
      if (doc.data()['deleted_at'] == null) {
        batch.update(doc.reference, {
          'deleted_at': exclusao,
          'updated_at': agora,
        });
      }
    }

    _enviar(batch, 'excluir');
  }

  Future<void> restaurar(String id) async {
    final doc = await lerDocumentoComFallback(_clientes.doc(id));
    final exclusao = doc.data()?['deleted_at'];

    final batch = _db.batch();
    final agora = FieldValue.serverTimestamp();

    batch.update(_clientes.doc(id), {'deleted_at': null, 'updated_at': agora});

    if (exclusao is Timestamp) {
      final enderecos = await lerComFallback(_enderecos(id)); // [ALTERADO]

      for (final endereco in enderecos.docs) {
        if (endereco.data()['deleted_at'] == exclusao) {
          batch.update(endereco.reference, {
            'deleted_at': null,
            'updated_at': agora,
          });
        }
      }
    }

    _enviar(batch, 'restaurar');
  }
}
