import 'package:frontend/models/cliente.dart';

class PessoaFisica extends Cliente {
  
  final String cpf;

  PessoaFisica({required this.cpf,
                required super.nome,
                required super.endereco,
                required super.info_contato});
}