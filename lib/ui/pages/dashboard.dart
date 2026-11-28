import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/client_list/client_list.dart';
import 'package:frontend/ui/pages/edit_item/item_edition.dart';
import 'package:frontend/ui/pages/os/tabbar/tabbar.dart';
import 'package:frontend/ui/pages/os_list/os_list_page.dart';
import 'package:frontend/ui/pages/person_registration/person_registration.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_Colors;
import 'package:frontend/ui/widgets/menu.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  void _abrir(BuildContext context, Widget pagina) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pagina));
  }

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

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onPrimary,
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
                icon: const Icon(Icons.menu),
                label: const Text('Menu'),
                style: TextButton.styleFrom(
                  foregroundColor: colors.onPrimary,
                ),
              ),
            ),
          ),
        ],
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
        onTap: (index) => _aoSelecionarMenu(context, index),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
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

                // Ação principal
                _BotaoDashboard(
                  texto: 'Criar Ordem de Serviço',
                  icone: Icons.assignment,
                  preenchido: true,
                  onPressed: () => _abrir(
                    context,
                    const Tabbar(serviceOrderNumber: null),
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
                  icone: Icons.add_box,
                  onPressed: () => _abrir(context, const ProductRegistration()),
                ),
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