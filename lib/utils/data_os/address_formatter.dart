import 'package:frontend/fire_base/models/address.dart';

String formatarEndereco(Address endereco) {
  final numero = endereco.number.trim().isEmpty
      ? 'S/N'
      : endereco.number.trim();
  final complemento = endereco.complement.trim();

  final rua = complemento.isEmpty
      ? '${endereco.publicPlace}, $numero'
      : '${endereco.publicPlace}, $numero, $complemento';

  return '$rua - ${endereco.city}/${endereco.uf.name}';
}
