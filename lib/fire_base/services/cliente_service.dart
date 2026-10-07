import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/repositories/cliente_repository.dart';

class ClienteService {
  final ClienteRepository _repository;

  ClienteService({ClienteRepository? repository})
      : _repository = repository ?? ClienteRepository();

  Future<List<Cliente>> listar() async {
    return await _repository.listar();
  }

  /// Devolve o id gerado para o cliente.
  Future<String> cadastrar(Cliente cliente, List<Endereco> enderecos) async {
    _validar(cliente);
    return await _repository.cadastrar(cliente, enderecos);
  }

  Future<void> atualizar(Cliente cliente, List<Endereco> enderecos) async {
    _validar(cliente);
    await _repository.atualizar(cliente, enderecos);
  }

  Future<void> remover(String id) async {
    await _repository.definirRemovido(id, true);
  }

  Future<void> restaurar(String id) async {
    await _repository.definirRemovido(id, false);
  }

  void _validar(Cliente cliente) {
    if (cliente.nome.trim().isEmpty) {
      throw ArgumentError('Informe o nome do cliente.');
    }
  }
}