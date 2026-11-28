import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/lists/client_list.dart';
import 'package:frontend/ui/pages/lists/item_list.dart';
import 'package:frontend/ui/pages/lists/service_list.dart';
import 'package:frontend/ui/pages/os/tabbar/tabbar.dart';
import 'package:frontend/ui/pages/lists/os_list_page.dart';
import 'package:frontend/ui/pages/person_registration/person_registration.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/pages/service_registration/service_registration.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_Colors;
import 'package:frontend/ui/widgets/menu.dart';
<<<<<<< HEAD
import 'package:uuid/uuid.dart';
=======
import 'package:frontend/fire_base/models/app_user.dart';
import 'package:frontend/fire_base/services/authentication_service.dart';
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  void _abrir(BuildContext context, Widget pagina) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pagina));
  }

  String _novoIdOrdemServico() => const Uuid().v4();

  void _aoSelecionarMenu(BuildContext context, int index) {
    Navigator.pop(context);

    switch (index) {
      case 0:
        _abrir(context, const ClientList());
        break;
      case 1:
        _abrir(context, const ProductRegistration());
        break;
      case 2:
        _abrir(context, const OsListPage());
        break;
      case 3:
        _abrir(context, const ItemEdition());
        break;
      case 5:
        _abrir(context, const ClientList());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = custom_Colors.colorScheme;

<<<<<<< HEAD
=======
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

>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onPrimary,
<<<<<<< HEAD
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        centerTitle: false,
        titleSpacing: 16,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'lib/assets/icons/LogoEmpresa.png',
            width: 200,
            alignment: Alignment.centerLeft,
          ),
        ),
        actions: [
          Builder(
  builder: (context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: TextButton.icon(
      onPressed: () => Scaffold.of(context).openEndDrawer(),
      label: const Text('Menu'),
      icon: const Icon(Icons.menu),
      iconAlignment: IconAlignment.end,
      style: TextButton.styleFrom(
        foregroundColor: colors.onPrimary,
      ),
    ),
  ),
),
        ],
=======
        centerTitle: true,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        title: Row(
          spacing: 6,
          children: [
            Image.asset('lib/assets/icons/LogoEmpresa.png', width: 200),
          ],
        ),
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
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
<<<<<<< HEAD
        onTap: (index) => _aoSelecionarMenu(context, index),
=======

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
              MaterialPageRoute(builder: (context) => const ItemList()),
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
              MaterialPageRoute(builder: (context) => const ServiceList()),
            );
          }
        },
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
<<<<<<< HEAD
            constraints: const BoxConstraints(maxWidth: 280),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 14,
              children: [
                Text(
                  'Bem-vindo ao Dashboard!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),

               
                _BotaoDashboard(
                  texto: 'Criar Ordem de Serviço',
                  icone: Icons.assignment,
                  preenchido: true,
                  onPressed: () => _abrir(
                    context,
                    Tabbar(serviceOrderNumber: _novoIdOrdemServico()),
                  ),
                ),

                _BotaoDashboard(
                  texto: 'Cadastrar Cliente',
                  icone: Icons.person_add,
                  onPressed: () => _abrir(context, const PersonRegistration()),
                ),
                _BotaoDashboard(
                  texto: 'Ordens de Serviço',
                  icone: Icons.list_alt,
                  onPressed: () => _abrir(context, const OsListPage()),
                ),
                _BotaoDashboard(
                  texto: 'Clientes',
                  icone: Icons.people,
                  onPressed: () => _abrir(context, const ClientList()),
                ),
                _BotaoDashboard(
                  texto: 'Cadastrar Produto',
                  icone: Icons.inventory_2,
                  onPressed: () => _abrir(context, const ProductRegistration()),
                ),
=======
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 24,
              children: [
                FutureBuilder<AppUser?>(
                  future: AuthenticationService().getLoggedUser(),
                  builder: (context, snapshot) {
                    final usuarioLogado = snapshot.data;
                    return Text(
                      usuarioLogado != null
                          ? "Olá, ${usuarioLogado.name}!"
                          : "Olá!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    );
                  },
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
>>>>>>> 6e881a1b1949c2773039a0aa79c90b3bd05e1fec
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _BotaoDashboard extends StatelessWidget {
  const _BotaoDashboard({
    required this.texto,
    required this.icone,
    required this.onPressed,
    this.preenchido = false,
  });

  final String texto;
  final IconData icone;
  final VoidCallback onPressed;
  final bool preenchido;

  @override
  Widget build(BuildContext context) {
    final colors = custom_Colors.colorScheme;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    const padding = EdgeInsets.symmetric(vertical: 16);

    if (preenchido) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone),
        label: Text(texto),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onSecondary,
          padding: padding,
          shape: forma,
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icone),
      label: Text(texto),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        backgroundColor: colors.surfaceContainer,
        side: BorderSide(color: colors.primary),
        padding: padding,
        shape: forma,
      ),
    );
  }
}