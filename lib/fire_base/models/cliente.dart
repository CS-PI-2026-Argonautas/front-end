import 'package:frontend/fire_base/database/database.dart';

class Cliente {
  int? id;
  final String nome;
  final Endereco endereco;
  final String info_contato;

  // usado para o soft delete
  bool removido;

  Cliente({
    this.id,
    required this.nome,
    required this.endereco,
    required this.info_contato,
    this.removido = false,
  });
}
