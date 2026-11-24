
import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart

import 'package:frontend/fire_base/Enums/StatusOrderService.dart';
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/repositories/os_repository.dart';

import 'package:frontend/ui/pages/client_list/client_list.dart';
=======
import 'package:frontend/fire_base/models/work_order.dart';
import 'package:frontend/ui/pages/lists/client_list.dart';
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/edit_item/item_edition.dart';
import 'package:frontend/ui/pages/lists/service_list.dart';
import 'package:frontend/ui/pages/os/tabbar/tabbar.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/pages/stand_in_page.dart';

import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/floatingButton.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/menu.dart';
import 'package:frontend/ui/widgets/show_dialog/show_delete_os.dart';
import 'package:frontend/ui/widgets/slidable/slidable_delete_card.dart';

class OsListPage extends StatefulWidget {
  const OsListPage({super.key});

  @override
  State<OsListPage> createState() => _OsListPageState();
}

class _OsListPageState extends State<OsListPage> {
  final OsRepository _repository = FirestoreOsRepository();

  late Future<List<ServiceOrder>> _futureOrdemServicos;

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  ServiceOrderStatus? _statusSelecionado;

  bool _ordemCrescente = false;

  final colors = custom_colors.colorScheme;

  @override
  void initState() {
    super.initState();

    _futureOrdemServicos = _repository.listarTodos();

    _searchController.addListener(() {
      setState(() {
        _searchQuery =
            _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _carregarOrdemServicos() {
    setState(() {
      _futureOrdemServicos = _repository.listarTodos();
    });
  }

  Future<void> _recarregarOrdemServicos() async {
    _carregarOrdemServicos();
    await _futureOrdemServicos;
  }

  Color _obterCorDoStatus(ServiceOrderStatus status) {
    switch (status) {
      case ServiceOrderStatus.EM_ORCAMENTO:
      case ServiceOrderStatus.EM_CONSERTO:
        return Colors.orange;

      case ServiceOrderStatus.ENTREGUE:
      case ServiceOrderStatus.PAGA:
      case ServiceOrderStatus.CONCLUIDA:
        return Colors.green;

      case ServiceOrderStatus.CANCELADA:
        return Colors.red;
    }
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();

    return '$dia/$mes/$ano';
  }

  String _formatarNumeroOs(ServiceOrder os) {
    final numero = os.numeroOs;

    if (numero == null) {
      return 'Sem número';
    }

    return numero.toString().padLeft(4, '0');
  }

  List<ServiceOrder> _filtrarOrdens(
    List<ServiceOrder> ordens,
  ) {
    final resultado = ordens.where((os) {
      final numeroOs =
          os.numeroOs?.toString() ?? '';

      final numeroFormatado =
          _formatarNumeroOs(os).toLowerCase();

      final nomeCliente =
          (os.client?.name ?? '').toLowerCase();

      final cidade =
          (os.serviceAddress?.city ?? '').toLowerCase();

      final status = os.status.value.toLowerCase();

      final correspondePesquisa =
          numeroOs.contains(_searchQuery) ||
          numeroFormatado.contains(_searchQuery) ||
          nomeCliente.contains(_searchQuery) ||
          cidade.contains(_searchQuery) ||
          status.contains(_searchQuery);

      final correspondeStatus =
          _statusSelecionado == null ||
          os.status == _statusSelecionado;

      return correspondePesquisa && correspondeStatus;
    }).toList();

    resultado.sort((a, b) {
      final comparacao =
          a.entryDate.compareTo(b.entryDate);

      return _ordemCrescente
          ? comparacao
          : -comparacao;
    });

    return resultado;
  }

  Future<void> _deletarOrdemServico(
    ServiceOrder os,
  ) async {
    try {
      await _repository.deletar(os.id);

      if (!mounted) return;

      _carregarOrdemServicos();

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(
              'Ordem de serviço excluída com sucesso.',
            ),
            backgroundColor: colors.primary,
          ),
        );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao excluir ordem de serviço: $e',
            ),
            backgroundColor: colors.error,
          ),
        );
    }
  }

  Future<void> _confirmarExclusao(
    ServiceOrder os,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => ShowDeleteOsDialog(
        nome: os.numeroOs == null
            ? 'OS sem número'
            : 'OS Nº ${_formatarNumeroOs(os)}',
      ),
    );

    if (confirmar != true || !mounted) return;

    await _deletarOrdemServico(os);
  }

  Future<void> _abrirNovaOs() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Tabbar(
          serviceOrderNumber: -1,
        ),
      ),
    );

    if (!mounted) return;

    _carregarOrdemServicos();
  }

  void _alternarOrdenacao() {
    setState(() {
      _ordemCrescente = !_ordemCrescente;
    });
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
                builder: (context) =>
                    const ProductRegistration(),
              ),
            );
          }

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClientList(),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
              MaterialPageRoute(
                builder: (context) => const ItemEdition(),
              ),
=======
              MaterialPageRoute(builder: (context) => const ServiceList()),
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
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
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
        child: RefreshIndicator(
          onRefresh: _recarregarOrdemServicos,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 50,
              ),
              child: Column(
=======
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
                children: [
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Procurar ordem de serviço',
                      filled: true,
                      fillColor: colors.surfaceContainer,
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
                      hintStyle: TextStyle(
                        color: colors.onSurface,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colors.secondary,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: colors.secondary,
                              ),
=======
                      hintStyle: TextStyle(color: colors.onSurface),
                      prefixIcon: Icon(Icons.search, color: colors.secondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: colors.secondary),
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
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
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        PopupMenuButton<ServiceOrderStatus?>(
                          onSelected: (status) {
                            setState(() {
                              _statusSelecionado = status;
                            });
                          },
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem<
                                  ServiceOrderStatus?>(
                                value: null,
                                child: Text('Todos os status'),
                              ),
                              ...ServiceOrderStatus.values.map(
                                (status) {
                                  return PopupMenuItem<
                                      ServiceOrderStatus?>(
                                    value: status,
                                    child: Text(status.value),
                                  );
                                },
                              ),
                            ];
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Filtrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _alternarOrdenacao,
                          icon: Icon(
                            _ordemCrescente
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                          ),
                          label: Text(
                            _ordemCrescente
                                ? 'Mais antigas'
                                : 'Mais recentes',
                            style: const TextStyle(
=======

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
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
                              fontWeight: FontWeight.bold,
                              fontSize: 14.8,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
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
                        'Ordens de serviço',
=======

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
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
                  FutureBuilder<List<ServiceOrder>>(
                    future: _futureOrdemServicos,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(
                            child: CircularProgressIndicator(),
=======

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
                        final idMatch = os.id.toString().toLowerCase().contains(
                          _searchQuery,
                        );
                        final nomeMatch = os.name.toLowerCase().contains(
                          _searchQuery,
                        );
                        final cidadeMatch = os.city.toLowerCase().contains(
                          _searchQuery,
                        );
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
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
                          ),
                        );
                      }

<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 40,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Erro ao carregar ordens de serviço.',
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: _carregarOrdemServicos,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(
                            child: Text(
                              'Nenhuma ordem de serviço encontrada.',
                            ),
                          ),
                        );
                      }

                      final ordensFiltradas = _filtrarOrdens(
                        snapshot.data!,
                      );

                      if (ordensFiltradas.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: Text(
                              'Nenhuma ordem de serviço corresponde à pesquisa.',
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }

=======
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
                      return Card(
                        elevation: 4,
                        color: colors.surfaceContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListView.separated(
                          shrinkWrap: true,
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: ordensFiltradas.length,
                          separatorBuilder: (context, index) =>
                              Divider(
                            height: 1,
                            color: colors.onSurfaceVariant
                                .withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            return _buildOsCard(
                              ordensFiltradas[index],
                            );
=======
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ordensFiltradas.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: colors.onSurfaceVariant.withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            return _buildClientCard(ordensFiltradas[index]);
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
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
      ),
      floatingActionButton: CustomFloatingButton(
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
        onPressed: _abrirNovaOs,
=======
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tabbar(serviceOrderNumber: -1),
            ),
          );
        },
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
      ),
    );
  }

  Widget _buildOsCard(ServiceOrder os) {
    final nomeCliente =
        os.client?.name ?? 'Cliente não informado';

    final cidade =
        os.serviceAddress?.city ?? 'Cidade não informada';

    final estado =
        os.serviceAddress?.state ?? '';

    final status = os.status.value;

    final numeroOs = _formatarNumeroOs(os);

    return SlidableDeleteCard(
      slidableKey: ValueKey(os.id),
      onDelete: () async {
        await _confirmarExclusao(os);
      },
      extentRatio: 0.20,
      child: Padding(
<<<<<<< HEAD:lib/ui/pages/os_list/os_list_page.dart
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
=======
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
>>>>>>> origin/dev:lib/ui/pages/lists/os_list_page.dart
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OS Nº $numeroOs - $nomeCliente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$cidade${estado.isNotEmpty ? ' - $estado' : ''}',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 9,
                        color: _obterCorDoStatus(os.status),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: _obterCorDoStatus(os.status),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Entrada: ${_formatarData(os.entryDate)}',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Total: ${Dinheiro(os.values.totalCents).formatado()}',
                    style: TextStyle(
                      color: colors.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: colors.secondary,
              ),
              tooltip: 'Editar ordem de serviço',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StandInPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
