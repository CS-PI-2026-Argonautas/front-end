import 'package:flutter/material.dart';

void main() {
  runApp(const PasswordRecoveryPage());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
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
                  label: Text('E-mail: '),
                  hintText: 'Informe seu e-mail',
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

