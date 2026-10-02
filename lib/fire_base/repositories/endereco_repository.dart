import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/endereco.dart';

class EnderecoRepository {
  final FirebaseFirestore _firestore;

  EnderecoRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('addresses');

  Future<List<Endereco>> listAll() async {
    final snapshot = await _collection.get();

    return snapshot.docs
        .map(Endereco.fromFirestore)
        .toList();
  }

  Future<void> save(Endereco endereco) async {
    await _collection.add(
      endereco.toFirestore(),
    );
  }

  Future<void> update(
    String id,
    Endereco endereco,
  ) async {
    await _collection.doc(id).update(
      endereco.toFirestore(),
    );
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
