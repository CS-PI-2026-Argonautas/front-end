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
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('bora recuperar a senha meu filho')
            ],
          )
        )
      )
    );
  }
}

