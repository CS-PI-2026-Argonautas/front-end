import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/password_setting/password_setting.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/widgets/form_section_tile.dart';
import 'package:frontend/widgets/header.dart';

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
      appBar : Header(
        onBack: () { Navigator.pop(context);},
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
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormSectionTile(
                        title: "Cadastro do seu Usuário",
                        subtitle: "Informe seus dados pessoais.",
                      ),                      
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.badge, size: 20, color: colors.primary),
                          Text(
                            "Nome *",
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
                          hintText: 'Nome',
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
                          if (value == null || value.trim().isEmpty) {
                            return 'preencha o campo  ';
                          }
                          return null;
                        },
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.badge, size: 20, color: colors.primary),
                          Text(
                            "Sobrenome *",
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
                          hintText: 'Sobrenome ',
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
                          if (value == null || value.trim().isEmpty) {
                            return 'preencha o campo';
                          }
                          return null;
                        },
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.person_3, size: 20, color: colors.primary),
                          Text(
                            "Nome usuário *",
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
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._\-]')), //caracteres especiais
                                    FilteringTextInputFormatter.deny(RegExp(r'\s')), //nao deixa o usuario usar o espaço
                                  ],
                        maxLength: 25,
                        validator: (value) {

                        if (value == null || value.trim().isEmpty) {
                          return 'Preencha o campo';
                        }
                        
                        if (value.length < 3) {
                          return 'mínimo 3 caracteres';
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
                          hintText: 'nome.sobrenome',
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.email, size: 20, color: colors.primary),
                          Text(
                            "Email *",
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
                          hintText: 'nome@exemplo.com',
                          filled: true,
                          
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'preencha o campo';
                          }
                          
                          final bool emailValido = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                          ).hasMatch(value);

                          if (!emailValido) {
                            return 'Insira um formato de email válido';
                          }
                          
                          return null;
                        },
                      ),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PasswordSetting(),
                                ),
                            );
                              
                            if (_formKey.currentState!.validate());
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
