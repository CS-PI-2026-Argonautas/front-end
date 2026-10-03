import 'package:frontend/fire_base/models/cliente.dart';

class PessoaFisica extends Cliente {
  final String cpf;

  PessoaFisica({
    super.id,
    required this.cpf,
    required super.nome,
    required super.info_contato,
    super.enderecos,
    super.removido,
  });

  @override
  Map<String, dynamic> toFirestore() {
    return {
      ...super.toFirestore(),
      'tipo': 'fisica',
      'cpf': cpf,
    };
  }
}