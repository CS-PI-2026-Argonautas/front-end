import 'package:flutter/material.dart';
import 'package:frontend/fire_base/Enums/PersonType.dart';
import 'package:frontend/fire_base/models/client.dart';
import 'package:frontend/fire_base/services/client_service.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/edit_item/item_edition.dart';
import 'package:frontend/ui/pages/os_list/os_list_page.dart';
import 'package:frontend/ui/pages/person_alteration/person_alteration.dart';
import 'package:frontend/ui/pages/person_registration/person_registration.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/floatingButton.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/menu.dart';
import 'package:frontend/ui/widgets/show_dialog/show_delete_client_dialog.dart';
import 'package:frontend/ui/widgets/show_snackbar/show_delete_client_snackbar.dart';
import 'package:frontend/ui/widgets/slidable/slidable_delete_card.dart';

enum ClientSortOption {
  padrao,
  nomeAsc,
  nomeDesc,
  contatoAsc,
}

class ClientList extends StatefulWidget {
  const ClientList({super.key});

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final ClientService _service = ClientService();

  late final Stream<List<Client>> _clientes = _service.observar();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  PersonType? _selectedPersonTypeFilter;
  ClientSortOption _sortOption = ClientSortOption.padrao;

  final colors = custom_colors.colorScheme;

  @override
  void initState() {
    super.initState();
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

  String _labelOrdenacao(ClientSortOption option) {
    switch (option) {
      case ClientSortOption.padrao:
        return 'Padrão';
      case ClientSortOption.nomeAsc:
        return 'Nome (A–Z)';
      case ClientSortOption.nomeDesc:
        return 'Nome (Z–A)';
      case ClientSortOption.contatoAsc:
        return 'Contato (A–Z)';
    }
  }

  String _labelTipoPessoa(PersonType type) {
  switch (type) {
    case PersonType.physical:
      return 'Pessoa Física';
    case PersonType.legal:
      return 'Pessoa Jurídica';
  }
}

  Widget _buildFilterChip({
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
      side: const BorderSide(
        color: Colors.transparent,
        width: 1.2,
      ),
      onSelected: (_) {
        onSelect();
        Navigator.pop(modalContext);
      },
    );
  }

  void _abrirModalFiltro() {
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
                      'Filtrar por tipo de pessoa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    if (_selectedPersonTypeFilter != null)
                      TextButton(
                        onPressed: () {
                          setState(() => _selectedPersonTypeFilter = null);
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
                    _buildFilterChip(
                      modalContext: modalContext,
                      label: 'Todos',
                      isSelected: _selectedPersonTypeFilter == null,
                      onSelect: () =>
                          setState(() => _selectedPersonTypeFilter = null),
                    ),
                    ...PersonType.values.map(
                      (type) => _buildFilterChip(
                        modalContext: modalContext,
                        label: _labelTipoPessoa(type),
                        isSelected: _selectedPersonTypeFilter == type,
                        onSelect: () =>
                            setState(() => _selectedPersonTypeFilter = type),
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
                  'Ordenar clientes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
              ),
              ...ClientSortOption.values.map((option) {
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

  List<Client> _filtrarEOrdenar(List<Client> todosClientes) {
    final filtrados = todosClientes.where((cliente) {
      final matchesQuery = _searchQuery.isEmpty ||
          cliente.name.toLowerCase().contains(_searchQuery) ||
          cliente.contact.resumo.toLowerCase().contains(_searchQuery);

      final matchesPersonType = _selectedPersonTypeFilter == null ||
          cliente.personType == _selectedPersonTypeFilter;

      return matchesQuery && matchesPersonType;
    }).toList();

    switch (_sortOption) {
      case ClientSortOption.padrao:
        break;
      case ClientSortOption.nomeAsc:
        filtrados.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case ClientSortOption.nomeDesc:
        filtrados.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
      case ClientSortOption.contatoAsc:
        filtrados.sort(
          (a, b) => a.contact.resumo
              .toLowerCase()
              .compareTo(b.contact.resumo.toLowerCase()),
        );
        break;
    }

    return filtrados;
  }

  Future<void> _deletarCliente(Client cliente) async {
    await _service.excluir(cliente.id);
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
        title: 'Listagem de clientes',
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

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OsListPage(),
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
                      hintText: 'Procurar cliente',
                      filled: true,
                      fillColor: colors.surfaceContainer,
                      hintStyle: TextStyle(
                        color: colors.onSurface,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colors.secondary,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              tooltip: 'Limpar pesquisa',
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
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _abrirModalFiltro,
                          icon: Icon(
                            _selectedPersonTypeFilter != null
                                ? Icons.filter_alt
                                : Icons.tune,
                          ),
                          label: Text(
                            _selectedPersonTypeFilter != null
                                ? 'Filtrar: ${_labelTipoPessoa(_selectedPersonTypeFilter!)}'
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
                            _sortOption == ClientSortOption.padrao
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
                        if (_selectedPersonTypeFilter != null ||
                            _sortOption != ClientSortOption.padrao)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedPersonTypeFilter = null;
                                _sortOption = ClientSortOption.padrao;
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
                              backgroundColor: colors.surfaceContainerHighest,
                              overlayColor:
                                  colors.secondary.withValues(alpha: 0.12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 18.0,
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
                  StreamBuilder<List<Client>>(
                    stream: _clientes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Center(
                            child: Text(
                              'Erro ao carregar clientes.',
                            ),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Center(
                            child: Text(
                              'Nenhum cliente encontrado.',
                            ),
                          ),
                        );
                      }

                      final clientesFiltrados =
                          _filtrarEOrdenar(snapshot.data!);

                      if (clientesFiltrados.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Center(
                            child: Text(
                              'Nenhum cliente corresponde à pesquisa ou filtro.',
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
                          itemCount: clientesFiltrados.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: colors.onSurfaceVariant.withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            return _buildClientCard(clientesFiltrados[index]);
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonRegistration(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClientCard(Client cliente) {
    return SlidableDeleteCard(
      slidableKey: ValueKey(cliente.id),
      extentRatio: 0.20,
      onDelete: () async {
        final confirmarExclusao = await showDialog<bool>(
              context: context,
              builder: (_) => ShowDeleteClientDialog(
                nome: cliente.name,
              ),
            ) ??
            false;

        if (!confirmarExclusao) return;

        await _deletarCliente(cliente);

        if (!mounted) return;

        final messenger = ScaffoldMessenger.of(context);

        messenger.hideCurrentSnackBar();

        messenger.showSnackBar(
          ShowDeleteClientSnackbar(
            color: colors.primary,
            onPressed: () async {
              await _service.restaurar(cliente.id);

              if (!mounted) return;

              messenger.hideCurrentSnackBar();
            },
            duration: const Duration(seconds: 5),
          ),
        );
      },
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
                    cliente.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    cliente.contact.resumo,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonAlteration(
                      cliente: cliente,
                    ),
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