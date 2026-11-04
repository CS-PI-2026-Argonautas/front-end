import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/work_order.dart';
import 'package:frontend/ui/pages/client_list/client_list.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/edit_item/item_edition.dart';
import 'package:frontend/ui/pages/os/tabbar/tabbar.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/pages/stand_in_page.dart';
import 'package:frontend/fire_base/repositories/mock_os_repository.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/floatingButton.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/menu.dart';
import 'package:frontend/ui/widgets/show_dialog/show_delete_os.dart';
import 'package:frontend/ui/widgets/show_snackbar/show_delete_os.dart';
import 'package:frontend/ui/widgets/slidable/slidable_delete_card.dart';

class OsListPage extends StatefulWidget {
  const OsListPage({super.key});

  @override
  State<OsListPage> createState() => _OsListPageState();
}

class _OsListPageState extends State<OsListPage> {
  final MockOSRepository _repository = MockOSRepository();

  late Future<List<WorkOrder>> _futureOrdemServicos;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final colors = custom_colors.colorScheme;

  @override
  void initState() {
    super.initState();
    _carregarOrdemServicos();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _carregarOrdemServicos() {
    final Future<List<WorkOrder>> os = _repository.getAll();

    setState(() {
      _futureOrdemServicos = os;
    });
  }

  Color _obterCorDoStatus(String status) {
    switch (status) {
      case 'Concluída':
        return Colors.green;
      case 'Pendente':
      case 'Em Andamento':
        return Colors.orange;
      case 'Fechada':
      case 'Cancelada':
        return Colors.red;
      default:
        return colors.onSurfaceVariant;
    }
  }

  Future<void> _deletarOrdemServicos(WorkOrder os) async {
    await _repository.delete(os.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,

      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Listagem de ordens de serviço',
      ),

      endDrawer: Menu(
        currentIndex: 2,
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

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClientList()),
            );
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Procurar ordem de serviço',
                    filled: true,
                    fillColor: colors.surfaceContainer,
                    hintStyle: TextStyle(color: colors.onSurface),
                    prefixIcon: Icon(Icons.search, color: colors.secondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: colors.secondary),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
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
                        label: const Text(
                          'Filtrar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.8,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.swap_vert),
                          label: const Text(
                            'Ordenar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.8,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
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

                FutureBuilder<List<WorkOrder>>(
                  future: _futureOrdemServicos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Erro ao carregar ordens de serviço.'),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma ordem de serviço encontrada.'),
                      );
                    }

                    final todasOrdens = snapshot.data!;

                    final ordensFiltradas = todasOrdens.where((os) {
                      final idMatch = os.id.toString().toLowerCase().contains(_searchQuery);
                      final nomeMatch = os.name.toLowerCase().contains(_searchQuery);
                      final cidadeMatch = os.city.toLowerCase().contains(_searchQuery);
                      return idMatch || nomeMatch || cidadeMatch;
                    }).toList();

                    if (ordensFiltradas.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Text(
                            'Nenhuma ordem de serviço corresponde à pesquisa.',
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                        ),
                      );
                    }

                    return Card(
                      elevation: 4,
                      color: colors.surfaceContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ordensFiltradas.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: colors.onSurfaceVariant.withOpacity(0.2),
                        ),
                        itemBuilder: (context, index) {
                          return _buildClientCard(ordensFiltradas[index]);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: CustomFloatingButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tabbar(serviceOrderNumber: -1),
            ),
          );
        },      
      ),
    );
  }

  Widget _buildClientCard(WorkOrder os) {
    return SlidableDeleteCard(
      slidableKey: ValueKey(os.id),

      onDelete: () async {
        final confimarExclusao =
            await showDialog(
              context: context,
              builder: (_) => ShowDeleteOsDialog(nome: os.name),
            ) ??
            false;

        if (!confimarExclusao) return;

        await _deletarOrdemServicos(os);

        _carregarOrdemServicos();

        if (!mounted) return;

        final messenger = ScaffoldMessenger.of(context);

        messenger.hideCurrentSnackBar();

        messenger.showSnackBar(
          ShowDeleteOsSnackbar(
            color: colors.primary,
            onPressed: () async {
              await _repository.restore(os.id);

              _carregarOrdemServicos();

              messenger.hideCurrentSnackBar();
            },
            duration: const Duration(seconds: 5),
          ),
        );
      },

      extentRatio: 0.20,

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${os.id} - ${os.name}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    os.city,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    os.status,
                    style: TextStyle(
                      color: _obterCorDoStatus(os.status),
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
                    builder: (context) => const StandInPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}