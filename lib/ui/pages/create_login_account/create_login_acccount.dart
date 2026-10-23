import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/pages/password_setting/password_setting.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/form/form_section_tile.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/utils/validators/validators.dart';

class CreateLoginAccount extends StatefulWidget {
  const CreateLoginAccount({super.key});

  @override
  State<CreateLoginAccount> createState() => CreateLoginAccountState();
}

class CreateLoginAccountState extends State<CreateLoginAccount> {
  final colors = custom_colors.colorScheme;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Cadastrar Usuário',
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: Card(
                color: Colors.white,
                elevation: 8,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 24,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormSectionTile(
                          title: "Cadastro do seu Usuário",
                          subtitle: "Informe seus dados pessoais.",
                        ),
                        Row(
                          spacing: 6,
                          children: [
                            Icon(Icons.badge, size: 20, color: colors.primary),
                            Text(
                              "Nome*",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),

                        TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            fillColor: colors.surface,
                            hintText: 'Informe seu nome',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: colors.primary,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            return emptyMandatoryField(value);
                          },
                        ),

                        Row(
                          spacing: 6,
                          children: [
                            Icon(Icons.badge, size: 20, color: colors.primary),
                            Text(
                              "Sobrenome*",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),

                        TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            fillColor: colors.surface,
                            hintText: 'Informe seu sobrenome',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: colors.primary,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            return emptyMandatoryField(value);
                          },
                        ),

                        Row(
                          spacing: 6,
                          children: [
                            Icon(
                              Icons.person_3,
                              size: 20,
                              color: colors.primary,
                            ),
                            Text(
                              "Nome usuário*",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),

                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9._\-]'),
                            ), //caracteres especiais
                            FilteringTextInputFormatter.deny(
                              RegExp(r'\s'),
                            ), //nao deixa o usuario usar o espaço
                          ],
                          maxLength: 25,
                          validator: (value) {
                            if (value!.length < 3) {
                              return 'Mínimo de 3 caracteres';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: colors.primary,
                                width: 2.0,
                              ),
                            ),
                            fillColor: colors.surface,
                            hintText: 'Ex: nome.sobrenome',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),

                        Row(
                          spacing: 6,
                          children: [
                            Icon(Icons.email, size: 20, color: colors.primary),
                            Text(
                              "Email*",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),

                        TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: colors.primary,
                                width: 2.0,
                              ),
                            ),
                            fillColor: colors.surface,
                            hintText: 'Ex: nome@exemplo.com',
                            filled: true,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          validator: (value) {
                            return validateEmail(value);
                          },
                        ),

                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PasswordSetting(),
                                  ),
                                );
                              }

                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_forward_outlined),
                            label: const Text(
                              "Prosseguir",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
