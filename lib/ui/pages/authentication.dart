import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/create_login_account/create_login_acccount.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/password_recovery/user_information.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool _isPasswordVisible = false;
  final colors = custom_colors.colorScheme;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, const Color.fromARGB(255, 0, 59, 86)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card( 
                  color: colors.surfaceContainer,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    spacing: 24,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'lib/assets/images/LogoEmpresaAzul.png',
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 180,
                        fit: BoxFit.contain,
                      ),

                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Usuário',
                          hintStyle: TextStyle(
                            color: colors.onSurface, // Defina a cor desejada aqui
                          ),
                          filled: true,
                          fillColor: colors.surfaceContainerHigh,
                          prefixIcon: Icon(
                            Icons.person, 
                            color: colors.primary,
                            ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          hintStyle: TextStyle(
                            color: colors.onSurface, // Defina a cor desejada aqui
                          ),
                          filled: true,
                          fillColor: colors.surfaceContainerHigh,
                          prefixIcon: Icon(
                            Icons.password,
                            color: colors.primary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                                  color: _isPasswordVisible 
                                  ? colors.secondary
                                  :colors.onSurfaceVariant,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserInformation(),
        ),
      );
    },
    style: ButtonStyle(
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      // Remove a cor de fundo cinza ao passar o mouse ou clicar
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      // Remove o efeito visual de clique do Material
      splashFactory: NoSplash.splashFactory,
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return colors.primary; // Cor ao CLICAR
        }
        if (states.contains(WidgetState.hovered)) {
          return colors.secondary; // Cor ao PASSAR O MOUSE
        }
        return colors.onSurfaceVariant; // Cor PADRÃO
      }),
    ),
    child: const Text(
      "Esqueceu a senha?",
      style: TextStyle(fontSize: 15),
    ),
  ),
),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Aviso", style: TextStyle(color: colors.onSurface),),
                                  content: Text(
                                    "Digite o usuário e/ou a sua senha",
                                    style: TextStyle(color: colors.onSurface),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK", style: TextStyle(color: colors.onSurface),),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(colors.surfaceContainerHigh),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Dashboard(),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.login),
                          label: const Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.secondary,
                            foregroundColor: colors.onSecondary,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      MouseRegion(
  cursor: SystemMouseCursors.click,
  child: StatefulBuilder(
    builder: (context, setStateText) {
      bool isHovered = false;
      bool isPressed = false;

      return StatefulBuilder(
        builder: (context, setStateState) {
          Color signUpColor = colors.onSurface; // Cor padrão

          if (isPressed) {
            signUpColor = colors.primary; // Cor ao CLICAR
          } else if (isHovered) {
            signUpColor = colors.secondary; // Cor ao PASSAR O MOUSE
          }

          return MouseRegion(
            onEnter: (_) => setStateState(() => isHovered = true),
            onExit: (_) => setStateState(() => isHovered = false),
            child: GestureDetector(
              onTapDown: (_) => setStateState(() => isPressed = true),
              onTapUp: (_) => setStateState(() => isPressed = false),
              onTapCancel: () => setStateState(() => isPressed = false),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateLoginAccount(),
                  ),
                );
              },
              child: Text.rich(
                TextSpan(
                  style: TextStyle(color: colors.onSurface, fontSize: 16),
                  children: [
                    const TextSpan(text: "Não tem uma conta? "),
                    TextSpan(
                      text: "Cadastre-se",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: signUpColor, // Apenas a palavra Cadastre-se muda de cor
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
    },
  ),
),
      ],
                  ),
                ),
                ),
                ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}
