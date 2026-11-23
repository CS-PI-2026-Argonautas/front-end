import 'package:flutter/material.dart';
import 'package:frontend/utils/validators/password_strength.dart';

class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.password});

  final String password;

  static final _passwordStrength = PasswordStrength();

  @override
  Widget build(BuildContext context) {
    final score = password.isEmpty
        ? 0
        : _passwordStrength.zxcvbn.evaluate(password).score!.toInt();
    final color = password.isEmpty
        ? Colors.grey
        : _passwordStrength.passwordStrengthColor(score);

    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Segurança da Senha", style: TextStyle(fontSize: 14)),
        Row(
          spacing: 6,
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: password.isEmpty ? 0 : (score + 1) / 5,
                minHeight: 6,
                color: color,
                backgroundColor: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Text(
              password.isEmpty
                  ? "Digite uma senha"
                  : _passwordStrength.passwordStrengthText(score),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
