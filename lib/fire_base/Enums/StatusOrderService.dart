enum Statusorderservice {
  EM_ORCAMENTO,
  EM_CONSERTO,
  CANCELADA,
  CONCLUIDA,
  ENTREGUE,
  PAGA,
}

extension StatusOrdemServicoX on Statusorderservice {
  String get valor => name;
  bool get saiDaOficina =>
      this == Statusorderservice.ENTREGUE || this == Statusorderservice.PAGA;

  static Statusorderservice de(String? valor) {
    for (final status in Statusorderservice.values) {
      if (status.name == valor) return status;
    }
    return Statusorderservice.EM_ORCAMENTO;
  }
}
