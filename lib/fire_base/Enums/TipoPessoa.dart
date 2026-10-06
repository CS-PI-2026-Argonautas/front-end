enum TipoPessoa {
  fisica('FISICA', 11),
  juridica('JURIDICA', 14);

  final String valor;

  final int tamanhoDocumento;

  const TipoPessoa(this.valor, this.tamanhoDocumento);

  String get rotuloDocumento => this == fisica ? 'CPF' : 'CNPJ';

  static TipoPessoa de(String? valor) {
    return valor == 'JURIDICA' ? juridica : fisica;
  }
}
