import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/repositories/endereco_repository.dart';

class EnderecoService {
  final EnderecoRepository _repository;

  EnderecoService({EnderecoRepository? repository})
    : _repository = repository ?? EnderecoRepository();

  Future<List<Endereco>> listar(String clienteId) {
    return _repository.listar(clienteId);
  }

  Future<void> salvar(String clienteId, Endereco endereco) {
    _validar(endereco);
    return _repository.salvar(clienteId, endereco);
  }

  Future<void> atualizar(String clienteId, Endereco endereco) {
    _validar(endereco);
    return _repository.atualizar(clienteId, endereco);
  }

  Future<void> excluir(String clienteId, String enderecoId) {
    return _repository.excluir(clienteId, enderecoId);
  }

  void _validar(Endereco endereco) {
    if (endereco.logradouro.trim().isEmpty || endereco.cidade.trim().isEmpty) {
      throw ArgumentError('Logradouro e cidade são obrigatórios.');
    }
  }
}
