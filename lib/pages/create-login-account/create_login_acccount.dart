import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class CreateLoginAccount extends StatefulWidget{
  const CreateLoginAccount ({super.key});

  @override
  State<CreateLoginAccount> createState() => CreateLoginAccountState(
  );
}

class CreateLoginAccountState extends State<CreateLoginAccount> {
final colors = custom_colors.colorScheme;

@override
Widget build(BuildContext context) {
return Scaffold(
  body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.primary, Color.fromARGB(255, 0, 59, 86)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
      
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                'Nome *',
                style: TextStyle(
                fontSize: 15,
              
                ),
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                const Text(
                'Sobrenome *',
                style: TextStyle(
                fontSize: 15,
            
                ),
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Sobrenome ',
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                const Text(
                'Nome de usuário *',
                style: TextStyle(
                fontSize: 15,
                
                ),
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'nome.sobrenome',
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                const Text(
                'Email *',
                style: TextStyle(
                fontSize: 15,
              
                ),
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'nome@exemplo.com',
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center( 
                  child: ElevatedButton.icon(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward_outlined),
                      label: const Text(
                        "Prosseguir",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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

