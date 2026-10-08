import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/client_list/client_list.dart';
import 'package:frontend/ui/pages/edit_item/item_edition.dart';
import 'package:frontend/ui/pages/os/tabbar/tabbar.dart';
import 'package:frontend/ui/pages/os_list/os_list_page.dart';
import 'package:frontend/ui/pages/person_registration/person_registration.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/pages/stand_in_page.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_Colors;
import 'package:frontend/ui/widgets/menu.dart';


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

    void irParaOrdemServico() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const Tabbar(serviceOrderNumber: '1234'),
    ),
  );
}

    Widget botaoDashboard({
      required String texto,
      required IconData icone,
      required bool preenchido,
    }) {
      if (preenchido) {
  return ElevatedButton.icon(
    onPressed: irParaOrdemServico, // <-- Altere aqui!
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
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,

        automaticallyImplyLeading: false,

        title: Row(
          spacing: 6,
          children: [
            Image.asset('lib/assets/icons/LogoEmpresa.png', width: 200),
          ],
        ),
      ),
      endDrawer: Menu(
        currentIndex: 4,

        onTap: (index) {
          Navigator.pop(context);

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClientList()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductRegistration(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const OsListPage()
              )
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItemEdition()),
            );
          }
          if (index == 5) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClientList()),
            );
          }
        },
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 18,
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

              SizedBox(
                width: double.infinity,
                child: botaoDashboard(
                  texto: "Criar Ordem de Serviço",
                  icone: Icons.assignment_outlined,
                  preenchido: true,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
