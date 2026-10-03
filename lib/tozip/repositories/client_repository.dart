import 'package:frontend/fire_base/models/cliente.dart';

abstract class ClientRepository {

  Future <List<Cliente>> listarTodos();

  Future <void> salvar (Cliente cliente);

  Future <void> deletar (int id);

}