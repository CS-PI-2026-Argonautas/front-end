import 'package:flutter/material.dart';
import 'package:frontend/pages/product_registration/product_registration.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_Colors;
import 'package:frontend/widgets/menu.dart';
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
        onPressed: irParaStandIn,
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
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,

        automaticallyImplyLeading: false,

        title: Row(
          children: [
            const SizedBox(width: 4),
            Image.asset('lib/assets/icons/LogoEmpresa.png', width: 200),
          ],
        ),
      ),
      endDrawer: Menu(
        currentIndex: 3,

        onTap: (index) {
          Navigator.pop(context);

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductRegistration(),
              ),
            );
          }

          if (index == 0 || index == 2) {
            irParaStandIn();
          }
        },
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
    );
  }
}
