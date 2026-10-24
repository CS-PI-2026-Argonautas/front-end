import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/repositories/firestore_reading.dart';

class ServiceOrderRepository {
  final FirebaseFirestore _firestore;

  ServiceOrderRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('ordens_servico');

  void _log(Object error, String operation) {
    debugPrint('Firestore (ordem_servico/$operation): $error');
  }

  Future<ServiceOrder?> getById(String id) async {
    final doc = await lerDocumentoComFallback(_collection.doc(id));
    if (!doc.exists) return null;
    return ServiceOrder.fromFirestore(doc);
  }

  Future<void> save(ServiceOrder serviceOrder) async {
    final reference = _collection.doc(serviceOrder.id);
    final data = serviceOrder.toFirestore();
    final now = FieldValue.serverTimestamp();
    final isFirstSave = !serviceOrder.persisted;

    final Future<void> write;

    if (isFirstSave) {
      write = reference.set({
        ...data,
        'created_at': now,
        'updated_at': now,
      });
    } else {
      final update = <String, dynamic>{
        ...data,
        'updated_at': now,
      }..remove('deleted_at');

      write = reference.set(
        update,
        SetOptions(mergeFields: update.keys.toList()),
      );
    }

    unawaited(
      write.catchError((Object error) {
        _log(error, 'save');
        if (isFirstSave) serviceOrder.persisted = false;
      }),
    );

    serviceOrder.persisted = true;

    final local = Timestamp.now();
    serviceOrder.createdAt ??= local;
    serviceOrder.updatedAt = local;
  }

  Future<void> softDelete(String id) async {
    unawaited(
      _collection
          .doc(id)
          .set({
            'deleted_at': Timestamp.now(),
            'updated_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true))
          .catchError((Object error) => _log(error, 'softDelete')),
    );
  }
}