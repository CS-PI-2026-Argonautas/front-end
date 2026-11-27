import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/repositories/item_repository.dart';

class ItemService {
  final ItemRepository _repository;

  ItemService({ItemRepository? repository})
    : _repository = repository ?? ItemRepository();

  Future<String> create(Item item) async {
    _validate(item);
    return await _repository.create(item);
  }

  Future<void> update(Item item) async {
    if (item.id == null || item.id!.isEmpty) {
      throw ArgumentError('ID do item é obrigatório para edição.');
    }

    _validate(item);
    await _repository.update(item);
  }

  Future<void> delete(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('ID do item é obrigatório para exclusão.');
    }

    await _repository.delete(id);
  }

  Future<void> restore(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('ID do item é obrigatório para restauração.');
    }

    await _repository.restore(id);
  }

  Future<Item?> getById(String id) {
    if (id.trim().isEmpty) {
      throw ArgumentError('ID do item é obrigatório.');
    }

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
      throw ArgumentError('Informe o nome do item.');
    }

    if (item.description != null && item.description!.trim().length > 50) {
      throw ArgumentError('A descrição não pode ultrapassar 50 caracteres.');
    }

    if (item.valueInCents <= 0) {
      throw ArgumentError('O valor do item deve ser maior que zero.');
    }

    if (item.minimumQuantity < 0) {
      throw ArgumentError('A quantidade mínima não pode ser negativa.');
    }
  }
}
