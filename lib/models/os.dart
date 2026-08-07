class OrdemServicos {

  int? id;
  final String nome;
  final String peca;
  final String equipamento;
  final String cliente;
  final String responsavel;
  final DateTime data;
  final String statusOdemDeServico;
  final String relatorio;

  // usado para o soft delete
  bool removido;

  OrdemServicos({
    required this.nome,
    required this.peca,
    required this.equipamento,
    required this.cliente,
    required this.responsavel,
    required this.data,
    required this.statusOdemDeServico,
    required this.relatorio,
    this.removido = false,
  });
}
