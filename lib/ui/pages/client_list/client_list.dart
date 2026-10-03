import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/cliente.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/edit_item/item_edition.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration.dart';
import 'package:frontend/ui/pages/person_registration/person_registration.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/pages/stand_in_page.dart';
import 'package:frontend/fire_base/repositories/mock_client_repository.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/menu.dart';
import 'package:frontend/ui/widgets/show_dialog/show_delete_client_dialog.dart';
import 'package:frontend/ui/widgets/show_snackbar/show_delete_client_snackbar.dart';
import 'package:frontend/ui/widgets/slidable/slidable_delete_card.dart';

class ClientList extends StatefulWidget {
  const ClientList({super.key});

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final MockClientRepository _repository = MockClientRepository();
  late Future<List<Cliente>> _futureClientes;
  final colors = custom_colors.colorScheme;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  void _carregarClientes() {
    final Future<List<Cliente>> clientes = _repository.listarTodos();

    setState(() {
      _futureClientes = clientes;
    });
  }

  // este metodo é ilustrativo, quando houver backend será realmente deletado
  Future<void> _deletarCliente(Cliente cliente) async {
    cliente.removido = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        // Remove a cor sólida para que o flexibeSpace com gradiente apareça
        backgroundColor: Colors.transparent, 
        foregroundColor: colors.onPrimary,
        centerTitle: true,
        elevation: 8, // Define a intensidade da sombra da AppBar
        shadowColor: Colors.black.withOpacity(0.5), // Cor da sombra
        title: const Text(
          'Listar clientes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // Adiciona o gradiente de cor no fundo da AppBar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.primary, 
                colors.tertiary,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      endDrawer: Menu(
        currentIndex: 0,

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
            StandInPage();
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ItemEdition()),
            );
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Procurar cliente',
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: colors.onSurface),
                    prefixIcon: Icon(Icons.search, color: colors.tertiary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.tune),
                        label: const Text('Filtrar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.8)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.secondary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.swap_vert),
                          label: const Text('Ordenar',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.8)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.secondary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recentes',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                //aqui faço meu "for" e adiciono um
                FutureBuilder<List<Cliente>>(
                  future: _futureClientes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Erro ao carregar clientes.'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Nenhum cliente encontrado.'),
                      );
                    }

                    final clientes = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: clientes.length,
                      itemBuilder: (context, index) {
                        return _buildClientCard(clientes[index]);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PersonRegistration()),
          );
        },
        backgroundColor: colors.tertiary,
        foregroundColor: colors.onTertiary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add),
      ),
    );
  }

  // construo meus cards
 Widget _buildClientCard(Cliente cliente) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: SlidableDeleteCard(
      slidableKey: ValueKey(cliente.id),
      onDelete: () async {
        final confimarExclusao =
            await showDialog(
              context: context,
              builder: (_) => ShowDeleteClientDialog(nome: cliente.nome),
            ) ??
            false;

        if (!confimarExclusao) return;

        await _deletarCliente(cliente);

        _carregarClientes();

        if (!mounted) return;

        final messenger = ScaffoldMessenger.of(context);

        messenger.hideCurrentSnackBar();

        messenger.showSnackBar(
          ShowDeleteClientSnackbar(
            color: colors.primary,
            onPressed: () {
              cliente.removido = false;

              _carregarClientes();

              messenger.hideCurrentSnackBar();
            },
            duration: const Duration(seconds: 5),
          ),
        );
      },
      extentRatio: 0.20,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cliente.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    cliente.endereco,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    cliente.info_contato,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: colors.secondary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonAlteration(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
}
