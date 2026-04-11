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