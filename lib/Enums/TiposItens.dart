enum TipoProduto {
  pecas,
  balancas;

  String get label {
    switch (this) {
      case TipoProduto.pecas:
        return "Peças para consertos";

      case TipoProduto.balancas:
        return "Balanças";
    }
  }
}
