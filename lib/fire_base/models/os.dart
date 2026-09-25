import 'package:cloud_firestore/cloud_firestore.dart';

class OrdemServicos {
  final String id;

  final String nome;
  final String peca;
  final String equipamento;
  final String cliente;
  final String responsavel;
  final DateTime data;
  final String statusOdemDeServico;
  final String relatorio;
  final DateTime? criadoEm;
  final String cidade;

  bool removido;

  OrdemServicos({
    required this.id,
    required this.nome,
    required this.peca,
    required this.equipamento,
    required this.cliente,
    required this.responsavel,
    required this.data,
    required this.statusOdemDeServico,
    required this.relatorio,
    required this.cidade,
    this.criadoEm,
    this.removido = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'peca': peca,
      'equipamento': equipamento,
      'cliente': cliente,
      'responsavel': responsavel,
      'data': Timestamp.fromDate(data),
      'status_ordem_de_servico': statusOdemDeServico,
      'relatorio': relatorio,
      'criado_em': FieldValue.serverTimestamp(),
      'cidade': cidade,
      'deleted_at': removido ? FieldValue.serverTimestamp() : null,
    };
  }

  factory OrdemServicos.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return OrdemServicos(
      id: document.id,
      nome: data['nome'] as String,
      peca: data['peca'] as String,
      equipamento: data['equipamento'] as String,
      cliente: data['cliente'] as String,
      responsavel: data['responsavel'] as String,
      data: (data['data'] as Timestamp).toDate(),
      statusOdemDeServico: data['status_ordem_de_servico'] as String,
      relatorio: data['relatorio'] as String,
      criadoEm: (data['criado_em'] as Timestamp?)?.toDate(),
      cidade: data['cidade'] as String,
      removido: data['deleted_at'] != null,
    );
  }
}