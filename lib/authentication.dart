import 'package:flutter/material.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(150.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 30,
            children: [
              Image.asset('assets/images/LogoEmpresa.png',),
              TextField(decoration: InputDecoration(
                hintText: 'Login',
                filled: true,
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue
                ),
              ),),),
              
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
          
              ElevatedButton(onPressed:(){}, child: Text('Entrar')),
            ],
          ),
          ),
        ),
      );
    
    }
}

