import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/StatusOrderService.dart';
import 'package:frontend/fire_base/models/client.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/models/os_exeption.dart';
import 'package:uuid/uuid.dart';

String _texto(Object? valor) => (valor ?? '').toString().trim();

String? _textoOuNulo(Object? valor) {
  final texto = valor?.toString().trim();
  return (texto == null || texto.isEmpty) ? null : texto;
}

Timestamp? _ts(Object? valor) => valor is Timestamp ? valor : null;

int _inteiro(Object? valor) => valor is num ? valor.toInt() : 0;

Map<String, dynamic> _mapa(Object? valor) =>
    valor is Map ? Map<String, dynamic>.from(valor) : <String, dynamic>{};

List<Map<String, dynamic>> _lista(Object? valor) {
  if (valor is! List) return <Map<String, dynamic>>[];
  return valor
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

class OrdemServico {
  static const int limiteRelatorio = 256;

  final String id;

  Statusorderservice status;

  Statusorderservice? statusAntesCancelamento;

  bool equipamentoBloqueado;

  DateTime dataEntrada;
  DateTime? dataSaida;
  String relatorio;

  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;

  final ExecutorOrdemServico executor;
  final PermissionariaOrdemServico permissionaria;

  EquipamentoOrdemServico? equipamento;

  ClienteOrdemServico? cliente;
  EnderecoServico? enderecoServico;

  List<PecaOrdemServico> pecas;
  List<ServicoOrdemServico> servicos;

  int taxaGlobalCentavos;
  int descontoGlobalCentavos;

  bool persistida;

  String? _estadoSalvo;

  OrdemServico({
    String? id,
    this.status = Statusorderservice.EM_ORCAMENTO,
    this.statusAntesCancelamento,
    this.equipamentoBloqueado = false,
    DateTime? dataEntrada,
    this.dataSaida,
    this.relatorio = '',
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    ExecutorOrdemServico? executor,
    PermissionariaOrdemServico? permissionaria,
    this.equipamento,
    this.cliente,
    this.enderecoServico,
    List<PecaOrdemServico>? pecas,
    List<ServicoOrdemServico>? servicos,
    this.taxaGlobalCentavos = 0,
    this.descontoGlobalCentavos = 0,
    this.persistida = false,
  }) : id = id ?? const Uuid().v4(),
       dataEntrada = dataEntrada ?? DateTime.now(),
       executor = executor ?? ExecutorOrdemServico(),
       permissionaria = permissionaria ?? PermissionariaOrdemServico(),
       pecas = pecas ?? [],
       servicos = servicos ?? [];
  factory OrdemServico.nova() {
    final os = OrdemServico();
    os._registrarEstado();
    return os;
  }

  bool get ativo => deletedAt == null;

  OrdemServicoValores get valores => OrdemServicoValores.calcular(
    pecas: pecas,
    servicos: servicos,
    taxaGlobalCentavos: taxaGlobalCentavos,
    descontoGlobalCentavos: descontoGlobalCentavos,
  );

  void alterarStatus(Statusorderservice novo) {
    if (novo == status) return;

    if (novo == Statusorderservice.CANCELADA) {
      statusAntesCancelamento = status;
    }

    if (novo.saiDaOficina) {
      equipamentoBloqueado = true;
      dataSaida ??= DateTime.now();
    }

    status = novo;
  }

  void definirCliente(Client novo) {
    if (cliente?.id != novo.id) {
      enderecoServico = null;
    }
    cliente = ClienteOrdemServico.deCliente(novo);
  }

  void definirEnderecoServico(Address endereco) {
    if (cliente == null) {
      throw const EnderecoInvalidoException(
        'Selecione um cliente antes de escolher o endereço de serviço.',
      );
    }
    enderecoServico = EnderecoServico.deEndereco(endereco);
  }

  String _assinatura() => toFirestore().toString();

  void _registrarEstado() => _estadoSalvo = _assinatura();

  void marcarComoSalva() {
    persistida = true;
    _registrarEstado();
  }

  bool get temAlteracoesNaoSalvas =>
      _estadoSalvo == null || _estadoSalvo != _assinatura();

  Map<String, dynamic> toFirestore() {
    final equip = equipamento;

    return {
      'status': status.valor,
      'status_antes_cancelamento': statusAntesCancelamento?.valor,
      'equipamento_bloqueado': equipamentoBloqueado,
      'data_entrada': Timestamp.fromDate(dataEntrada),
      'data_saida': dataSaida == null ? null : Timestamp.fromDate(dataSaida!),
      'relatorio': relatorio.trim(),
      'executor': executor.toFirestore(),
      'permissionaria': permissionaria.toFirestore(),
      'equipamento': (equip == null || equip.vazio) ? null : equip.toFirestore(),
      'cliente': cliente?.toFirestore(),
      'endereco_servico': enderecoServico?.toFirestore(),
      'pecas': pecas.map((peca) => peca.toFirestore()).toList(),
      'servicos': servicos.map((servico) => servico.toFirestore()).toList(),
      'valores': valores.toFirestore(),
      'deleted_at': deletedAt,
    };
  }

  factory OrdemServico.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final valores = _mapa(data['valores']);
    final clienteMapa = _mapa(data['cliente']);
    final enderecoMapa = _mapa(data['endereco_servico']);
    final equipamentoMapa = _mapa(data['equipamento']);
    final statusAntes = _textoOuNulo(data['status_antes_cancelamento']);

    final os = OrdemServico(
      id: doc.id,
      status: StatusOrdemServicoX.de(_textoOuNulo(data['status'])),
      statusAntesCancelamento: statusAntes == null
          ? null
          : StatusOrdemServicoX.de(statusAntes),
      equipamentoBloqueado: data['equipamento_bloqueado'] == true,
      dataEntrada: _ts(data['data_entrada'])?.toDate(),
      dataSaida: _ts(data['data_saida'])?.toDate(),
      relatorio: _texto(data['relatorio']),
      createdAt: _ts(data['created_at']),
      updatedAt: _ts(data['updated_at']),
      deletedAt: _ts(data['deleted_at']),
      executor: ExecutorOrdemServico.fromMap(_mapa(data['executor'])),
      permissionaria: PermissionariaOrdemServico.fromMap(
        _mapa(data['permissionaria']),
      ),
      equipamento: equipamentoMapa.isEmpty
          ? null
          : EquipamentoOrdemServico.fromMap(equipamentoMapa),
      cliente: clienteMapa.isEmpty
          ? null
          : ClienteOrdemServico.fromMap(clienteMapa),
      enderecoServico: enderecoMapa.isEmpty
          ? null
          : EnderecoServico.fromMap(enderecoMapa),
      pecas: _lista(data['pecas']).map(PecaOrdemServico.fromMap).toList(),
      servicos: _lista(
        data['servicos'],
      ).map(ServicoOrdemServico.fromMap).toList(),
      taxaGlobalCentavos: _inteiro(valores['taxa_global_centavos']),
      descontoGlobalCentavos: _inteiro(valores['desconto_global_centavos']),
    );

    os.marcarComoSalva();
    return os;
  }

  static String? textoOpcional(Object? valor) => _textoOuNulo(valor);
}
class ExecutorOrdemServico {
  final String id;
  final String nome;
  final String documentoIdentidade;

  ExecutorOrdemServico({
    this.id = '00000000-0000-4000-8000-000000000001',
    this.nome = 'Rodrigo Bernadelli',
    this.documentoIdentidade = '1234567890',
  });

  factory ExecutorOrdemServico.fromMap(Map<String, dynamic> data) {
    final padrao = ExecutorOrdemServico();

    return ExecutorOrdemServico(
      id: _textoOuNulo(data['id']) ?? padrao.id,
      nome: _textoOuNulo(data['nome']) ?? padrao.nome,
      documentoIdentidade:
          _textoOuNulo(data['documento_identidade']) ??
          padrao.documentoIdentidade,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'nome': nome,
    'documento_identidade': documentoIdentidade,
  };
}

class PermissionariaOrdemServico {
  final String id;
  final String nomeEmpresarial;
  final String cnpj;
  final String telefone;
  final String email;

  final Map<String, dynamic> endereco;

  PermissionariaOrdemServico({
    this.id = '00000000-0000-4000-8000-000000000002',
    this.nomeEmpresarial = 'Bernadelli Exemplo LTDA',
    this.cnpj = '1234567890',
    this.telefone = '(44) 987654-3210',
    this.email = 'teste@example.com',
    Map<String, dynamic>? endereco,
  }) : endereco = endereco ?? enderecoPadrao;

  static const Map<String, dynamic> enderecoPadrao = {
    'logradouro': 'Rua Paraná',
    'numero': '100',
    'cidade': 'Paranavaí',
    'uf': 'PR',
    'cep': '87701-000',
  };

  factory PermissionariaOrdemServico.fromMap(Map<String, dynamic> data) {
    final padrao = PermissionariaOrdemServico();
    final enderecoSalvo = _mapa(data['endereco']);

    return PermissionariaOrdemServico(
      id: _textoOuNulo(data['id']) ?? padrao.id,
      nomeEmpresarial:
          _textoOuNulo(data['nome_empresarial']) ?? padrao.nomeEmpresarial,
      cnpj: _textoOuNulo(data['cnpj']) ?? padrao.cnpj,
      telefone: _textoOuNulo(data['telefone']) ?? padrao.telefone,
      email: _textoOuNulo(data['email']) ?? padrao.email,
      endereco: enderecoSalvo.isEmpty ? null : enderecoSalvo,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'nome_empresarial': nomeEmpresarial,
    'cnpj': cnpj,
    'telefone': telefone,
    'email': email,
    'endereco': Map<String, dynamic>.from(endereco),
  };
}

class EquipamentoOrdemServico {
  final String? marca;
  final String? modelo;
  final String? numeroSerie;
  final String? numeroInmetro;
  final String? portaria;
  final String? numeroVerificacao;
  final String? seloAnterior;
  final String? seloAtual;
  final String? lacreAnterior;
  final String? lacreAtual;

  EquipamentoOrdemServico({
    this.marca,
    this.modelo,
    this.numeroSerie,
    this.numeroInmetro,
    this.portaria,
    this.numeroVerificacao,
    this.seloAnterior,
    this.seloAtual,
    this.lacreAnterior,
    this.lacreAtual,
  });

  factory EquipamentoOrdemServico.fromMap(Map<String, dynamic> data) {
    return EquipamentoOrdemServico(
      marca: _textoOuNulo(data['marca']),
      modelo: _textoOuNulo(data['modelo']),
      numeroSerie: _textoOuNulo(data['numero_serie']),
      numeroInmetro: _textoOuNulo(data['numero_inmetro']),
      portaria: _textoOuNulo(data['portaria']),
      numeroVerificacao: _textoOuNulo(data['numero_verificacao']),
      seloAnterior: _textoOuNulo(data['selo_anterior']),
      seloAtual: _textoOuNulo(data['selo_atual']),
      lacreAnterior: _textoOuNulo(data['lacre_anterior']),
      lacreAtual: _textoOuNulo(data['lacre_atual']),
    );
  }

  bool get vazio => toFirestore().values.every((valor) => valor == null);

  Map<String, dynamic> toFirestore() => {
    'marca': _textoOuNulo(marca),
    'modelo': _textoOuNulo(modelo),
    'numero_serie': _textoOuNulo(numeroSerie),
    'numero_inmetro': _textoOuNulo(numeroInmetro),
    'portaria': _textoOuNulo(portaria),
    'numero_verificacao': _textoOuNulo(numeroVerificacao),
    'selo_anterior': _textoOuNulo(seloAnterior),
    'selo_atual': _textoOuNulo(seloAtual),
    'lacre_anterior': _textoOuNulo(lacreAnterior),
    'lacre_atual': _textoOuNulo(lacreAtual),
  };
}

class ClienteOrdemServico {
  final String id;
  final String nome;
  final String tipoPessoa;
  final String documento;
  final String telefone;
  final String? email;

  ClienteOrdemServico({
    required this.id,
    required this.nome,
    required this.tipoPessoa,
    required this.documento,
    required this.telefone,
    this.email,
  });

  factory ClienteOrdemServico.deCliente(Client cliente) {
    return ClienteOrdemServico(
      id: cliente.id,
      nome: cliente.name,
      tipoPessoa: cliente.personType.value,
      documento: cliente.document,
      telefone: cliente.contact.phone,
      email: _textoOuNulo(cliente.contact.email),
    );
  }

  factory ClienteOrdemServico.fromMap(Map<String, dynamic> data) {
    return ClienteOrdemServico(
      id: _texto(data['id']),
      nome: _texto(data['nome']),
      tipoPessoa: _texto(data['tipo_pessoa']),
      documento: _texto(data['documento']),
      telefone: _texto(data['telefone']),
      email: _textoOuNulo(data['email']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'nome': nome,
    'tipo_pessoa': tipoPessoa,
    'documento': documento,
    'telefone': telefone,
    'email': email,
  };
}

class EnderecoServico {
  final String id;
  final String logradouro;
  final String? numero;
  final String? complemento;
  final String cidade;
  final String uf;
  final String? cep;

  EnderecoServico({
    required this.id,
    required this.logradouro,
    this.numero,
    this.complemento,
    required this.cidade,
    required this.uf,
    this.cep,
  });

  factory EnderecoServico.deEndereco(Address endereco) {
    return EnderecoServico(
      id: endereco.id,
      logradouro: endereco.publicPlace,
      numero: _textoOuNulo(endereco.number),
      complemento: _textoOuNulo(endereco.complement),
      cidade: endereco.city,
      uf: endereco.uf.name,
      cep: _textoOuNulo(endereco.uf),
    );
  }

  factory EnderecoServico.fromMap(Map<String, dynamic> data) {
    return EnderecoServico(
      id: _texto(data['id']),
      logradouro: _texto(data['logradouro']),
      numero: _textoOuNulo(data['numero']),
      complemento: _textoOuNulo(data['complemento']),
      cidade: _texto(data['cidade']),
      uf: _texto(data['uf']),
      cep: _textoOuNulo(data['cep']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'logradouro': logradouro,
    'numero': numero,
    'complemento': complemento,
    'cidade': cidade,
    'uf': uf,
    'cep': cep,
  };
}

class PecaOrdemServico {
  final String pecaId;
  final String nome;
  final int quantidade;
  final int valorUnitarioCentavos;
  final int descontoCentavos;

  PecaOrdemServico({
    required this.pecaId,
    required this.nome,
    required this.quantidade,
    required this.valorUnitarioCentavos,
    this.descontoCentavos = 0,
  }) {
    if (quantidade < 1) {
      throw ArgumentError.value(quantidade, 'quantidade', 'Mínimo 1.');
    }
    if (valorUnitarioCentavos < 0) {
      throw ArgumentError.value(
        valorUnitarioCentavos,
        'valorUnitarioCentavos',
        'Não pode ser negativo.',
      );
    }
    if (descontoCentavos < 0) {
      throw ArgumentError.value(
        descontoCentavos,
        'descontoCentavos',
        'Não pode ser negativo.',
      );
    }
  }

  factory PecaOrdemServico.fromMap(Map<String, dynamic> data) {
    final quantidade = _inteiro(data['quantidade']);

    return PecaOrdemServico(
      pecaId: _texto(data['peca_id']),
      nome: _texto(data['nome']),
      quantidade: quantidade < 1 ? 1 : quantidade,
      valorUnitarioCentavos: _inteiro(data['valor_unitario_centavos']),
      descontoCentavos: _inteiro(data['desconto_centavos']),
    );
  }

  int get subtotalBrutoCentavos => quantidade * valorUnitarioCentavos;

  int get subtotalCentavos => subtotalBrutoCentavos - descontoCentavos;

  PecaOrdemServico comQuantidade(int novaQuantidade) {
    return PecaOrdemServico(
      pecaId: pecaId,
      nome: nome,
      quantidade: novaQuantidade,
      valorUnitarioCentavos: valorUnitarioCentavos,
      descontoCentavos: descontoCentavos,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'peca_id': pecaId,
    'nome': nome,
    'quantidade': quantidade,
    'valor_unitario_centavos': valorUnitarioCentavos,
    'desconto_centavos': descontoCentavos,
  };
}

class ServicoOrdemServico {
  final String servicoId;
  final String descricao;
  final int valorCentavos;

  final int descontoCentavos;

  ServicoOrdemServico({
    required this.servicoId,
    required this.descricao,
    required this.valorCentavos,
    this.descontoCentavos = 0,
  }) {
    if (valorCentavos < 0) {
      throw ArgumentError.value(
        valorCentavos,
        'valorCentavos',
        'Não pode ser negativo.',
      );
    }
    if (descontoCentavos < 0) {
      throw ArgumentError.value(
        descontoCentavos,
        'descontoCentavos',
        'Não pode ser negativo.',
      );
    }
  }

  factory ServicoOrdemServico.fromMap(Map<String, dynamic> data) {
    return ServicoOrdemServico(
      servicoId: _texto(data['servico_id']),
      descricao: _texto(data['descricao']),
      valorCentavos: _inteiro(data['valor_centavos']),
      descontoCentavos: _inteiro(data['desconto_centavos']),
    );
  }

  int get subtotalCentavos => valorCentavos - descontoCentavos;

  Map<String, dynamic> toFirestore() => {
    'servico_id': servicoId,
    'descricao': descricao,
    'valor_centavos': valorCentavos,
    'desconto_centavos': descontoCentavos,
  };
}

class OrdemServicoValores {
  final int subtotalPecasCentavos;
  final int subtotalServicosCentavos;
  final int taxaGlobalCentavos;
  final int descontoGlobalCentavos;
  final int totalCentavos;

  const OrdemServicoValores({
    required this.subtotalPecasCentavos,
    required this.subtotalServicosCentavos,
    required this.taxaGlobalCentavos,
    required this.descontoGlobalCentavos,
    required this.totalCentavos,
  });

  factory OrdemServicoValores.calcular({
    required List<PecaOrdemServico> pecas,
    required List<ServicoOrdemServico> servicos,
    required int taxaGlobalCentavos,
    required int descontoGlobalCentavos,
  }) {
    final subtotalPecas = pecas.fold<int>(
      0,
      (total, peca) => total + peca.subtotalCentavos,
    );

    final subtotalServicos = servicos.fold<int>(
      0,
      (total, servico) => total + servico.subtotalCentavos,
    );

    final total =
        subtotalPecas +
        subtotalServicos +
        taxaGlobalCentavos -
        descontoGlobalCentavos;

    return OrdemServicoValores(
      subtotalPecasCentavos: subtotalPecas,
      subtotalServicosCentavos: subtotalServicos,
      taxaGlobalCentavos: taxaGlobalCentavos,
      descontoGlobalCentavos: descontoGlobalCentavos,
      totalCentavos: total,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'subtotal_pecas_centavos': subtotalPecasCentavos,
    'subtotal_servicos_centavos': subtotalServicosCentavos,
    'taxa_global_centavos': taxaGlobalCentavos,
    'desconto_global_centavos': descontoGlobalCentavos,
    'total_centavos': totalCentavos,
  };
}
