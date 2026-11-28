import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/fire_base/Enums/ProductType.dart';
import 'package:frontend/fire_base/firestore_paths.dart';
import 'package:frontend/fire_base/models/item.dart';
import 'package:uuid/uuid.dart';

class ItemRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Uuid _uuid;

  ItemRepository({FirebaseFirestore? firestore, FirebaseAuth? auth, Uuid? uuid})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance,
      _uuid = uuid ?? const Uuid();

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection(colecaoItems);

  void _verificarAutenticacao() {
    if (_auth.currentUser == null) {
      throw StateError('É necessário estar autenticado para acessar os itens.');
    }
  }

  Future<String> create(Item item) async {
    _verificarAutenticacao();

    final id = _uuid.v4();
    final agora = FieldValue.serverTimestamp();

    await _items.doc(id).set({
      'name': item.name.trim(),
      'description': item.description?.trim(),
      'value_in_cents': item.valueInCents,
      'minimum_quantity': item.minimumQuantity,
      'type': _typeToFirestore(item.type),
      'created_at': agora,
      'updated_at': agora,
      'deleted_at': null,
    });

    return id;
  }

  Future<void> update(Item item) async {
    _verificarAutenticacao();

    final id = item.id;

    if (id == null || id.isEmpty) {
      throw ArgumentError('ID do item é obrigatório para atualização.');
    }

    await _items.doc(id).update({
      'name': item.name.trim(),
      'description': item.description?.trim(),
      'value_in_cents': item.valueInCents,
      'minimum_quantity': item.minimumQuantity,
      'type': _typeToFirestore(item.type),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String id) async {
    _verificarAutenticacao();

    if (id.trim().isEmpty) {
      throw ArgumentError('ID do item é obrigatório para exclusão.');
    }

    await _items.doc(id).update({
      'deleted_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> restore(String id) async {
    _verificarAutenticacao();

    if (id.trim().isEmpty) {
      throw ArgumentError('ID do item é obrigatório para restauração.');
    }

    await _items.doc(id).update({
      'deleted_at': null,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<Item?> getById(String id) async {
    _verificarAutenticacao();

    if (id.trim().isEmpty) {
      throw ArgumentError('ID do item é obrigatório.');
    }

    final document = await _items.doc(id).get();

    if (!document.exists) {
      return null;
    }

    return Item.fromFirestore(document);
  }

  Stream<List<Item>> watchItems() {
    try {
      _verificarAutenticacao();
    } catch (e) {
      return Stream.error(e);
    }

    return _items.where('deleted_at', isNull: true).snapshots().map((snapshot) {
      final items = snapshot.docs.map(Item.fromFirestore).toList();

      items.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      return items;
    });
  }

  Stream<List<Item>> watchParts() {
    try {
      _verificarAutenticacao();
    } catch (e) {
      return Stream.error(e);
    }

    return _items
        .where('type', isEqualTo: 'PECAS')
        .where('deleted_at', isNull: true)
        .snapshots()
        .map((snapshot) {
          final items = snapshot.docs.map(Item.fromFirestore).toList();

          items.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

          return items;
        });
  }

  String _typeToFirestore(ProductType type) {
    switch (type) {
      case ProductType.parts:
        return 'PECAS';
      case ProductType.scales:
        return 'BALANCAS';
    }
  }
}
