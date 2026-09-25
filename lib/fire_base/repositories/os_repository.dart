import 'package:frontend/fire_base/models/os.dart';

abstract class OsRepository {

  Future <List<ServiceOrder>> listarTodos();

  Future <void> salvar (ServiceOrder os);

  Future <void> deletar (int id);

}