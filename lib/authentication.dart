import 'package:flutter/material.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.all(30),
            child: Column(
              children: [
                Image.asset(
              'assets/images/logoEmpresa.png',
              width: 150,
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

