import 'package:flutter/material.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.blue,
          const Color.fromARGB(255, 0, 59, 86),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                borderRadius: BorderRadius.circular(14),
              ),),
              ),
              SizedBox(height: 20,),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                hintText: 'Senha',
                filled: true,
                prefixIcon: Icon(Icons.password),
                border: OutlineInputBorder( 
                borderRadius: BorderRadius.circular(14),
              ),),
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
              onPressed:(){},
              icon: Icon(Icons.login),
              label: Text('Entrar', style: TextStyle(fontSize: 18),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 13, 35, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              
              ),
              ],
                ),
              ),
              ),
              );
              
          }
}

