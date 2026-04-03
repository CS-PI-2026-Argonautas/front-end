import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: PersonRegistration(),
    debugShowCheckedModeBanner: false,
  ));
}

class PersonRegistration  extends StatefulWidget {
  const PersonRegistration({super.key});

  @override
  State<PersonRegistration> createState() => _PersonRegistrationState();
}

class _PersonRegistrationState extends State<PersonRegistration> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Pessoas',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 64, 126, 207),
        appBar: AppBar(
          title: Row(),      
        ),
        body: 
        Card(child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: Text('Cadastrar'),
                ),
              ],

            ),
          ),
        )),
        ),
        

      );
  }
} 


