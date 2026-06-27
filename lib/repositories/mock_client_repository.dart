import 'package:frontend/models/cliente.dart';
import 'package:frontend/repositories/client_repository.dart';

class MockClientRepository implements ClientRepository{

  final List<Cliente> _bd = [
    Cliente(nome: 'Giovanna', endereco: 'Rua x', info_contato: '999198999'),
  ];

  @override
  Future <List<Cliente>> listarTodos () async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_bd);
  
  }

  @override
  Future<void> salvar(Cliente cliente) async {
    await Future.delayed(const Duration(milliseconds: 300));
    cliente.id = _bd.length + 1;
    _bd.add(cliente);
  }

    @override
    Future<void> deletar(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _bd.remove(id);
  }


}