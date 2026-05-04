import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/pages/password_recovery/reset_password.dart';
import 'package:frontend/services/password_recovery/code_service.dart';
import 'package:frontend/utils/password_recovery/validators.dart';

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
                      TextFormField(

                        validator: (value) => requiredField(value),
                        
                        decoration: InputDecoration(
                          hintText: 'Digite seu nome de usuário...',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

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
                                  return Stack(
                                    children: [
                                      BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                        child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            color: Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                      ),

                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.all(24),
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Este é seu e-mail? ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              SizedBox(height: 12,),

                                              Text(
                                                'email****@ex***.com',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              SizedBox(height: 40,),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: FilledButton(
                                                      style: FilledButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(vertical: 16),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadiusGeometry.circular(12),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context, true);
                                                      },
                                                      child: Text(
                                                        'Sim',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(width: 24,),

                                                  Expanded(
                                                    child: FilledButton(
                                                      style: FilledButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(vertical: 16),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadiusGeometry.circular(12),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context, false);
                                                      },
                                                      child: Text(
                                                        'Não',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
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