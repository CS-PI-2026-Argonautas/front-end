import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/fire_base/models/pessoa_fisica.dart';
import 'package:frontend/fire_base/models/pessoa_juridica.dart';

class ClienteRepository {
  final FirebaseFirestore _firestore;

  ClienteRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _clientes =>
      _firestore.collection('clients');

  CollectionReference<Map<String, dynamic>> get _enderecos =>
      _firestore.collection('addresses');

  /// Monta PessoaFisica / PessoaJuridica conforme o campo `tipo` do documento.
  Cliente _mapear(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final base = Cliente.fromFirestore(doc);

    switch (data['tipo']) {
      case 'fisica':
        return PessoaFisica(
          id: base.id,
          nome: base.nome,
          info_contato: base.info_contato,
          removido: base.removido,
          cpf: (data['cpf'] ?? '').toString().trim(),
        );
      case 'juridica':
        return PessoaJuridica(
          id: base.id,
          nome: base.nome,
          info_contato: base.info_contato,
          removido: base.removido,
          cnpj: (data['cnpj'] ?? '').toString().trim(),
          setor: (data['setor'] ?? '').toString().trim(),
        );
      default:
        return base;
    }
  }

  /// Lista os clientes ativos já com os endereços preenchidos.
  /// É um "join" manual: 2 leituras (clients e addresses) e o agrupamento
  /// por clienteId é feito aqui, em vez de 1 consulta por cliente.
  Future<List<Cliente>> listar({bool incluirRemovidos = false}) async {
    final resultados = await Future.wait([_clientes.get(), _enderecos.get()]);
    final clientesSnap = resultados[0];
    final enderecosSnap = resultados[1];

    final porCliente = <String, List<Endereco>>{};
    for (final doc in enderecosSnap.docs) {
      final endereco = Endereco.fromFirestore(doc);
      final clienteId = endereco.clienteId;
      if (clienteId == null || clienteId.isEmpty) continue;
      porCliente.putIfAbsent(clienteId, () => []).add(endereco);
    }

    final clientes = clientesSnap.docs
        .map(_mapear)
        .where((c) => incluirRemovidos || !c.removido)
        .toList();

    for (final cliente in clientes) {
      cliente.enderecos = porCliente[cliente.id] ?? [];
    }

    clientes.sort(
      (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
    );

    return clientes;
  }

  /// Cadastro novo: cliente + endereços na MESMA operação (batch).
  /// Os ids são gerados no app com .doc(), então dá para já gravar o
  /// clienteId em cada endereço; ou salva tudo, ou não salva nada.
  Future<String> cadastrar(Cliente cliente, List<Endereco> enderecos) async {
    final clienteRef = _clientes.doc();
    final batch = _firestore.batch();

    batch.set(clienteRef, cliente.toFirestore());

    for (final endereco in enderecos) {
      batch.set(
        _enderecos.doc(),
        endereco.copyWith(clienteId: clienteRef.id).toFirestore(),
      );
    }

    await batch.commit();

    return clienteRef.id;
  }

  /// Edição: grava o cliente e sincroniza os endereços numa única operação.
  /// - endereço com id        -> regrava (edição)
  /// - endereço sem id        -> cria
  /// - endereço que existe no banco e não está mais na lista -> apaga
  Future<void> atualizar(Cliente cliente, List<Endereco> enderecos) async {
    final id = cliente.id;
    if (id == null) {
      throw ArgumentError('Cliente sem id não pode ser atualizado.');
    }

    final existentes = await _enderecos.where('clienteId', isEqualTo: id).get();
    final idsMantidos = enderecos.map((e) => e.id).whereType<String>().toSet();

    final batch = _firestore.batch();

    // set (e não update) para não deixar campo antigo, ex.: cpf de quem
    // virou pessoa jurídica
    batch.set(_clientes.doc(id), cliente.toFirestore());

    for (final doc in existentes.docs) {
      if (!idsMantidos.contains(doc.id)) {
        batch.delete(doc.reference);
      }
    }

    for (final endereco in enderecos) {
      // doc(null) gera um id novo; doc(id) mira o documento existente
      batch.set(
        _enderecos.doc(endereco.id),
        endereco.copyWith(clienteId: id).toFirestore(),
      );
    }

    await batch.commit();
  }

  /// Soft delete: o documento continua no banco (as OS antigas precisam do
  /// histórico) e some da listagem.
  Future<void> definirRemovido(String id, bool removido) async {
    await _clientes.doc(id).update({'removido': removido});
  }
}