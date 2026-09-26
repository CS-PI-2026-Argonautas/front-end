import 'package:flutter/material.dart';

import 'package:frontend/fire_base/models/services.dart';
import 'package:frontend/fire_base/services/services_service.dart';

import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/edit_item/item_edition.dart';
import 'package:frontend/ui/pages/os/tabbar/tabbar.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/pages/stand_in_page.dart';

import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
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
  final ServiceS _service = ServiceS();

  late Future<List<Services>> _futureOrdemServicos;

  final colors = custom_colors.colorScheme;

  @override
  void initState() {
    super.initState();
    _carregarOrdemServicos();
  }

  void _carregarOrdemServicos() {
    _futureOrdemServicos = _service.listAll();
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

  Future<void> _deletarOrdemServicos(Services os) async {
    await _service.delete(os.id);
  }

  Future<void> _restaurarOrdemServicos(Services os) async {
    await _service.restore(os.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,

      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        centerTitle: true,
        title: const Text(
          'Listar OS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StandInPage(),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ItemEdition(),
              ),
            );
          }

          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
            );
          }
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 50,
            ),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Procurar OS',
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: colors.onSurface,
                    ),
                    prefixIcon: const Icon(Icons.search),
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
                        label: const Text('FILTRAR'),
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
                          label: const Text('ORDENAR'),
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
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
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

                FutureBuilder<List<Services>>(
                  future: _futureOrdemServicos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Erro ao carregar ordens de serviço.',
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhuma ordem de serviço encontrada.',
                        ),
                      );
                    }

                    final ordemServicos = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ordemServicos.length,
                      itemBuilder: (context, index) {
                        return _buildClientCard(
                          ordemServicos[index],
                        );
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
            MaterialPageRoute(
              builder: (context) => const Tabbar(
                serviceOrderNumber: -1,
              ),
            ),
          ).then((_) {
            if (!mounted) return;

            setState(() {
              _carregarOrdemServicos();
            });
          });
        },
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildClientCard(Services os) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SlidableDeleteCard(
          slidableKey: ValueKey(os.id),

          onDelete: () async {
            final confirmarExclusao =
                await showDialog<bool>(
                  context: context,
                  builder: (_) => ShowDeleteOsDialog(
                    nome: os.name,
                  ),
                ) ??
                false;

            if (!confirmarExclusao) return;

            await _deletarOrdemServicos(os);

            if (!mounted) return;

            setState(() {
              _carregarOrdemServicos();
            });

            final messenger = ScaffoldMessenger.of(context);

            messenger.hideCurrentSnackBar();

            messenger.showSnackBar(
              ShowDeleteOsSnackbar(
                color: colors.primary,
                onPressed: () async {
                  await _restaurarOrdemServicos(os);

                  if (!mounted) return;

                  setState(() {
                    _carregarOrdemServicos();
                  });

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
              border: Border.all(
                color: colors.primary,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        os.city,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),

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
                  icon: Icon(
                    Icons.edit,
                    color: colors.primary,
                  ),
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
        ),
      ),
    );
  }
}