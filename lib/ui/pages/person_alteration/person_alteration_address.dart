import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/ui/pages/person_registration/person_registration_address.dart';

/// Edição de endereço: é o mesmo formulário do cadastro, com outro título.
/// Devolve um [Endereco] pelo Navigator.pop, como o de cadastro.
class PersonAlterationAddress extends StatelessWidget {
  final Endereco? enderecoInicial;

  const PersonAlterationAddress({super.key, this.enderecoInicial});

  @override
  Widget build(BuildContext context) {
    return PersonRegistrationAddress(
      enderecoInicial: enderecoInicial,
      titulo: 'Edição de Endereço',
    );
  }
}
