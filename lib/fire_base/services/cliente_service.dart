import 'package:frontend/fire_base/Enums/TipoPessoa.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/repositories/cliente_repository.dart';

class ClienteService {
  final ClienteRepository _repository;

  ClienteService({ClienteRepository? repository})
    : _repository = repository ?? ClienteRepository();

  Stream<List<Cliente>> observar() => _repository.observar();

  Future<List<Cliente>> listar() => _repository.listar();

  Future<void> cadastrar(Cliente cliente, List<Endereco> enderecos) async {
    _validar(cliente);
    await _repository.cadastrar(cliente, enderecos);
  }

  Future<void> atualizar(
    Cliente cliente,
    List<Endereco> originais,
    List<Endereco> atuais,
  ) async {
    _validar(cliente);
    await _repository.atualizar(cliente, originais, atuais);
  }

  Future<void> excluir(String id) => _repository.excluir(id);

  Future<void> restaurar(String id) => _repository.restaurar(id);

  static String? validarDocumento(String valor, TipoPessoa tipo) {
    final digitos = Cliente.somenteDigitos(valor);

    if (digitos.isEmpty) return 'Informe o ${tipo.rotuloDocumento}';

    if (digitos.length != tipo.tamanhoDocumento) {
      return '${tipo.rotuloDocumento} deve ter '
          '${tipo.tamanhoDocumento} dígitos';
    }

    return null;
  }

  void _validar(Cliente cliente) {
    if (cliente.nome.trim().isEmpty) {
      throw ArgumentError('Informe o nome do cliente.');
    }
    if (cliente.contato.telefone.trim().isEmpty) {
      throw ArgumentError('Informe o telefone do cliente.');
    }

    final erroDocumento = validarDocumento(
      cliente.documento,
      cliente.tipoPessoa,
    );
    if (erroDocumento != null) throw ArgumentError(erroDocumento);
  }

  Future<Cliente?> buscarDuplicado(
    String documento, {
    String? ignorarId,
  }) async {
    final carregados = await _repository.listarDoCache();

    return encontrarDuplicado(documento, carregados, ignorarId: ignorarId);
  }

  static Cliente? encontrarDuplicado(
    String documento,
    Iterable<Cliente> carregados, {
    String? ignorarId,
  }) {
    final digitos = Cliente.somenteDigitos(documento);
    if (digitos.isEmpty) return null;

    for (final cliente in carregados) {
      if (cliente.id != ignorarId && cliente.documento == digitos) {
        return cliente;
      }
    }

    return null;
  }
}
