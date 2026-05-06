import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/pages/password_recovery/user_information.dart';
import 'package:frontend/pages/person_registration/person_registration.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/style/inputDecorationStyles.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool _isPasswordVisible = false;
  final colors = custom_colors.colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.primary, const Color.fromARGB(255, 0, 59, 86)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/LogoEmpresa.png',
                width: 350,
                height: 180,
              ),

              TextField(
                decoration: customInputDecoration(
                  hintText: 'Usuário',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                obscureText: !_isPasswordVisible,
                decoration: customInputDecoration(
                  hintText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                ).copyWith( // Usamos copyWith para adicionar o suffixIcon específico de senha
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: colors.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserInformation(),
                      ),
                    );
                  },
                  child: const Text(
                    "Esqueceu senha?",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              
              const SizedBox(height: 60), 

              SizedBox(
                height: 55,
                width: 160,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Entrar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colors.primary,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonRegistration(),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    children: [
                      TextSpan(text: "Não tem uma conta? "),
                      TextSpan(
                        text: "Cadastre-se",
                        style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                    ],
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