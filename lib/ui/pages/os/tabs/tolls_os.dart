import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/repositories/item_repository.dart';
import 'package:frontend/fire_base/services/item_service.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:frontend/ui/widgets/floatingButton.dart';

// onEdit: (servico) async {
//                 await _abrirEdicao(servico);
class TollsOs extends StatefulWidget {
  final ServiceOrder serviceOrder;

  const TollsOs({super.key, required this.serviceOrder});

  @override
  State<TollsOs> createState() => OrderServiceState();
}

class OrderServiceState extends State<TollsOs>
    with AutomaticKeepAliveClientMixin {
  final colors = custom_colors.colorScheme;

  late final ServiceOrder _os;
  late final ItemService _itemService;
  late final Stream<List<Item>> _pecasStream;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _os = widget.serviceOrder;

    _itemService = ItemService(ItemRepository());

    _pecasStream = _itemService.watchParts();
  }

  int _calcularSubtotal() {
    return _os.parts.fold<int>(0, (total, peca) => total + peca.subtotalCents);
  }

  Future<void> _abrirEdicao(Item peca) async {
    if (peca.id == null) return;

    final Item? pecaAtualizada = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductRegistration(abertoPelaOS: true, itemEdicao: peca),
      ),
    );

    if (!mounted || pecaAtualizada == null) return;

    _atualizarPecaNaOS(pecaAtualizada);
  }

  void _atualizarPecaNaOS(Item pecaAtualizada) {
    if (pecaAtualizada.id == null) return;

    final index = _os.parts.indexWhere(
      (item) => item.partId == pecaAtualizada.id,
    );

    if (index == -1) return;

    setState(() {
      final pecaAntiga = _os.parts[index];

      _os.parts[index] = ServiceOrderPart(
        partId: pecaAntiga.partId,
        name: pecaAtualizada.name,
        quantity: pecaAntiga.quantity,
        unitPriceCents: pecaAtualizada.valueInCents,
        discountCents: pecaAntiga.discountCents,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<List<Item>>(
      stream: _pecasStream,
      builder: (context, snapshot) {
        final pecasDisponiveis = snapshot.data ?? [];

        return Scaffold(
          backgroundColor: colors.surface,

          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 18,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.build, color: colors.secondary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Subtotal de peças',
                                    style: TextStyle(
                                      color: colors.onSurface,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                Dinheiro(_calcularSubtotal()).formatado(),
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            const LinearProgressIndicator(),

                          if (snapshot.hasError)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'Erro ao carregar peças: ${snapshot.error}',
                                style: TextStyle(color: colors.error),
                              ),
                            ),

                          _os.parts.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhuma peça adicionada',
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(4),
                                  itemCount: _os.parts.length,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 12);
                                  },
                                  itemBuilder: (context, index) {
                                    return _buildPieceCard(
                                      _os.parts[index],
                                      index,
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          floatingActionButton: CustomFloatingButton(
            onPressed: snapshot.hasData && !snapshot.hasError
                ? () => abrirListaPecas(pecasDisponiveis)
                : () {},
          ),
        );
      },
    );
  }

  void abrirListaPecas(List<Item> pecasDisponiveis) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StreamBuilder<List<Item>>(
          stream: _pecasStream,
          initialData: pecasDisponiveis,
          builder: (context, snapshot) {
            final pecas = snapshot.data ?? pecasDisponiveis;

            return SelectionBottomSheet<Item>(
              title: 'Selecionar peça',
              items: pecas,
              searchText: 'Buscar peça...',
              actionText: 'Nova peça',
              itemIcon: Icons.build,

              itemTitle: (peca) => peca.name,

              itemSubtitle: (peca) {
                return Dinheiro(peca.valueInCents).formatado();
              },

              onEdit: (peca) async {
                await _abrirEdicao(peca);
              },

              onSelect: (peca) {
                _adicionarPeca(peca);
                Navigator.pop(sheetContext);
              },

              onAction: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductRegistration(abertoPelaOS: true),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _adicionarPeca(Item peca) {
    if (peca.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Essa peça não possui um identificador válido.'),
        ),
      );
      return;
    }

    setState(() {
      final index = _os.parts.indexWhere((item) => item.partId == peca.id);

      if (index != -1) {
        final parteExistente = _os.parts[index];

        _os.parts[index] = parteExistente.withQuantity(
          parteExistente.quantity + 1,
        );
      } else {
        _os.parts.add(
          ServiceOrderPart(
            partId: peca.id!,
            name: peca.name,
            quantity: 1,
            unitPriceCents: peca.valueInCents,
            discountCents: 0,
          ),
        );
      }
    });
  }

  void _aumentarQuantidade(int index) {
    final peca = _os.parts[index];

    setState(() {
      _os.parts[index] = peca.withQuantity(peca.quantity + 1);
    });
  }

  void _diminuirQuantidade(int index) {
    final peca = _os.parts[index];

    if (peca.quantity <= 1) return;

    setState(() {
      _os.parts[index] = peca.withQuantity(peca.quantity - 1);
    });
  }

  Widget _buildPieceCard(ServiceOrderPart peca, int index) {
    final int quantidade = peca.quantity;

    final Dinheiro preco = Dinheiro(peca.unitPriceCents);

    final Dinheiro totalItem = Dinheiro(peca.subtotalCents);

    return Slidable(
      key: ValueKey(peca.partId),

      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (context) {
              setState(() {
                _os.parts.removeAt(index);
              });
            },
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            borderRadius: BorderRadius.circular(18),
          ),
        ],
      ),

      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          // boxShadow: kElevationToShadow[4],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peca.name,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '$quantidade un x ${preco.formatado()}/un',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    totalItem.formatado(),
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                IconButton(
                  onPressed: () => _aumentarQuantidade(index),
                  icon: Icon(Icons.add, color: colors.primary),
                ),

                Text(
                  '$quantidade',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: quantidade > 1
                      ? () => _diminuirQuantidade(index)
                      : null,
                  icon: Icon(
                    Icons.remove,
                    color: quantidade > 1
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
