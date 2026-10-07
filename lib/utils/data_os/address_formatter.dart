import 'package:frontend/fire_base/models/endereco.dart';

String formatarEndereco(Endereco endereco) {
  final numero = endereco.numero.trim().isEmpty
      ? 'S/N'
      : endereco.numero.trim();
  final complemento = endereco.complemento.trim();

  final rua = complemento.isEmpty
      ? '${endereco.logradouro}, $numero'
      : '${endereco.logradouro}, $numero, $complemento';

  return '$rua - ${endereco.cidade}/${endereco.uf.name}';
}
