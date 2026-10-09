
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/StatusOrdemServico.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:uuid/uuid.dart';

/// Model principal da Ordem de Serviço.
class OrdemServico {
  final String id;

  Statusordemservico status;
  DateTime dataEntrada;
  DateTime? dataSaida;
  String relatorio;

  final Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;

  final ExecutorOrdemServico executor;
  final PermissionariaOrdemServico permissionaria;

  EquipamentoOrdemServico? equipamento;
  ClienteOrdemServico cliente;
  EnderecoServico enderecoServico;

  List<PecaOrdemServico> pecas;
  List<ServicoOrdemServico> servicos;

  OrdemServico({
    String? id,
    required this.status,
    DateTime? dataEntrada,
    this.dataSaida,
    this.relatorio = '',
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    ExecutorOrdemServico? executor,
    PermissionariaOrdemServico? permissionaria,
    this.equipamento,
    required this.cliente,
    required this.enderecoServico,
    List<PecaOrdemServico>? pecas,
    List<ServicoOrdemServico>? servicos,
  }) : id = id ?? const Uuid().v4(),
       dataEntrada = dataEntrada ?? DateTime.now(),
       executor = executor ?? ExecutorOrdemServico(),
       permissionaria =
           permissionaria ?? PermissionariaOrdemServico(),
       pecas = pecas ?? [],
       servicos = servicos ?? [];

  bool get ativo => deletedAt == null;

  /// Converte a OS para o formato esperado pelo Firestore.
  ///
  /// Os timestamps de auditoria do servidor são controlados
  /// pelo repository durante a criação e atualização.
  Map<String, dynamic> toFirestore() {
    return {
      'status': status.name,
      'data_entrada': Timestamp.fromDate(dataEntrada),
      'data_saida': dataSaida == null
          ? null
          : Timestamp.fromDate(dataSaida!),
      'relatorio': relatorio.trim(),
      'executor': executor.toFirestore(),
      'permissionaria': permissionaria.toFirestore(),
      'equipamento': equipamento?.toFirestore(),
      'cliente': cliente.toFirestore(),
      'endereco_servico': enderecoServico.toFirestore(),
      'pecas': pecas.map((peca) => peca.toFirestore()).toList(),
      'servicos': servicos.map((servico) => servico.toFirestore()).toList(),
      'valores': valores.toFirestore(),
      'deleted_at': deletedAt,
    };
  }

  /// Calcula os valores com base nas peças, serviços, taxas e descontos.
  ///
  /// A validação que impede o salvamento de um total negativo
  /// será aplicada na camada de serviço.
  OrdemServicoValores get valores => OrdemServicoValores.calcular(
    pecas: pecas,
    servicos: servicos,
    taxaGlobalCentavos: _taxaGlobalCentavos,
    descontoGlobalCentavos: _descontoGlobalCentavos,
  );

  int _taxaGlobalCentavos = 0;
  int _descontoGlobalCentavos = 0;

  set taxaGlobalCentavos(int valor) {
    _taxaGlobalCentavos = valor;
  }

  set descontoGlobalCentavos(int valor) {
    _descontoGlobalCentavos = valor;
  }

  static String? textoOpcional(Object? valor) {
    final texto = valor?.toString().trim();
    return texto == null || texto.isEmpty ? null : texto;
  }
}

/// Snapshot do executor responsável pela OS.
class ExecutorOrdemServico {
  final String nome;
  final String documentoIdentidade;

  ExecutorOrdemServico({
    this.nome = 'Rodrigo Bernadelli',
    this.documentoIdentidade = '1234567890',
  });

  Map<String, dynamic> toFirestore() => {
    'nome': nome,
    'documento_identidade': documentoIdentidade,
  };
}

/// Snapshot da empresa permissionária.
class PermissionariaOrdemServico {
  final String nomeEmpresarial;
  final String cnpj;
  final String telefone;
  final String email;
  final Map<String, dynamic> endereco;

  PermissionariaOrdemServico({
    this.nomeEmpresarial = 'Bernadelli Exemplo LTDA',
    this.cnpj = '1234567890',
    this.telefone = '(44) 987654-3210',
    this.email = 'teste@example.com',
    Map<String, dynamic>? endereco,
  }) : endereco = endereco ?? <String, dynamic>{};

  Map<String, dynamic> toFirestore() => {
    'nome_empresarial': nomeEmpresarial,
    'cnpj': cnpj,
    'telefone': telefone,
    'email': email,
    'endereco': endereco,
  };
}

/// Snapshot opcional do equipamento.
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

  Map<String, dynamic> toFirestore() => {
    'marca': marca,
    'modelo': modelo,
    'numero_serie': numeroSerie,
    'numero_inmetro': numeroInmetro,
    'portaria': portaria,
    'numero_verificacao': numeroVerificacao,
    'selo_anterior': seloAnterior,
    'selo_atual': seloAtual,
    'lacre_anterior': lacreAnterior,
    'lacre_atual': lacreAtual,
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

  factory ClienteOrdemServico.deCliente(Cliente cliente) {
    return ClienteOrdemServico(
      id: cliente.id,
      nome: cliente.nome,
      tipoPessoa: cliente.tipoPessoa.valor,
      documento: cliente.documento,
      telefone: cliente.contato.telefone,
      email: OrdemServico.textoOpcional(cliente.contato.email),
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

  factory EnderecoServico.deEndereco(Endereco endereco) {
    return EnderecoServico(
      id: endereco.id,
      logradouro: endereco.logradouro,
      numero: OrdemServico.textoOpcional(endereco.numero),
      complemento: OrdemServico.textoOpcional(endereco.complemento),
      cidade: endereco.cidade,
      uf: endereco.uf.name,
      cep: OrdemServico.textoOpcional(endereco.cep),
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

  PecaOrdemServico({
    required this.pecaId,
    required this.nome,
    required this.quantidade,
    required this.valorUnitarioCentavos,
  }) : assert(quantidade >= 1);

  int get subtotalCentavos => quantidade * valorUnitarioCentavos;

  Map<String, dynamic> toFirestore() => {
    'peca_id': pecaId,
    'nome': nome,
    'quantidade': quantidade,
    'valor_unitario_centavos': valorUnitarioCentavos,
  };
}

class ServicoOrdemServico {
  final String servicoId;
  final String descricao;
  final int valorCentavos;

  ServicoOrdemServico({
    required this.servicoId,
    required this.descricao,
    required this.valorCentavos,
  });

  Map<String, dynamic> toFirestore() => {
    'servico_id': servicoId,
    'descricao': descricao,
    'valor_centavos': valorCentavos,
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
      (total, servico) => total + servico.valorCentavos,
    );

    final total = subtotalPecas +
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
