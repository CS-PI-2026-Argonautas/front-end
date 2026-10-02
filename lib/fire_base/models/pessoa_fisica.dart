import 'package:frontend/fire_base/models/cliente.dart';

class PessoaFisica extends Cliente {
  
  final String cpf;

  PessoaFisica({required this.cpf,
                required super.nome,
                required super.enderecos,
                required super.info_contato});
}