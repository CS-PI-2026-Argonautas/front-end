import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/fire_base/Enums/ItemType.dart';
import 'package:frontend/fire_base/models/item.dart';

class ItemRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  ItemRepository({FirebaseFirestore? firestore, Uuid? uuid})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _uuid = uuid ?? const Uuid();

  CollectionReference<Map<String, dynamic>> get _itemsCollection =>
      _firestore.collection('itens');

  Future<void> create(Item item) async {
    final String id = _uuid.v4();

    await _itemsCollection.doc(id).set({
      'name': item.name,
      'description': item.description,
      'value_in_cents': item.valueInCents,
      'minimum_quantity': item.minimumQuantity,
      'type': _typeToFirestore(item),
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'deleted_at': null,
    });
  }

  Future<void> update(Item item) async {
    if (item.id == null) {
      throw ArgumentError('Item ID is required for update.');
    }

    await _itemsCollection.doc(item.id).update({
      'name': item.name,
      'description': item.description,
      'value_in_cents': item.valueInCents,
      'minimum_quantity': item.minimumQuantity,
      'type': _typeToFirestore(item),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String id) async {
    await _itemsCollection.doc(id).update({
      'deleted_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<Item?> getById(String id) async {
    final document = await _itemsCollection.doc(id).get();

    if (!document.exists) {
      return null;
    }

    return Item.fromFirestore(document);
  }

  Stream<List<Item>> watchItems() {
    return _itemsCollection.where('deleted_at', isNull: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map(Item.fromFirestore).toList();
    });
  }

  Stream<List<Item>> watchParts() {
    return _itemsCollection
        .where('tipo', isEqualTo: 'PECAS')
        .where('deleted_at', isNull: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map(Item.fromFirestore).toList();
        });
  }

  String _typeToFirestore(Item item) {
    switch (item.type) {
      case ItemType.parts:
        return 'PECAS';

      case ItemType.scales:
        return 'BALANCAS';
    }
  }
}
