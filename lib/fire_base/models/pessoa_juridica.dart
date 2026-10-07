import 'package:frontend/fire_base/models/cliente.dart';

class PessoaJuridica extends Cliente {
  final String cnpj;
  final String setor;

  PessoaJuridica({
    super.id,
    required this.cnpj,
    this.setor = '',
    required super.nome,
    required super.info_contato,
    super.enderecos,
    super.removido,
  });

  @override
  Map<String, dynamic> toFirestore() {
    return {
      ...super.toFirestore(),
      'tipo': 'juridica',
      'cnpj': cnpj,
      'setor': setor,
    };
  }
}