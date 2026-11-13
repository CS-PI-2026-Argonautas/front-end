
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/os.dart';

abstract class OsRepository {
  Future<List<ServiceOrder>> listarTodos();

  Future<void> salvar(ServiceOrder os);

  Future<void> deletar(String id);
}

class FirestoreOsRepository implements OsRepository {
  final FirebaseFirestore _firestore;

  FirestoreOsRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _colecao =>
      _firestore.collection('ordens_servico');

  @override
  Future<void> salvar(ServiceOrder os) async {
    if (os.client == null) {
      throw Exception('A OS precisa ter um cliente.');
    }

    if (os.serviceAddress == null) {
      throw Exception('A OS precisa ter um endereço de serviço.');
    }

    if (os.report.trim().length > ServiceOrder.reportLimit) {
      throw Exception(
        'O relatório não pode ultrapassar 256 caracteres.',
      );
    }

    if (os.values.totalCents < 0) {
      throw Exception('O total da OS não pode ser negativo.');
    }

    try {
      final documento = _colecao.doc(os.id);

      final dados = os.toFirestore();

      dados['updated_at'] = FieldValue.serverTimestamp();

      if (!os.persisted) {
        dados['created_at'] = FieldValue.serverTimestamp();
      }

      await documento.set(
        dados,
        SetOptions(merge: true),
      );

      final snapshot = await documento.get();
      final dadosSalvos = snapshot.data();

      if (dadosSalvos != null) {
        os.createdAt = dadosSalvos['created_at'] as Timestamp?;
        os.updatedAt = dadosSalvos['updated_at'] as Timestamp?;
      }

      os.markAsSaved();

      debugPrint('OS ${os.id} salva com sucesso.');
    } catch (e, stackTrace) {
      debugPrint('Erro ao salvar OS: $e');
      debugPrintStack(stackTrace: stackTrace);

      throw Exception('Erro ao salvar ordem de serviço: $e');
    }
  }

  @override
  Future<List<ServiceOrder>> listarTodos() async {
    try {
      final snapshot = await _colecao
          .where('deleted_at', isNull: true)
          .get();

      return snapshot.docs
          .map((doc) => ServiceOrder.fromFirestore(doc))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('Erro ao listar OS: $e');
      debugPrintStack(stackTrace: stackTrace);

      throw Exception('Erro ao listar ordens de serviço: $e');
    }
  }

  @override
  Future<void> deletar(String id) async {
    try {
      await _colecao.doc(id).update({
        'deleted_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      debugPrint('OS $id excluída logicamente.');
    } catch (e, stackTrace) {
      debugPrint('Erro ao excluir OS: $e');
      debugPrintStack(stackTrace: stackTrace);

      throw Exception('Erro ao excluir ordem de serviço: $e');
    }
  }
}
