import 'package:flutter/material.dart';

class UserInformationScreen extends StatefulWidget{

  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();

}

class _UserInformationScreenState extends State<UserInformationScreen>{

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: Text('Recuperar Senha'),
      ),
        body: SafeArea(
          child: Padding(
          padding: EdgeInsets.all(16),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextFormField(

                      // POSSIVEL VALIDAÇÃO FUTURA
                      // validator: (value) {
                      //   if(value == null || value.isEmpty){
                      //     return 'Campo obrigatório';
                      //   }
                      //   return null;
                      // },
                      
                      decoration: InputDecoration(
                        hintText: 'Digite seu nome de usuário...',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
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
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Prosseguir',
                      style: TextStyle(
                        fontSize: 16,
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
        
      



      // body: Padding(
      //   padding: EdgeInsets.all(16),
      //   child: Card(
      //     child: Padding(
      //       padding: EdgeInsets.all(16),
      //       child: Center(
      //         child: Column(
      //           children: [
      //             Text(
      //               'INFORME SEU NOME DE USUÁRIO', 
      //               textAlign: TextAlign.justify,
      //             ),
      //             Text(
      //               'Para redefinição de senha, insira seu nome de usuário e enviaremos um e-mail com um código para redefinir sua senha',
      //               textAlign: TextAlign.right,
      //             ),
      //             SizedBox(height: 10,),
      //             TextFormField(
      //               decoration: InputDecoration(
      //                 label: Text('Nome de Usuário'),
      //                 hintText: 'Digite aqui seu nome de usuário',
      //               ),
      //             ),
      //             SizedBox(height: 10,),
      //             ElevatedButton(
      //               onPressed: () => {
      //                 print('Confirmar e-mail'),
      //                 print('opa'),
      //               },
      //               child: Text('Avançar'),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),

    );
  }

}