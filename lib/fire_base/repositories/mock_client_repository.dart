import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/TipoPessoa.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/contato.dart';
import 'package:frontend/fire_base/repositories/client_old_repository.dart';

class MockClientRepository implements ClientRepository {
  static final MockClientRepository _instance =
      MockClientRepository._internal();

  MockClientRepository._internal();

  factory MockClientRepository() => _instance;

  static Cliente _fisica(String nome, String documento, String telefone) {
    return Cliente(
      nome: nome,
      tipoPessoa: TipoPessoa.fisica,
      documento: documento,
      contato: Contato(telefone: telefone),
    );
  }

  final List<Cliente> _bd = [
    _fisica('Giovanna', '00000000001', '999198999'),
    _fisica('Murilo', '00000000002', '111111111'),
    _fisica('Isaque', '00000000003', '411819111'),
    _fisica('Maria', '00000000004', '111311311'),
    _fisica('Felipe', '00000000005', '112219171'),
    _fisica('Arthur', '00000000006', '812333178'),
  ];

  @override
  Future<List<Cliente>> listarTodos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_bd.where((cliente) => cliente.ativo));
  }

  @override
  Future<void> salvar(Cliente cliente) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _bd.add(cliente);
  }

  @override
  Future<void> deletar(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (final cliente in _bd.where((c) => c.id == id)) {
      cliente.deletedAt = Timestamp.now();
    }
  }
}
