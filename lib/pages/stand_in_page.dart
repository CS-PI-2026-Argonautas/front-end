import 'package:frontend/pages/dashboard.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:flutter/material.dart';

class StandInPage extends StatelessWidget {
  const StandInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Em construção",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.onSurface),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (route) => false,
          );
              },
              child: const Text("Voltar"),
               style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}