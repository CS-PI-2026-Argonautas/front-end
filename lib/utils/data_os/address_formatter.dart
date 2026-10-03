import 'package:frontend/fire_base/models/endereco.dart';

String formatarEndereco(Endereco endereco) {
  return '${endereco.rua}, ${endereco.numero}, ${endereco.complemento} - '
      '${endereco.cidade}/${endereco.uf.name}';
}