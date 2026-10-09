import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/contact.dart';
import 'package:frontend/ui/pages/person_registration/person_registration_contact.dart';
class PersonAlterationContact extends StatelessWidget {
  final Contact? contatoInicial;

  const PersonAlterationContact({super.key, this.contatoInicial});

  @override
  Widget build(BuildContext context) {
    return PersonRegistrationContact(
      contatoInicial: contatoInicial,
      titulo: 'Edição de Contato',
    );
  }
}
