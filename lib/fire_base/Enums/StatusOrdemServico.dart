enum Statusordemservico {
  EM_ORCAMENTO,
  EM_CONSERTO,
  CANCELADA,
  CONCLUIDA,
  ENTREGUE,
  PAGA,
}

extension StatusOrdemServicoX on Statusordemservico {
  String get valor => name;
  bool get saiDaOficina =>
      this == Statusordemservico.ENTREGUE || this == Statusordemservico.PAGA;

  static Statusordemservico de(String? valor) {
    for (final status in Statusordemservico.values) {
      if (status.name == valor) return status;
    }
    return Statusordemservico.EM_ORCAMENTO;
  }
}
