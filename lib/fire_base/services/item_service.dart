import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/repositories/item_repository.dart';

class ItemService {
  final ItemRepository _repository;

  ItemService(this._repository);

  Future<void> create(Item item) async {
    _validate(item);

    await _repository.create(item);
  }


  Future<void> update(Item item) async {
    if (item.id == null) {
      throw ArgumentError('Item ID is required for update.');
    }

    _validate(item);

    await _repository.update(item);
  }

  Future<void> delete(Item item) async {
    if (item.id == null) {
      throw ArgumentError('Item ID is required for deletion.');
    }

    await _repository.delete(item.id!);
  }

  Future<Item?> getById(String id) async {
    return _repository.getById(id);
  }

  Stream<List<Item>> watchItems() {
    return _repository.watchItems();
  }

  Stream<List<Item>> watchParts() {
    return _repository.watchParts();
  }

  void _validate(Item item) {
    if (item.name.trim().isEmpty) {
      throw ArgumentError('Item name is required.');
    }

    if (item.description != null &&
        item.description!.length > 50) {
      throw ArgumentError(
        'Item description cannot exceed 50 characters.',
      );
    }

    if (item.valueInCents < 0) {
      throw ArgumentError(
        'Item value cannot be negative.',
      );
    }
  }
}