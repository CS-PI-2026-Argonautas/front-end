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

enum OsSortOption {
  recenteId,
  nomeAsc,
  cidadeAsc,
}

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
  String? _selectedStatusFilter;
  OsSortOption _sortOption = OsSortOption.recenteId;

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

  String _labelOrdenacao(OsSortOption option) {
    switch (option) {
      case OsSortOption.recenteId:
        return 'Mais recentes';
      case OsSortOption.nomeAsc:
        return 'Nome (A–Z)';
      case OsSortOption.cidadeAsc:
        return 'Cidade (A–Z)';
    }
  }

  void _carregarOrdemServicos() {
    final Future<List<WorkOrder>> os = _repository.getAll();

    setState(() {
      _futureOrdemServicos = os;
    });
  }

  Future<void> _abrirTabbar(WorkOrder? os) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Tabbar(serviceOrderNumber: os?.id ?? -1),
      ),
    );
    if (mounted) {
      _carregarOrdemServicos();
    }
  }

  Widget _buildStatusChip({
  required BuildContext modalContext,
  required String label,
  required bool isSelected,
  required VoidCallback onSelect,
}) {
  final Color unselectedTextColor = colors.onSurfaceVariant;
  final Color selectedTextColor = colors.onPrimary;

  return ChoiceChip(
    label: Text(label),
    selected: isSelected,
    selectedColor: colors.primary,
    backgroundColor: colors.surfaceContainerHigh,
    checkmarkColor: selectedTextColor,
    labelStyle: TextStyle(
      color: isSelected ? selectedTextColor : unselectedTextColor,
      fontWeight: FontWeight.w600,
    ),
    side: BorderSide(
      color: isSelected ? Colors.transparent : Colors.transparent,
      width: 1.2,
    ),
    onSelected: (_) {
      onSelect();
      Navigator.pop(modalContext);
    },
  );
}

  void _abrirModalFiltro(List<WorkOrder> todasOrdens) {
    final statuses = todasOrdens
        .map((e) => e.status.trim())
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    showModalBottomSheet<void>(
      context: context,
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtrar por status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    if (_selectedStatusFilter != null)
                      TextButton(
                        onPressed: () {
                          setState(() => _selectedStatusFilter = null);
                          Navigator.pop(modalContext);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: colors.surfaceContainerHighest,
                          foregroundColor: colors.onSurface,
                        ),
                        child: const Text('Limpar'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatusChip(
                      modalContext: modalContext,
                      label: 'Todos',
                      isSelected: _selectedStatusFilter == null,
                      onSelect: () =>
                          setState(() => _selectedStatusFilter = null),
                    ),
                    ...statuses.map(
                      (status) => _buildStatusChip(
                        modalContext: modalContext,
                        label: status,
                        isSelected: _selectedStatusFilter == status,
                        onSelect: () =>
                            setState(() => _selectedStatusFilter = status),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _abrirModalOrdenacao() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Ordenar ordens de serviço',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
              ),
              ...OsSortOption.values.map((option) {
                final isSelected = _sortOption == option;
                return ListTile(
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? colors.primary : colors.onSurfaceVariant,
                  ),
                  title: Text(_labelOrdenacao(option)),
                  onTap: () {
                    setState(() => _sortOption = option);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  List<WorkOrder> _filtrarEOrdenar(List<WorkOrder> todasOrdens) {
    final filtradas = todasOrdens.where((os) {
      final matchesQuery = _searchQuery.isEmpty ||
          os.id.toString().toLowerCase().contains(_searchQuery) ||
          os.name.toLowerCase().contains(_searchQuery) ||
          os.city.toLowerCase().contains(_searchQuery);

      final matchesStatus = _selectedStatusFilter == null ||
          os.status.trim() == _selectedStatusFilter;

      return matchesQuery && matchesStatus;
    }).toList();

    switch (_sortOption) {
      case OsSortOption.recenteId:
        filtradas.sort((a, b) => b.id.compareTo(a.id));
        break;
      case OsSortOption.nomeAsc:
        filtradas.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case OsSortOption.cidadeAsc:
        filtradas.sort(
          (a, b) => a.city.toLowerCase().compareTo(b.city.toLowerCase()),
        );
        break;
    }

    return filtradas;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth >= 768 ? 40.0 : 20.0;
    final verticalPadding = screenWidth >= 768 ? 36.0 : 24.0;

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
        child: FutureBuilder<List<WorkOrder>>(
          future: _futureOrdemServicos,
          builder: (context, snapshot) {
            final todasOrdens = snapshot.data ?? const <WorkOrder>[];

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Procurar ordem de serviço',
                          filled: true,
                          fillColor: colors.surfaceContainer,
                          hintStyle: TextStyle(color: colors.onSurface),
                          prefixIcon:
                              Icon(Icons.search, color: colors.secondary),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  tooltip: 'Limpar pesquisa',
                                  icon: Icon(
                                    Icons.clear,
                                    color: colors.secondary,
                                  ),
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
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: snapshot.hasData
                                  ? () => _abrirModalFiltro(todasOrdens)
                                  : null,
                              icon: Icon(
                                _selectedStatusFilter != null
                                    ? Icons.filter_alt
                                    : Icons.tune,
                              ),
                              label: Text(
                                _selectedStatusFilter != null
                                    ? 'Filtrar: $_selectedStatusFilter'
                                    : 'Filtrar',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.8,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _abrirModalOrdenacao,
                              icon: const Icon(Icons.swap_vert),
                              label: Text(
                                _sortOption == OsSortOption.recenteId
                                    ? 'Ordenar'
                                    : 'Ordenar: ${_labelOrdenacao(_sortOption)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.8,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            if (_selectedStatusFilter != null ||
                                _sortOption != OsSortOption.recenteId)
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _selectedStatusFilter = null;
                                    _sortOption = OsSortOption.recenteId;
                                  });
                                },
                                icon: const Icon(Icons.close, size: 18),
                                label: const Text(
                                  'Limpar ajustes',
                                  style: TextStyle(
                                    fontSize: 14.8,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: colors.onSurface,
                                  backgroundColor:
                                      colors.surfaceContainerHighest,
                                  overlayColor:
                                      colors.secondary.withValues(alpha: 0.12),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
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
                      _buildListaConteudo(snapshot),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: () => _abrirTabbar(null),
      ),
    );
  }

  Widget _buildListaConteudo(AsyncSnapshot<List<WorkOrder>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Padding(
        padding: EdgeInsets.only(top: 24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (snapshot.hasError) {
      return const Padding(
        padding: EdgeInsets.only(top: 24.0),
        child: Center(
          child: Text('Erro ao carregar ordens de serviço.'),
        ),
      );
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 24.0),
        child: Center(
          child: Text('Nenhuma ordem de serviço encontrada.'),
        ),
      );
    }

    final ordensFiltradas = _filtrarEOrdenar(snapshot.data!);

    if (ordensFiltradas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Center(
          child: Text(
            'Nenhuma ordem de serviço corresponde à pesquisa ou filtro.',
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
  }

  Widget _buildClientCard(WorkOrder os) {
    return SlidableDeleteCard(
      slidableKey: ValueKey(os.id),
      onDelete: () async {
        final confimarExclusao = await showDialog<bool>(
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
      child: InkWell(
        onTap: () => _abrirTabbar(os),
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
                tooltip: 'Editar ordem de serviço',
                icon: Icon(Icons.edit, color: colors.secondary),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StandInPage(),
                    ),
                  );
                  if (mounted) {
                    _carregarOrdemServicos();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}