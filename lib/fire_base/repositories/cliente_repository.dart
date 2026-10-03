import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/endereco.dart';

class ClienteRepository {
  final FirebaseFirestore _firestore;

  ClienteRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _clientes =>
      _firestore.collection('clients');

  CollectionReference<Map<String, dynamic>> get _enderecos =>
      _firestore.collection('addresses');

  /// Cadastro novo: cliente + endereços na MESMA operação (batch).
  /// Os ids são gerados no app com .doc(), então dá para já gravar o
  /// clienteId em cada endereço e ou salva tudo, ou não salva nada.
  Future<String> cadastrar(Cliente cliente, List<Endereco> enderecos) async {
    final clienteRef = _clientes.doc();
    final batch = _firestore.batch();

    batch.set(clienteRef, cliente.toFirestore());

    for (final endereco in enderecos) {
      final enderecoRef = _enderecos.doc();
      batch.set(
        enderecoRef,
        endereco.copyWith(clienteId: clienteRef.id).toFirestore(),
      );
    }

    await batch.commit();

    return clienteRef.id;
  }
}