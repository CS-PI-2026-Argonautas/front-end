import 'package:frontend/fire_base/models/services.dart';
import 'package:frontend/fire_base/repositories/service_repository.dart';

class ServiceS {
  final ServicesRepository _repository;

  ServiceS({
    ServicesRepository? repository,
  }) : _repository = repository ?? ServicesRepository();

  Future<List<Services>> listAll() async {
    return await _repository.listAll();
  }

  Future<void> save(Services order) async {
    await _repository.save(order);
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
  }

  Future<void> restore(String id) async {
    await _repository.restore(id);
  }
}