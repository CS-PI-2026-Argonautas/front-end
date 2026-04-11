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
        title: Text('Recuperar Senha'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Text('Teste de telaaaaaaa'),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }

}



class PasswordRecoveryPage extends StatelessWidget{

  const PasswordRecoveryPage({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Recuperação de Senha',
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: Text('Recuperar Senha'),
        ),
        // backgroundColor: const Color.fromARGB(255, 26, 56, 70),
        body: Center(
          child: Card(
            color: const Color.fromARGB(255, 173, 193, 211),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Usuário:'),
                  hintText: 'Informe seu nome de usuário',
                ),
                
              ),
              ElevatedButton(
                onPressed: (){
                  print('salvou!');
                },
                child: Text('Enviar'),
              ),
            ],
          )
          
          )
        )
      )
    );
  }
}

