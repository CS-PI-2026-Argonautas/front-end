import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/repositories/address_repository.dart';

class AddressService {
  final AddressRepository _repository;

  AddressService({AddressRepository? repository})
      : _repository = repository ?? AddressRepository();

  Future<List<Address>> getByClientId(String clientId) {
    return _repository.listar(clientId);
  }

  Future<void> save(String clientId, Address address) {
    _validate(address);
    return _repository.salvar(clientId, address);
  }

  Future<void> update(String clientId, Address address) {
    _validate(address);
    return _repository.atualizar(clientId, address);
  }

  Future<void> delete(String clientId, String addressId) {
    return _repository.excluir(clientId, addressId);
  }

  void _validate(Address address) {
    if (address.publicPlace.trim().isEmpty ||
        address.city.trim().isEmpty) {
      throw ArgumentError('Logradouro e cidade são obrigatórios.');
    }
  }
}