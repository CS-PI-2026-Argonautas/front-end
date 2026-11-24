enum ServiceOrderStatus {
  EM_ORCAMENTO,
  EM_CONSERTO,
  CANCELADA,
  CONCLUIDA,
  ENTREGUE,
  PAGA,
}

extension ServiceOrderStatusX on ServiceOrderStatus {
  String get value => name;

  bool get leavesWorkshop =>
      this == ServiceOrderStatus.ENTREGUE ||
      this == ServiceOrderStatus.PAGA;

  static ServiceOrderStatus from(String? value) {
    for (final status in ServiceOrderStatus.values) {
      if (status.name == value) return status;
    }

    return ServiceOrderStatus.EM_ORCAMENTO;
  }
}