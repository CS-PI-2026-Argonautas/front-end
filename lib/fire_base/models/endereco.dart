import 'package:frontend/fire_base/Enums/Uf.dart';

class Endereco {
  String cep;
  String rua;
  String cidade;
  String numero;
  Uf uf;

  Endereco({
    required this.cep,
    required this.rua,
    required this.cidade,
    this.numero = 'S/N',
    required this.uf 
  });
}