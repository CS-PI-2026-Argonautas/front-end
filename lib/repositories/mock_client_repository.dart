import 'package:frontend/models/cliente.dart';
import 'package:frontend/repositories/client_repository.dart';

class MockClientRepository implements ClientRepository {
  //instancia interna  (precisa pro front funcionar)
  static final MockClientRepository _instance =
      MockClientRepository._internal();

  MockClientRepository._internal();

  factory MockClientRepository() => _instance;

  final List<Cliente> _bd = [
    Cliente(nome: 'Giovanna', endereco: 'Rua x', info_contato: '999198999'),
    Cliente(nome: 'Murilo', endereco: 'Rua y', info_contato: '111111111'),
    Cliente(nome: 'Isaque', endereco: 'Rua p', info_contato: '411819111'),
    Cliente(nome: 'Maria', endereco: 'Rua j', info_contato: '111311311'),
    Cliente(nome: 'Felipe', endereco: 'Rua w', info_contato: '112219171'),
    Cliente(nome: 'Arthur', endereco: 'Rua w', info_contato: '812333178'),
  ];

  @override
  Future<List<Cliente>> listarTodos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // lista apenas os clientes que não estiverem com a tag 'removido' ativa, ao implementar o backend isso será revisto
    return List.unmodifiable(_bd.where((cliente) => !cliente.removido));
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
