import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Recuperação de Senha',
      debugShowCheckedModeBanner: false,
      home: UserInformationScreen(),
    );
  }
}




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
        title: Text('Alterar Senha'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'INFORME SEU NOME DE USUÁRIO', 
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    'Para redefinição de senha, insira seu nome de usuário e enviaremos um e-mail com um código para redefinir sua senha',
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Nome de Usuário'),
                      hintText: 'Digite aqui seu nome de usuário',
                    ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () => {
                      print('Confirmar e-mail'),
                      print('opa'),
                    },
                    child: Text('Avançar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }

}