
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
      _firestore.collection('service_orders');

  DocumentReference<Map<String, dynamic>> get _contador =>
      _firestore.collection('counters').doc('service_orders');

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

      int? numeroAtribuido;

      await _firestore.runTransaction((transaction) async {
        // Todas as leituras precisam ocorrer antes das escritas.
        final osSnapshot = await transaction.get(documento);
        final contadorSnapshot = await transaction.get(_contador);

        final dadosExistentes = osSnapshot.data();

        final numeroExistente = dadosExistentes?['numero_os'];

        if (numeroExistente is num) {
          // Atualização: preserva o número já atribuído.
          numeroAtribuido = numeroExistente.toInt();
        } else {
          // Primeira gravação ou OS antiga sem numeração.
          final ultimoNumero =
              contadorSnapshot.data()?['last_number'];

          final ultimoNumeroValido =
              ultimoNumero is num ? ultimoNumero.toInt() : 0;

          numeroAtribuido = ultimoNumeroValido + 1;

          transaction.set(_contador, {
            'last_number': numeroAtribuido,
            'updated_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }

        final dados = os.toFirestore();

        dados['numero_os'] = numeroAtribuido;
        dados['updated_at'] = FieldValue.serverTimestamp();

        if (!osSnapshot.exists) {
          dados['created_at'] = FieldValue.serverTimestamp();
        }

        transaction.set(
          documento,
          dados,
          SetOptions(merge: true),
        );
      });

      // Atualiza o objeto somente depois do commit.
      os.numeroOs = numeroAtribuido;

      final snapshot = await documento.get();
      final dadosSalvos = snapshot.data();

      if (dadosSalvos != null) {
        os.createdAt = dadosSalvos['created_at'] as Timestamp?;
        os.updatedAt = dadosSalvos['updated_at'] as Timestamp?;
      }

      os.markAsSaved();

      debugPrint(
        'OS Nº ${os.numeroOs} (${os.id}) salva com sucesso.',
      );
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

      final ordens = snapshot.docs
          .map((doc) => ServiceOrder.fromFirestore(doc))
          .toList();

      // Ordena pelo número da OS, da mais recente para a mais antiga.
      ordens.sort((a, b) {
        return (b.numeroOs ?? 0).compareTo(a.numeroOs ?? 0);
      });

      return ordens;
    } catch (e, stackTrace) {
      debugPrint('Erro ao listar OS: $e');
      debugPrintStack(stackTrace: stackTrace);

      throw Exception('Erro ao listar ordens de serviço: $e');
    }
  }
@override
Future<ServiceOrder?> buscarPorId(String id) async {
  try {
    final doc = await _colecao.doc(id).get();

    if (!doc.exists) return null;

    final os = ServiceOrder.fromFirestore(doc);

    // OS excluída logicamente não pode ser editada.
    if (!os.active) return null;

    return os;
  } catch (e, stackTrace) {
    debugPrint('Erro ao buscar OS: $e');
    debugPrintStack(stackTrace: stackTrace);

    throw Exception('Erro ao buscar ordem de serviço: $e');
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
