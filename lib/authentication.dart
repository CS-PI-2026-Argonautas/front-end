import 'package:flutter/material.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Image.asset(
              'lib/assets/images/LogoEmpresa.png',
              width: 350,
              height: 180,
          ),
          
                TextField(decoration: InputDecoration(
                hintText: 'Usuário',
                filled: true,
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue
                ),
              ),),
              ),
              SizedBox(height: 20,),
              TextField(decoration: InputDecoration(
                hintText: 'Senha',
                filled: true,
                prefixIcon: Icon(Icons.password),
                border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue
                ),
              ),),
              ),
              SizedBox(height: 20,),
              
          
              ElevatedButton(onPressed:(){}, child: Text('Entrar')),
              ],
                ),
              ),
              ),
              );
              
          }
}

