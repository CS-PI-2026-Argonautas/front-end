import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/equipment.dart';

class EquipamentoService {
  final FirebaseFirestore _firestore;

  EquipamentoService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> salvar(Equipment equipamento) async {
    final docRef = await _firestore
        .collection('equipaments')
        .add(equipamento.toFirestore());
    return docRef.id;
  }

  Future<List<Equipment>> listar() async {
    final snapshot = await _firestore
        .collection('equipments')
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) => Equipment.fromFirestore(doc)).toList();
  }
}
