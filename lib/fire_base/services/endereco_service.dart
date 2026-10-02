import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/repositories/endereco_repository.dart';

class EnderecoService {
  final EnderecoRepository _repository;

  EnderecoService({
    EnderecoRepository? repository,
  }) : _repository = repository ?? EnderecoRepository();

  Future<List<Endereco>> listAll() async {
    return await _repository.listAll();
  }

  Future<void> save(Endereco endereco) async {
    await _repository.save(endereco);
  }

  Future<void> update(
    String id,
    Endereco endereco,
  ) async {
    await _repository.update(id, endereco);
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
  }
}
