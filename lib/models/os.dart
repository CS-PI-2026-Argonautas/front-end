import 'package:frontend/enums/status_ordem_servico.dart';

class OrdemServicos {

  int? id;
  final String nome;
  final String peca;
  final String equipamento;
  final String cliente;
  final String cidade;
  final String responsavel;
  String relatorio;
  StatusOrdemServico statusOrdemServico;

  final DateTime criadoEm;
  DateTime dataEntrada;
  DateTime? dataSaida;
  // usado para o soft delete
  bool removido;

  OrdemServicos({
    required this.id,
    required this.nome,
    required this.peca,
    required this.equipamento,
    required this.cliente,
    required this.responsavel,
    required this.statusOrdemServico,
    required this.relatorio,
    required this.cidade,
    required this.dataEntrada,
    this.dataSaida,
    DateTime? criadoEm,
    this.removido = false,
  }) : criadoEm = criadoEm ?? DateTime.now();
}
