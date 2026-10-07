import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/equipamento.dart';

class EquipamentoService {
  final FirebaseFirestore _firestore;

  EquipamentoService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> salvar(Equipamento equipamento) async {
    final docRef = await _firestore
        .collection('equipamentos')
        .add(equipamento.toFirestore());
    return docRef.id;
  }

  Future<List<Equipamento>> listar() async {
    final snapshot = await _firestore
        .collection('equipamentos')
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) => Equipamento.fromFirestore(doc)).toList();
  }
}
