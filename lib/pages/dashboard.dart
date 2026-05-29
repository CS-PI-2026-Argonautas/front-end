import 'package:flutter/material.dart';
import 'package:frontend/pages/authentication.dart';
import 'package:frontend/pages/person_registration/person_registration.dart';
import 'package:frontend/pages/product_registration/product_registration.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_Colors;
import 'package:frontend/widgets/bottom_bar.dart';
import 'package:frontend/pages/stand_in_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = custom_Colors.colorScheme;

    void irParaStandIn() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StandInPage()),
      );
    }

    void irParaCadastroPessoa() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PersonRegistration()),
      );
    }

    Widget botaoDashboard({
      required String texto,
      required IconData icone,
      required bool preenchido,
    }) {
      if (preenchido) {
        return ElevatedButton.icon(
          onPressed: irParaStandIn,
          icon: Icon(icone),
          label: Text(texto),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onSecondary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }

      return OutlinedButton.icon(
        onPressed: irParaCadastroPessoa,
        icon: Icon(icone),
        label: Text(texto),
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          backgroundColor: colors.surfaceContainer,
          side: BorderSide(color: colors.primary),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Authentication(),
                  ),
                );
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: colors.primary,
              ),
              icon: const Icon(Icons.arrow_back),
            ),

            const SizedBox(width: 12),

            Image.asset('lib/assets/icons/LogoEmpresa.png', width: 200),
          ],
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bem-vindo ao Dashboard!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: botaoDashboard(
                  texto: "Ver mais",
                  icone: Icons.visibility_outlined,
                  preenchido: true,
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: botaoDashboard(
                  texto: "Cadastrar cliente",
                  icone: Icons.person_add_alt_1_outlined,
                  preenchido: false,
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        onTap: (index) {

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductRegistration(),
              ),
            );
          }


          if (index == 2 || index == 3 || index == 0) {
            irParaStandIn();
          }
        },
      ),
    );
  }
}
