import 'package:frontend/fire_base/models/client.dart';

abstract class ClientRepository {
  Future<List<Client>> listarTodos();

  Future<void> salvar(Client cliente);

  Future<void> deletar(String id);
}
