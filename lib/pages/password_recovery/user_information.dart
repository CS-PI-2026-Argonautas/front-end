import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/pages/password_recovery/reset_password.dart';
import 'package:frontend/services/password_recovery/code_service.dart';
import 'package:frontend/utils/password_recovery/validators.dart';
import 'package:frontend/widgets/password_recovery/password_field.dart';
import 'package:frontend/widgets/password_recovery/modal.dart';

class UserInformation extends StatefulWidget{

  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();

}

class _UserInformationState extends State<UserInformation>{

  final CodeService codeService = CodeService();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: Text('Recuperar Senha'),
      ),
        body: SafeArea(
          child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Para redefinição de sua senha, informe seu nome de usuário e enviaremos um código para redefinir sua senha.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 80,),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome de Usuário',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      PasswordField(
                        controller: null,
                        enabled: true,
                        validator: (value) => requiredField(value),
                        hintText: 'Digite seu nome de usuário...',
                        sensitiveContent: false,
                      ),
                    ],
                  ),
                ),
                
                Spacer(),

                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 6,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: FilledButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()){
                              
                              final choice = await showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: 'Confirmação de e-mail',
                                pageBuilder: (_, __, ___, ){
                                  return Modal(
                                    titleText: 'Seu e-mail está correto? ',
                                    questionText: 'em*****ail@exem****plo.com',
                                  );
                                },
                              );

                              if(choice == true){

                                codeService.createCode();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResetPassword(
                                      codeService: codeService,
                                    ),
                                  ),
                                );
                              }   

                            }

                          },
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Prosseguir',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 6,),

                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Dúvidas? Contate nosso suporte',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      SizedBox(height: 6,),

                    ],
                  ),
                  
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}