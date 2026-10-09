enum ItemType {
  parts,
  scales;

  String get label {
    switch (this) {
      case ItemType.parts:
        return "Peças para consertos";

      case ItemType.scales:
        return "Balanças";
    }
  }
}
