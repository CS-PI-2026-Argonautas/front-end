import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/balanca.dart';

class BalancaService {
  final FirebaseFirestore _firestore;

  BalancaService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> salvar(Balanca balanca) async {
    final docRef = await _firestore
        .collection('balancas')
        .add(balanca.toFirestore());
    return docRef.id;
  }

  Future<List<Balanca>> listar() async {
    final snapshot = await _firestore
        .collection('balancas')
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) => Balanca.fromFirestore(doc)).toList();
  }
}
