class Contact {
  final String phone; 
  final String? email;
  final String? additionalContact;
  final String? sector;
  final String? observations;

  const Contact({
    required this.phone,
    this.email,
    this.additionalContact,
    this.sector,
    this.observations,
  });

  static String? _nulo(Object? valor) {
    final texto = valor?.toString().trim();
    return (texto == null || texto.isEmpty) ? null : texto;
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone.trim(),
      'email': _nulo(email),
      'additional_contact': _nulo(additionalContact),
      'sector': _nulo(sector),
      'observations': _nulo(observations),
    };
  }

  factory Contact.fromMap(Map<String, dynamic> data) {
    return Contact(
      phone: (data['phone'] ?? '').toString().trim(),
      email: _nulo(data['email']),
      additionalContact: _nulo(data['additional_contact']),
      sector: _nulo(data['sector']),
      observations: _nulo(data['observations']),
    );
  }

  String get resumo {
    final partes = <String>[phone.trim(), (email ?? '').trim()];
    return partes.where((p) => p.isNotEmpty).join(' / ');
  }
}
