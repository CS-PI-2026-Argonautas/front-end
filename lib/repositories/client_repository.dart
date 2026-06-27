import 'package:frontend/models/cliente.dart';

abstract class ClientRepository {

  Future <List<Cliente>> listarTodos();

  Future <void> salvar (Cliente cliente);

  Future <void> deletar (int id);

}