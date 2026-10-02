import 'package:frontend/fire_base/models/endereco.dart';

class Cliente {
  int? id;
  final String nome;
  final List<Endereco> enderecos;
  final String info_contato;

  // usado para o soft delete
  bool removido;

  Cliente({
    this.id,
    required this.nome,
    this.enderecos = const [],
    required this.info_contato,
    this.removido = false,
  });
}
