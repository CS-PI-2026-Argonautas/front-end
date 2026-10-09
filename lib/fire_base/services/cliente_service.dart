import 'package:frontend/fire_base/Enums/PersonType.dart';
import 'package:frontend/fire_base/models/client.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/repositories/cliente_repository.dart';

class ClienteService {
  final ClienteRepository _repository;

  ClienteService({ClienteRepository? repository})
    : _repository = repository ?? ClienteRepository();

  Stream<List<Client>> observar() => _repository.observar();

  Future<List<Client>> listar() => _repository.listar();

  Future<void> cadastrar(Client cliente, List<Endereco> enderecos) async {
    _validar(cliente);
    await _repository.cadastrar(cliente, enderecos);
  }

  Future<void> atualizar(
    Client cliente,
    List<Endereco> originais,
    List<Endereco> atuais,
  ) async {
    _validar(cliente);
    await _repository.atualizar(cliente, originais, atuais);
  }

  Future<void> excluir(String id) => _repository.excluir(id);

  Future<void> restaurar(String id) => _repository.restaurar(id);

  static String? validarDocumento(String valor, PersonType tipo) {
    final digitos = Client.somenteDigitos(valor);

    if (digitos.isEmpty) return 'Informe o ${tipo.rotuloDocumento}';

    if (digitos.length != tipo.documentSize) {
      return '${tipo.rotuloDocumento} deve ter '
          '${tipo.documentSize} dígitos';
    }

    return null;
  }

  void _validar(Client cliente) {
    if (cliente.name.trim().isEmpty) {
      throw ArgumentError('Informe o nome do cliente.');
    }
    if (cliente.contact.telefone.trim().isEmpty) {
      throw ArgumentError('Informe o telefone do cliente.');
    }

    final erroDocumento = validarDocumento(
      cliente.document,
      cliente.personType,
    );
    if (erroDocumento != null) throw ArgumentError(erroDocumento);
  }

  Future<Client?> buscarDuplicado(
    String documento, {
    String? ignorarId,
  }) async {
    final carregados = await _repository.listarDoCache();

    return encontrarDuplicado(documento, carregados, ignorarId: ignorarId);
  }

  static Client? encontrarDuplicado(
    String documento,
    Iterable<Client> carregados, {
    String? ignorarId,
  }) {
    final digitos = Client.somenteDigitos(documento);
    if (digitos.isEmpty) return null;

    for (final cliente in carregados) {
      if (cliente.id != ignorarId && cliente.document == digitos) {
        return cliente;
      }
    }

    return null;
  }
}
