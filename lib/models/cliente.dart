class Cliente {
  int? id;
  final String nome;
  final String endereco;
  final String info_contato;

  // usado para o soft delete
  bool removido;

  Cliente({
    required this.nome,
    required this.endereco,
    required this.info_contato,
    this.removido = false,
  });
}
