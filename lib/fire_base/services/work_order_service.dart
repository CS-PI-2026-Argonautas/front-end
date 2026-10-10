import 'package:frontend/fire_base/models/work_order.dart';
import 'package:frontend/fire_base/repositories/work_order_repository.dart';

class WorkOrderService {
  final WorkOrderRepository _repository;

  WorkOrderService({
    WorkOrderRepository? repository,
  }) : _repository = repository ?? WorkOrderRepository();

  Future<List<WorkOrder>> listAll() async {
    return await _repository.listAll();
  }

  Future<void> save(WorkOrder order) async {
    await _repository.save(order);
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
  }

  Future<void> restore(String id) async {
    await _repository.restore(id);
  }
}