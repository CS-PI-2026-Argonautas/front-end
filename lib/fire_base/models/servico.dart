class Servico {
  String? id;
  String nome;
  String descricao;
  int valor;

  Servico({
    this.id,
    required this.nome,
    required this.descricao,
    required this.valor,
  });

  factory Servico.fromMap(Map<String, dynamic> map, {String? idDocumento}) {
    return Servico(
      id: idDocumento ?? map['id'],
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      valor: map['valor']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'descricao': descricao, 'valor': valor};
  }
}
