enum ProductType {
  parts,
  scales;

  String get label {
    switch (this) {
      case ProductType.parts:
        return "Peças para consertos";

      case ProductType.scales:
        return "Balanças";
    }
  }
}
