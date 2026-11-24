import 'package:frontend/fire_base/models/service.dart';
import 'package:frontend/fire_base/repositories/service_repository.dart';

class ServiceService {
  final ServiceRepository _repository;

  ServiceService({ServiceRepository? repository})
    : _repository = repository ?? ServiceRepository();

  Future<String> create(Service service) async {
    _validate(service);
    return await _repository.create(service);
  }

  Future<void> update(Service service) async {
    if (service.id == null || service.id!.isEmpty) {
      throw ArgumentError('ID do serviço é obrigatório para edição.');
    }

    _validate(service);
    await _repository.update(service);
  }

  Future<void> delete(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('ID do serviço é obrigatório para exclusão.');
    }

    await _repository.delete(id);
  }

  Future<void> restore(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('ID do serviço é obrigatório para restauração.');
    }

    await _repository.restore(id);
  }

  Future<Service?> getById(String id) {
    if (id.trim().isEmpty) {
      throw ArgumentError('ID do serviço é obrigatório.');
    }

    return _repository.getById(id);
  }

  Stream<List<Service>> watchServices() {
    return _repository.watchServices();
  }

  void _validate(Service service) {
    if (service.name.trim().isEmpty) {
      throw ArgumentError('Informe o nome do serviço.');
    }

    if (service.description.trim().length > 50) {
      throw ArgumentError('A descrição não pode ultrapassar 50 caracteres.');
    }

    if (service.valueInCents <= 0) {
      throw ArgumentError('O valor do serviço deve ser maior que zero.');
    }
  }
}
