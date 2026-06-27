import 'package:frontend/models/cliente.dart';

class PessoaJuridica extends Cliente{

  final String cnpj;
  final String setor;
  
  PessoaJuridica ({required this.cnpj,
                  required this.setor,
                  required super.endereco,
                  required super.nome,
                  required super.info_contato
  });
}