import 'package:frontend/fire_base/models/so.dart';
import 'package:frontend/fire_base/repositories/service_order_repository.dart';

class ServiceOrderService {
  final ServiceOrderRepository _repository;

  ServiceOrderService({
    ServiceOrderRepository? repository,
  }) : _repository = repository ?? ServiceOrderRepository();

  Future<List<ServiceOrder>> listAll() async {
    return await _repository.listAll();
  }

  Future<void> save(ServiceOrder order) async {
    await _repository.save(order);
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
  }

  Future<void> restore(String id) async {
    await _repository.restore(id);
  }
}