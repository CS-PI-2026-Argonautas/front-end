import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/repositories/address_repository.dart';

class AddressService {
  final AddressRepository _repository;

  AddressService({AddressRepository? repository})
    : _repository = repository ?? AddressRepository();

  Future<List<Address>> listar(String clienteId) {
    return _repository.listar(clienteId);
  }

  Future<void> salvar(String clienteId, Address endereco) {
    _validar(endereco);
    return _repository.salvar(clienteId, endereco);
  }

  Future<void> atualizar(String clienteId, Address endereco) {
    _validar(endereco);
    return _repository.atualizar(clienteId, endereco);
  }

  Future<void> excluir(String clienteId, String enderecoId) {
    return _repository.excluir(clienteId, enderecoId);
  }

  void _validar(Address endereco) {
    if (endereco.publicPlace.trim().isEmpty ||
        endereco.city.trim().isEmpty) {
      throw ArgumentError('Logradouro e cidade são obrigatórios.');
    }
  }
}
