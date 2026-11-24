import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/fire_base/firestore_paths.dart';
import 'package:frontend/fire_base/models/service.dart';
import 'package:frontend/fire_base/repositories/firestore_reading.dart';
import 'package:uuid/uuid.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Uuid _uuid;

  ServiceRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    Uuid? uuid,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _uuid = uuid ?? const Uuid();

  CollectionReference<Map<String, dynamic>> get _services =>
      _firestore.collection(colecaoServicos);

  void _verificarAutenticacao() {
    if (_auth.currentUser == null) {
      throw StateError('É necessário estar autenticado para acessar serviços.');
    }
  }

  Future<String> create(Service service) async {
    _verificarAutenticacao();

    final id = _uuid.v4();
    final agora = FieldValue.serverTimestamp();

    await _services.doc(id).set({
      'name': service.name.trim(),
      'description': service.description.trim(),
      'value_in_cents': service.valueInCents,
      'created_at': agora,
      'updated_at': agora,
      'deleted_at': null,
    });

    return id;
  }

  Future<void> update(Service service) async {
    _verificarAutenticacao();

    final id = service.id;

    if (id == null || id.isEmpty) {
      throw ArgumentError('ID do serviço é obrigatório para atualização.');
    }

    await _services.doc(id).update({
      'name': service.name.trim(),
      'description': service.description.trim(),
      'value_in_cents': service.valueInCents,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String id) async {
    _verificarAutenticacao();

    if (id.isEmpty) {
      throw ArgumentError('ID do serviço é obrigatório para exclusão.');
    }

    await _services.doc(id).update({
      'deleted_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> restore(String id) async {
    _verificarAutenticacao();

    if (id.isEmpty) {
      throw ArgumentError('ID do serviço é obrigatório para restauração.');
    }

    await _services.doc(id).update({
      'deleted_at': null,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<Service?> getById(String id) async {
    _verificarAutenticacao();

    if (id.isEmpty) {
      throw ArgumentError('ID do serviço é obrigatório.');
    }

    final document = await lerDocumentoComFallback(_services.doc(id));

    if (!document.exists) {
      return null;
    }

    return Service.fromFirestore(document);
  }

  Stream<List<Service>> watchServices() {
    try {
      _verificarAutenticacao();
    } catch (e) {
      return Stream.error(e);
    }

    return _services.where('deleted_at', isNull: true).snapshots().map((
      snapshot,
    ) {
      final services = snapshot.docs.map(Service.fromFirestore).toList();

      services.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      return services;
    });
  }
}
