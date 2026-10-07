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

    return snapshot.docs.map(Endereco.fromFirestore).toList();
  }

  /// Endereços de um cliente. Filtro por um único campo não exige índice
  /// composto; a ordenação é feita aqui na memória.
  Future<List<Endereco>> listByCliente(String clienteId) async {
    final snapshot = await _collection
        .where('clienteId', isEqualTo: clienteId)
        .get();

    final lista = snapshot.docs.map(Endereco.fromFirestore).toList();
    lista.sort((a, b) => a.rua.toLowerCase().compareTo(b.rua.toLowerCase()));

    return lista;
  }

  /// Cria o documento e devolve o id gerado.
  Future<String> save(Endereco endereco) async {
    final ref = await _collection.add(endereco.toFirestore());

    return ref.id;
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