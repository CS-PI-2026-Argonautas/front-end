
class OrdemServicoException implements Exception {
  final String mensagem;

  const OrdemServicoException(this.mensagem);

  @override
  String toString() => mensagem;
}
class OrdemServicoIncompletaException extends OrdemServicoException {
  final List<String> pendencias;

  OrdemServicoIncompletaException(List<String> pendencias)
    : pendencias = List.unmodifiable(pendencias),
      super('Para salvar a OS, preencha: ${pendencias.join(', ')}.');
}

class TotalNegativoException extends OrdemServicoException {
  final int totalCentavos;

  const TotalNegativoException(this.totalCentavos)
    : super(
        'O total da OS não pode ser negativo. '
        'Reduza o desconto ou aumente os valores.',
      );
}

class EnderecoInvalidoException extends OrdemServicoException {
  const EnderecoInvalidoException(String mensagem) : super(mensagem);
}
