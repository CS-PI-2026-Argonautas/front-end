import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/os.dart';

abstract class OsRepository {
  Future<List<ServiceOrder>> listarTodos();

  Future<ServiceOrder?> buscarPorId(String id);

  Future<void> salvar(ServiceOrder os);
  Future<void> salvarRascunho(ServiceOrder os);

  Future<void> deletar(String id);
}

class FirestoreOsRepository implements OsRepository {
  final FirebaseFirestore _firestore;

  FirestoreOsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _colecao =>
      _firestore.collection('service_orders');

  DocumentReference<Map<String, dynamic>> get _contador =>
      _firestore.collection('counters').doc('service_orders');

  @override
  Future<void> salvarRascunho(ServiceOrder os) {
    final dados = os.toFirestore()
      ..remove('numero_os')
      ..['updated_at'] = FieldValue.serverTimestamp();

    if (os.persisted) {
      dados.remove('deleted_at');
      if (os.equipmentBlocked) {
        dados.remove('equipamento');
      } else {
        dados.remove('equipamento_bloqueado');
      }
    } else {
      dados['created_at'] = os.createdAt ??= Timestamp.now();
    }

    return _colecao
        .doc(os.id)
        .set(dados, SetOptions(mergeFields: dados.keys.toList()));
  }

  @override
  Future<void> salvar(ServiceOrder os) async {
    if (os.client == null) {
      throw Exception('A OS precisa ter um cliente.');
    }

    if (os.serviceAddress == null) {
      throw Exception('A OS precisa ter um endereço de serviço.');
    }

    if (os.report.trim().length > ServiceOrder.reportLimit) {
      throw Exception('O relatório não pode ultrapassar 256 caracteres.');
    }

    if (os.values.totalCents < 0) {
      throw Exception('O total da OS não pode ser negativo.');
    }

    try {
      final documento = _colecao.doc(os.id);

      if (os.persisted && os.numeroOs != null && os.equipmentBlocked) {
        await _salvarBloqueioNaFila(documento, os);
        os.markAsSaved();
        return;
      }

      int? numeroAtribuido;

      await _firestore.runTransaction((transaction) async {
        final osSnapshot = await transaction.get(documento);
        final contadorSnapshot = await transaction.get(_contador);

        final dadosExistentes = osSnapshot.data();
        final numeroExistente = dadosExistentes?['numero_os'];

        if (numeroExistente is num) {
          numeroAtribuido = numeroExistente.toInt();
        } else {
          final ultimoNumero = contadorSnapshot.data()?['last_number'];

          final ultimoNumeroValido = ultimoNumero is num
              ? ultimoNumero.toInt()
              : 0;

          numeroAtribuido = ultimoNumeroValido + 1;

          transaction.set(_contador, {
            'last_number': numeroAtribuido,
            'updated_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }

        final dados = os.toFirestore();
        if (osSnapshot.exists && !os.equipmentBlocked) {
          dados.remove('equipamento_bloqueado');
        }

        dados['numero_os'] = numeroAtribuido;
        dados['updated_at'] = FieldValue.serverTimestamp();

        if (!osSnapshot.exists) {
          dados['created_at'] = FieldValue.serverTimestamp();
        }

        transaction.set(documento, dados, SetOptions(merge: true));
      });

      os.numeroOs = numeroAtribuido;

      final snapshot = await documento.get();
      final dadosSalvos = snapshot.data();

      if (dadosSalvos != null) {
        if (dadosSalvos['equipamento_bloqueado'] == true) {
          os.equipmentBlocked = true;
        }
        os.createdAt = dadosSalvos['created_at'] as Timestamp?;
        os.updatedAt = dadosSalvos['updated_at'] as Timestamp?;
      }

      os.markAsSaved();

      debugPrint('OS Nº ${os.numeroOs} (${os.id}) salva com sucesso.');
    } catch (e, stackTrace) {
      debugPrint('Erro ao salvar OS: $e');
      debugPrintStack(stackTrace: stackTrace);

      throw Exception('Erro ao salvar ordem de serviço: $e');
    }
  }

  Future<void> _salvarBloqueioNaFila(
    DocumentReference<Map<String, dynamic>> documento,
    ServiceOrder os,
  ) async {
    final dados = os.toFirestore()
      ..remove('numero_os')
      ..['updated_at'] = FieldValue.serverTimestamp();
    final confirmacaoLocal = Completer<void>();

    final gravacao = documento
        .set(dados, SetOptions(merge: true))
        .then<void>(
          (_) {},
          onError: (Object erro, StackTrace stackTrace) {
            if (confirmacaoLocal.isCompleted) {
              debugPrint(
                'Erro ao sincronizar o bloqueio da OS ${os.id}: $erro',
              );
            }
            Error.throwWithStackTrace(erro, stackTrace);
          },
        );

    final observacao = documento
        .snapshots(includeMetadataChanges: true)
        .listen(
          (snapshot) {
            final dadosLocais = snapshot.data();
            if (!confirmacaoLocal.isCompleted &&
                snapshot.metadata.hasPendingWrites &&
                dadosLocais?['equipamento_bloqueado'] == true &&
                dadosLocais?['status'] == dados['status'] &&
                dadosLocais?['data_saida'] == dados['data_saida']) {
              confirmacaoLocal.complete();
            }
          },
          onError: (Object erro, StackTrace stackTrace) {
            if (!confirmacaoLocal.isCompleted) {
              confirmacaoLocal.completeError(erro, stackTrace);
            }
          },
        );

    try {
      await Future.any([gravacao, confirmacaoLocal.future]);
    } finally {
      await observacao.cancel();
    }
  }

  @override
  Future<List<ServiceOrder>> listarTodos() async {
    try {
      final snapshot = await _colecao.where('deleted_at', isNull: true).get();

      final ordens = snapshot.docs
          .map((doc) => ServiceOrder.fromFirestore(doc))
          .toList();

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
