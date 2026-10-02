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

  final TextEditingController _searchController =
      TextEditingController();

  final colors = custom_colors.colorScheme;

  String _termoBusca = '';

  @override
  void initState() {
    super.initState();

    _carregarOrdemServicos();

    _searchController.addListener(() {
      setState(() {
        _termoBusca = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _carregarOrdemServicos() {
    _futureOrdemServicos = _service.listAll();
  }

  Future<void> _atualizarLista() async {
    setState(() {
      _carregarOrdemServicos();
    });

    await _futureOrdemServicos;
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

  Future<void> _deletarOrdemServico(Services os) async {
    await _service.delete(os.id);
  }

  Future<void> _restaurarOrdemServico(Services os) async {
    await _service.restore(os.id);
  }

  List<Services> _filtrarOrdens(List<Services> ordens) {
    if (_termoBusca.isEmpty) {
      return ordens;
    }

    return ordens.where((os) {
      final id = os.id.toLowerCase();
      final nome = os.name.toLowerCase();
      final cliente = os.client.toLowerCase();
      final equipamento = os.equipment.toLowerCase();
      final cidade = os.city.toLowerCase();
      final tecnico = os.assignee.toLowerCase();
      final status = os.status.toLowerCase();

      return id.contains(_termoBusca) ||
          nome.contains(_termoBusca) ||
          cliente.contains(_termoBusca) ||
          equipamento.contains(_termoBusca) ||
          cidade.contains(_termoBusca) ||
          tecnico.contains(_termoBusca) ||
          status.contains(_termoBusca);
    }).toList();
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

        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: () {
              setState(() {
                _carregarOrdemServicos();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
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
        child: RefreshIndicator(
          onRefresh: _atualizarLista,

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 30,
              ),

              child: Column(
                children: [

                  TextFormField(
                    controller: _searchController,

                    decoration: InputDecoration(
                      hintText: 'Procurar OS',

                      filled: true,
                      fillColor: Colors.white,

                      hintStyle: TextStyle(
                        color: colors.onSurface,
                      ),

                      prefixIcon: const Icon(Icons.search),

                      suffixIcon: _termoBusca.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                              },
                              icon: const Icon(Icons.clear),
                            )
                          : null,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _mostrarFiltro(context);
                            },

                            icon: const Icon(Icons.tune),

                            label: const Text('FILTRAR'),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _mostrarOrdenacao(context);
                            },

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
                      top: 20,
                      bottom: 10,
                    ),

                    child: Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        _termoBusca.isEmpty
                            ? 'Recentes'
                            : 'Resultados da busca',

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
                          padding: EdgeInsets.only(top: 40),

                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildErro(snapshot.error);
                      }

                      if (!snapshot.hasData) {
                        return _buildVazio(
                          'Nenhuma ordem de serviço encontrada.',
                        );
                      }

                      final ordensFiltradas =
                          _filtrarOrdens(snapshot.data!);

                      if (ordensFiltradas.isEmpty) {
                        return _buildVazio(
                          _termoBusca.isEmpty
                              ? 'Nenhuma ordem de serviço encontrada.'
                              : 'Nenhuma OS encontrada para "$_termoBusca".',
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,

                        physics:
                            const NeverScrollableScrollPhysics(),

                        itemCount: ordensFiltradas.length,

                        itemBuilder: (context, index) {
                          final os = ordensFiltradas[index];

                          return _buildOsCard(os);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => const Tabbar(
                serviceOrderNumber: -1,
              ),
            ),
          );

          if (!mounted) return;

          setState(() {
            _carregarOrdemServicos();
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
  Widget _buildOsCard(Services os) {
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

            try {
              await _deletarOrdemServico(os);

              if (!mounted) return;

              setState(() {
                _carregarOrdemServicos();
              });

              final messenger =
                  ScaffoldMessenger.of(context);

              messenger.hideCurrentSnackBar();

              messenger.showSnackBar(
                ShowDeleteOsSnackbar(
                  color: colors.primary,

                  onPressed: () async {
                    try {
                      await _restaurarOrdemServico(os);

                      if (!mounted) return;

                      setState(() {
                        _carregarOrdemServicos();
                      });

                      messenger.hideCurrentSnackBar();
                    } catch (e) {
                      if (!mounted) return;

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Erro ao restaurar OS: $e',
                          ),
                        ),
                      );
                    }
                  },

                  duration: const Duration(seconds: 5),
                ),
              );
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Erro ao excluir OS: $e',
                  ),
                ),
              );
            }
          },

          extentRatio: 0.20,

          child: Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: colors.surfaceContainer,

              border: Border.all(
                color: colors.primary,
                width: 1.5,
              ),

              borderRadius: BorderRadius.circular(16),
            ),

            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        '#${os.id} - ${os.name}',

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        os.client,

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          color:
                              colors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),

                      Text(
                        os.city,

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          color:
                              colors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),

                      Text(
                        os.status,

                        style: TextStyle(
                          color:
                              _obterCorDoStatus(
                            os.status,
                          ),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),


                IconButton(
                  tooltip: 'Editar',

                  icon: Icon(
                    Icons.edit,
                    color: colors.primary,
                  ),

                  onPressed: () async {
                    await Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => const Tabbar(
                          serviceOrderNumber: -1,
                        ),
                      ),
                    );

                    if (!mounted) return;

                    setState(() {
                      _carregarOrdemServicos();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErro(Object? erro) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),

      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 50,
            color: colors.error,
          ),

          const SizedBox(height: 10),

          Text(
            'Erro ao carregar ordens de serviço.',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            '$erro',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _carregarOrdemServicos();
              });
            },

            icon: const Icon(Icons.refresh),

            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildVazio(String mensagem) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),

      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 50,
            color: colors.onSurfaceVariant,
          ),

          const SizedBox(height: 10),

          Text(
            mensagem,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
  void _mostrarFiltro(BuildContext context) {
    showModalBottomSheet(
      context: context,

      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Filtrar OS',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading:
                      const Icon(Icons.all_inclusive),

                  title: const Text('Todas'),

                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading:
                      const Icon(Icons.pending_actions),

                  title: const Text('Pendentes'),

                  onTap: () {
                    _searchController.text =
                        'Pendente';

                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading:
                      const Icon(Icons.engineering),

                  title:
                      const Text('Em Andamento'),

                  onTap: () {
                    _searchController.text =
                        'Em Andamento';

                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading:
                      const Icon(Icons.check_circle),

                  title:
                      const Text('Concluídas'),

                  onTap: () {
                    _searchController.text =
                        'Concluída';

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarOrdenacao(BuildContext context) {
    showModalBottomSheet(
      context: context,

      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Padding(
                padding: EdgeInsets.all(20),

                child: Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Ordenar por',

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              ListTile(
                leading:
                    const Icon(Icons.access_time),

                title:
                    const Text('Mais recentes'),

                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading:
                    const Icon(Icons.sort_by_alpha),

                title:
                    const Text('Nome'),

                onTap: () {
                  Navigator.pop(context);

                },
              ),
            ],
          ),
        );
      },
    );
  }
}