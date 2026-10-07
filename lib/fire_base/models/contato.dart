class Contato {
  final String telefone; 
  final String? email;
  final String? contatoAdicional;
  final String? setor;
  final String? observacoes;

  const Contato({
    required this.telefone,
    this.email,
    this.contatoAdicional,
    this.setor,
    this.observacoes,
  });

  static String? _nulo(Object? valor) {
    final texto = valor?.toString().trim();
    return (texto == null || texto.isEmpty) ? null : texto;
  }

  Map<String, dynamic> toMap() {
    return {
      'telefone': telefone.trim(),
      'email': _nulo(email),
      'contato_adicional': _nulo(contatoAdicional),
      'setor': _nulo(setor),
      'observacoes': _nulo(observacoes),
    };
  }

  factory Contato.fromMap(Map<String, dynamic> data) {
    return Contato(
      telefone: (data['telefone'] ?? '').toString().trim(),
      email: _nulo(data['email']),
      contatoAdicional: _nulo(data['contato_adicional']),
      setor: _nulo(data['setor']),
      observacoes: _nulo(data['observacoes']),
    );
  }

  String get resumo {
    final partes = <String>[telefone.trim(), (email ?? '').trim()];
    return partes.where((p) => p.isNotEmpty).join(' / ');
  }
}
