import 'package:flutter/material.dart';

import 'package:frontend/fire_base/Enums/ProductType.dart' as tipos;
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/repositories/item_repository.dart';
import 'package:frontend/fire_base/services/item_service.dart';
import 'package:frontend/ui/pages/dashboard.dart';
import 'package:frontend/ui/pages/lists/client_list.dart';
import 'package:frontend/ui/pages/lists/os_list_page.dart';
import 'package:frontend/ui/pages/lists/service_list.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/floatingButton.dart';
import 'package:frontend/ui/widgets/appBar.dart';
import 'package:frontend/ui/widgets/menu.dart';
import 'package:frontend/ui/widgets/slidable/slidable_delete_card.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final ItemService _itemService = ItemService(repository: ItemRepository());

  late final Stream<List<Item>> _pecas = _itemService.watchParts();

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

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

  String _formatarValor(int centavos) {
    return Dinheiro(centavos).formatado().replaceAll(RegExp(r'[\s\u00A0]'), '');
  }

  Future<void> _deletarPeca(Item peca) async {
    final id = peca.id;

    if (id == null || id.isEmpty) {
      throw StateError('Peça sem identificador.');
    }

    await _itemService.delete(id);
  }

  Future<void> _restaurarPeca(Item peca) async {
    final id = peca.id;

    if (id == null || id.isEmpty) {
      throw StateError('Peça sem identificador.');
    }

    await _itemService.restore(id);
  }

  Future<void> _abrirCadastro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductRegistration()),
    );
  }

  Future<void> _abrirEdicao(Item peca) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductRegistration(itemEdicao: peca)),
    );
  }

  Future<void> _confirmarRemocao(Item peca) async {
    final confirmar =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Remover peça'),
            content: Text('Deseja remover "${peca.name}" do catálogo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text(
                  'Remover',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmar || !mounted) return;

    try {
      await _deletarPeca(peca);

      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          backgroundColor: colors.primary,
          content: Row(
            children: [
              Expanded(
                child: Text(
                  'Peça ${peca.name} foi removida com sucesso!',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                tooltip: 'Fechar',
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'DESFAZER',
            textColor: Colors.white,
            onPressed: () async {
              try {
                await _restaurarPeca(peca);
              } catch (e) {
                debugPrint('Erro ao restaurar peça: $e');

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Não foi possível restaurar a peça.'),
                  ),
                );
              }
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('Erro ao remover peça: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível remover a peça.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surface,

      appBar: Header(
        onBack: () {
          Navigator.pop(context);
        },
        title: 'Listagem de peças',
      ),

      endDrawer: Menu(
        currentIndex: 1,
        onTap: (index) {
          Navigator.pop(context);

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClientList()),
            );
          }

          if (index == 1) {
            // Já estamos na listagem de peças.
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OsListPage()),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ServiceList()),
            );
          }

          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Dashboard()),
            );
          }
        },
      ),

      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Procurar peça',
                      filled: true,
                      fillColor: colors.surfaceContainer,
                      hintStyle: TextStyle(color: colors.onSurface),
                      prefixIcon: Icon(Icons.search, color: colors.secondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: colors.secondary),
                              onPressed: _searchController.clear,
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
                          padding: const EdgeInsets.only(left: 10),
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
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
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

                  StreamBuilder<List<Item>>(
                    stream: _pecas,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar peças.'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma peça encontrada.'),
                        );
                      }

                      // Garante que somente peças sejam exibidas.
                      final todasPecas = snapshot.data!
                          .where((peca) => peca.type == tipos.ProductType.parts)
                          .toList();

                      final pecasFiltradas = todasPecas.where((peca) {
                        return peca.name.toLowerCase().contains(_searchQuery);
                      }).toList();

                      if (pecasFiltradas.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: Text(
                              'Nenhuma peça corresponde à pesquisa.',
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
                          itemCount: pecasFiltradas.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: colors.onSurfaceVariant.withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            return _buildPartCard(pecasFiltradas[index]);
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

      floatingActionButton: CustomFloatingButton(onPressed: _abrirCadastro),
    );
  }

  Widget _buildPartCard(Item peca) {
    return SlidableDeleteCard(
      slidableKey: ValueKey(peca.id),
      extentRatio: 0.20,
      onDelete: () => _confirmarRemocao(peca),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peca.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatarValor(peca.valueInCents),
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: Icon(Icons.edit, color: colors.secondary),
              onPressed: () => _abrirEdicao(peca),
            ),
          ],
        ),
      ),
    );
  }
}
