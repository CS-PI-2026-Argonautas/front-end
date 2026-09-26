import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/services.dart';

class ServicesRepository {
  final FirebaseFirestore _firestore;

  ServicesRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('service_orders');

  Future<List<Services>> listAll() async {
    final snapshot = await _collection.get();

    final orders = snapshot.docs
        .map(Services.fromFirestore)
        .where((order) => !order.isDeleted)
        .toList();

    orders.sort((a, b) {
      final dateA = a.createdAt;
      final dateB = b.createdAt;

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateB.compareTo(dateA);
    });

    return orders;
  }

  Future<void> save(Services order) async {
    await _collection.doc(order.id).set(
      order.toFirestore(),
    );
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).update({
      'deleted_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> restore(String id) async {
    await _collection.doc(id).update({
      'deleted_at': null,
    });
  }
}