enum PersonType {
  physical('FISICA', 11),
  legal('JURIDICA', 14);

  final String value;

  final int documentSize;

  const PersonType(this.value, this.documentSize);

  String get rotuloDocumento => this == physical ? 'CPF' : 'CNPJ';

  static PersonType de(String? valor) {
    return valor == 'JURIDICA' ? legal : physical;
  }
}
