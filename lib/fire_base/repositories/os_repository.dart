import 'package:frontend/fire_base/models/os.dart';

abstract class OsRepository {

  Future <List<OrdemServicos>> listarTodos();

  Future <void> salvar (OrdemServicos os);

  Future <void> deletar (int id);

}