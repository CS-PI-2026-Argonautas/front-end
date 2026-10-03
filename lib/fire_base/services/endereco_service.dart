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

  Future<List<Endereco>> listByCliente(String clienteId) async {
    return await _repository.listByCliente(clienteId);
  }

  /// Salva (cria ou atualiza, conforme o id) um endereço de um cliente
  /// que já existe no banco.
  Future<Endereco> saveForCliente(String clienteId, Endereco endereco) async {
    final comCliente = endereco.copyWith(clienteId: clienteId);

    if (comCliente.id == null) {
      final id = await _repository.save(comCliente);
      return comCliente.copyWith(id: id);
    }

    await _repository.update(comCliente.id!, comCliente);
    return comCliente;
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
  }
}
