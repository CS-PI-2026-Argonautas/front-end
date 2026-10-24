import 'package:flutter/material.dart';
import 'package:frontend/fire_base/exceptions/login_exception.dart';
import 'package:frontend/fire_base/services/authentication_service.dart';
import 'package:frontend/ui/pages/create_login_account/create_login_acccount.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/password_recovery/user_information.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _service = AuthenticationService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  final colors = custom_colors.colorScheme;
  final _formKey = GlobalKey<FormState>();

  Future<void> login(String email, String password) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await _service.login(email: email, password: password);
    } on AuthException catch (e) {
      showSnackMessage(e.message);
    } catch (f) {
      showSnackMessage('Erro inesperado! Entre em contato com o suporte');
    }

    redirect();
  }

  void showSnackMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.withValues(alpha: 0.87),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void redirect() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.tertiary],
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
                            controller: _emailController,
                            decoration: customInputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(
                                Icons.person,
                                color: colors.primary,
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
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration:
                                customInputDecoration(
                                  hintText: 'Senha',
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: colors.primary,
                                  ),
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: _isPasswordVisible
                                          ? colors.secondary
                                          : colors.onSurfaceVariant,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
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
                                    builder: (context) =>
                                        const UserInformation(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.zero,
                                ),
                                // Remove a cor de fundo cinza ao passar o mouse ou clicar
                                overlayColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                                // Remove o efeito visual de clique do Material
                                splashFactory: NoSplash.splashFactory,
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.pressed,
                                      )) {
                                        return colors.primary; // Cor ao CLICAR
                                      }
                                      if (states.contains(
                                        WidgetState.hovered,
                                      )) {
                                        return colors
                                            .secondary; // Cor ao PASSAR O MOUSE
                                      }
                                      return colors
                                          .onSurfaceVariant; // Cor PADRÃO
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
                              onPressed: () => login(
                                _emailController.text,
                                _passwordController.text,
                              ),
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
                                    Color signUpColor =
                                        colors.onSurface; // Cor padrão

                                    if (isPressed) {
                                      signUpColor =
                                          colors.primary; // Cor ao CLICAR
                                    } else if (isHovered) {
                                      signUpColor = colors
                                          .secondary; // Cor ao PASSAR O MOUSE
                                    }

                                    return MouseRegion(
                                      onEnter: (_) =>
                                          setStateState(() => isHovered = true),
                                      onExit: (_) => setStateState(
                                        () => isHovered = false,
                                      ),
                                      child: GestureDetector(
                                        onTapDown: (_) => setStateState(
                                          () => isPressed = true,
                                        ),
                                        onTapUp: (_) => setStateState(
                                          () => isPressed = false,
                                        ),
                                        onTapCancel: () => setStateState(
                                          () => isPressed = false,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CreateLoginAccount(),
                                            ),
                                          );
                                        },
                                        child: Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              color: colors.onSurface,
                                              fontSize: 16,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: "Não tem uma conta? ",
                                              ),
                                              TextSpan(
                                                text: "Cadastre-se",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      signUpColor, // Apenas a palavra Cadastre-se muda de cor
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
