class ServiceOrderException implements Exception {
  final String message;

  const ServiceOrderException(this.message);

  @override
  String toString() => message;
}

class IncompleteServiceOrderException extends ServiceOrderException {
  final List<String> pendingItems;

  IncompleteServiceOrderException(List<String> pendingItems)
    : pendingItems = List.unmodifiable(pendingItems),
      super('Para salvar a OS, preencha: ${pendingItems.join(', ')}.');
}

class NegativeTotalException extends ServiceOrderException {
  final int totalCents;

  const NegativeTotalException(this.totalCents)
    : super(
        'O total da OS não pode ser negativo. '
        'Reduza o desconto ou aumente os valores.',
      );
}

class InvalidAddressException extends ServiceOrderException {
  const InvalidAddressException(String message) : super(message);
}