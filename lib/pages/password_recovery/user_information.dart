import 'dart:ui';

import 'package:flutter/material.dart';

class UserInformation extends StatefulWidget{

  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();

}

class _UserInformationState extends State<UserInformation>{

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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Spacer(flex: 1,),

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

                        validator: (value) {
                          if(value == null || value.trim().isEmpty){
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        
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
                
                Spacer(flex: 3,),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: FilledButton(
                      onPressed: () => {
                        if (_formKey.currentState!.validate()){
                          showGeneralDialog(
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
                                          Text(
                                            'email****@ex***.com',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              FilledButton(
                                                style: FilledButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(vertical: 16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadiusGeometry.circular(12),
                                                  ),
                                                ),
                                                onPressed: () => {},
                                                child: Text(
                                                  'Sim',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              FilledButton(
                                                style: FilledButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(vertical: 16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadiusGeometry.circular(12),
                                                  ),
                                                ),
                                                onPressed: () => {},
                                                child: Text(
                                                  'Não',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
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
                            }
                          ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}


