enum ItemType {
  parts,
  balances;

  String get label {
    switch (this) {
      case ItemType.parts:
        return "Peças para consertos";

      case ItemType.balances:
        return "Balanças";
    }
  }
}
