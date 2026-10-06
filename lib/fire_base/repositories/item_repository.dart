import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/TiposItens.dart';
import 'package:uuid/uuid.dart';
import '../models/item.dart';

class ItemRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  ItemRepository({
    FirebaseFirestore? firestore,
    Uuid? uuid,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _uuid = uuid ?? const Uuid();

  CollectionReference<Map<String, dynamic>> get _itemsCollection =>
      _firestore.collection('itens');

  Future<void> create(Item item) async {
    final String id = _uuid.v4();

    await _itemsCollection.doc(id).set({
      'nome': item.name,
      'descricao': item.description,
      'valor_centavos': item.valueInCents,
      'quantidade_minima': item.minimumQuantity,
      'tipo': _typeToFirestore(item),
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'deleted_at': null,
    });
  }

  Future<void> update(Item item) async {
    await _itemsCollection.doc(item.id).update({
      'nome': item.name,
      'descricao': item.description,
      'valor_centavos': item.valueInCents,
      'quantidade_minima': item.minimumQuantity,
      'tipo': _typeToFirestore(item),
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
    return _itemsCollection
        .where('deleted_at', isNull: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((document) => Item.fromFirestore(document))
          .toList();
    });
  }

  Stream<List<Item>> watchParts() {
    return _itemsCollection
        .where('tipo', isEqualTo: 'PECAS')
        .where('deleted_at', isNull: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((document) => Item.fromFirestore(document))
          .toList();
    });
  }

  String _typeToFirestore(Item item) {
    switch (item.type) {
      case TipoProduto.pecas:
        return 'PECAS';

      case TipoProduto.balancas:
        return 'BALANCAS';
    }
  }
}