import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/ui/pages/person_registration/person_registration_address.dart';

class PersonAlterationAddress extends StatelessWidget {
  final Address? enderecoInicial;

  const PersonAlterationAddress({super.key, this.enderecoInicial});

  @override
  Widget build(BuildContext context) {
    return PersonRegistrationAddress(
      enderecoInicial: enderecoInicial,
      titulo: 'Edição de Endereço',
    );
  }
}
