import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/repositories/firestore_reading.dart';

class OrdemServicoRepository {
  final FirebaseFirestore _firestore;

  OrdemServicoRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('ordens_servico');

  void _log(Object erro, String operacao) {
    debugPrint('Firestore (ordem_servico/$operacao): $erro');
  }

  Future<OrdemServico?> buscarPorId(String id) async {
    final doc = await lerDocumentoComFallback(_collection.doc(id));
    if (!doc.exists) return null;
    return OrdemServico.fromFirestore(doc);
  }

  Future<void> salvar(OrdemServico os) async {
    final referencia = _collection.doc(os.id);
    final dados = os.toFirestore();
    final agora = FieldValue.serverTimestamp();
    final primeiroSalvamento = !os.persistida;

    final Future<void> escrita;

    if (primeiroSalvamento) {
      escrita = referencia.set({
        ...dados,
        'created_at': agora,
        'updated_at': agora,
      });
    } else {
      final atualizacao = <String, dynamic>{
        ...dados,
        'updated_at': agora,
      }..remove('deleted_at');

      escrita = referencia.set(
        atualizacao,
        SetOptions(mergeFields: atualizacao.keys.toList()),
      );
    }

    unawaited(
      escrita.catchError((Object e) {
        _log(e, 'salvar');
        if (primeiroSalvamento) os.persistida = false;
      }),
    );

    os.marcarComoSalva();

    final local = Timestamp.now();
    os.createdAt ??= local;
    os.updatedAt = local;
  }

  Future<void> deletarLogicamente(String id) async {
    unawaited(
      _collection
          .doc(id)
          .set({
            'deleted_at': Timestamp.now(),
            'updated_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true))
          .catchError((Object e) => _log(e, 'deletar')),
    );
  }
}