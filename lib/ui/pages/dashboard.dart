import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/client_list/client_list.dart';
import 'package:frontend/ui/pages/edit_item/item_edition.dart';
import 'package:frontend/ui/pages/os/tabbar/tabbar.dart';
import 'package:frontend/ui/pages/os/tabs/clientOs.dart';
import 'package:frontend/ui/pages/os/tabs/data_os.dart';
import 'package:frontend/ui/pages/os/tolls_os.dart';
import 'package:frontend/ui/pages/os_list/os_list_page.dart';
import 'package:frontend/ui/pages/person_registration/person_registration.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/pages/service-registration/service_registration.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_Colors;
import 'package:frontend/ui/widgets/menu.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = custom_Colors.colorScheme;

    Widget botaoDashboard({
      required String texto,
      required IconData icone,
      required bool preenchido,
      required VoidCallback onPressed,
    }) {
      const textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

      if (preenchido) {
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icone, size: 26),
          label: Text(texto, style: textStyle),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onSecondary,
            padding: const EdgeInsets.symmetric(vertical: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }

      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone, size: 26),
        label: Text(texto, style: textStyle),
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          backgroundColor: colors.surfaceContainer,
          side: BorderSide(color: colors.primary),
          padding: const EdgeInsets.symmetric(vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onPrimary,
        centerTitle: true,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        title: Row(
          spacing: 6,
          children: [
            Image.asset('lib/assets/icons/LogoEmpresa.png', width: 200),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.tertiary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
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
              MaterialPageRoute(builder: (context) => const OsListPage()),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 24,
              children: [
                Text(
                  "Olá, Rodrigo!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                Card(
                  color: colors.surfaceContainer,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 18,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: botaoDashboard(
                            preenchido: true,
                            texto: "Criar Ordem de Serviço",
                            icone: Icons.assignment,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Tabbar(serviceOrderNumber: '1234'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: botaoDashboard(
                            texto: "Cadastro de Clientes",
                            icone: Icons.people_alt,
                            preenchido: true,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PersonRegistration(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: botaoDashboard(
                            texto: "Cadastro de peça",
                            icone: Icons.precision_manufacturing,
                            preenchido: true,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ProductRegistration(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: botaoDashboard(
                            texto: "Cadastro de serviço",
                            icone: Icons.build,
                            preenchido: true,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ServiceRegistration(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
