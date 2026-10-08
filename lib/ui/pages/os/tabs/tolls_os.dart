import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/repositories/item_repository.dart';
import 'package:frontend/fire_base/services/item_service.dart';

import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/widgets/bottom_sheet/bottom_sheet.dart';

class TollsOs extends StatefulWidget {
  const TollsOs({super.key});

  @override
  State<TollsOs> createState() => TollsOsState();
}

class TollsOsState extends State<TollsOs>
    with AutomaticKeepAliveClientMixin {
  final colors = custom_colors.colorScheme;

  final ItemService _itemService = ItemService(
    ItemRepository(),
  );

  final List<Map<String, dynamic>> orderParts = [];

  @override
  bool get wantKeepAlive => true;

  int _calculateSubtotal() {
    int subtotal = 0;

    for (final part in orderParts) {
      final int quantity = part["quantity"];
      final int priceInCents = part["price"];

      subtotal += quantity * priceInCents;
    }

    return subtotal;
  }

  String _formatPrice(int cents) {
    final reais = cents ~/ 100;
    final decimal = cents % 100;

    return "R\$${reais.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )},${decimal.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final int subtotal = _calculateSubtotal();

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subtotal de peças",
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatPrice(subtotal),
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: orderParts.isEmpty
                    ? Center(
                        child: Text(
                          "Nenhuma peça adicionada",
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: orderParts.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          return _buildPartCard(
                            orderParts[index],
                            index,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPartList,
        backgroundColor: colors.primary,
        elevation: 3,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  void _openPartList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return StreamBuilder<List<Item>>(
          stream: _itemService.watchParts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Erro ao carregar peças.",
                  style: TextStyle(
                    color: colors.onSurface,
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<Item> parts = snapshot.data ?? [];

            return SelectionBottomSheet<Item>(
              titulo: "Selecionar peça",
              itens: parts,
              textoBusca: "Buscar peça...",
              textoAcao: "Nova peça",
              iconeItem: Icons.build_outlined,
              tituloItem: (part) => part.name,
              subtituloItem: (part) =>
                  _formatPrice(part.valueInCents),
              onSelecionar: (part) {
                final bool alreadyAdded = orderParts.any(
                  (item) => item["id"] == part.id,
                );

                if (alreadyAdded) {
                  showDialog(
                    context: this.context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: const Text(
                          "Peça já adicionada",
                        ),
                        content: Text(
                          'A peça "${part.name}" já está adicionada nesta OS.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );

                  return;
                }

                _addPart(part);
                Navigator.pop(bottomSheetContext);
              },
              onAcao: () {
                Navigator.push(
                  bottomSheetContext,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductRegistration(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _addPart(Item part) {
    setState(() {
      orderParts.add({
        "id": part.id,
        "name": part.name,
        "price": part.valueInCents,
        "quantity": 1,
      });
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      orderParts[index]["quantity"]++;
    });
  }

  void _decreaseQuantity(int index) {
    if (orderParts[index]["quantity"] <= 1) {
      return;
    }

    setState(() {
      orderParts[index]["quantity"]--;
    });
  }

  Widget _buildPartCard(
    Map<String, dynamic> part,
    int index,
  ) {
    final int quantity = part["quantity"];
    final int priceInCents = part["price"];

    final int totalItem = quantity * priceInCents;

    return Slidable(
      key: ValueKey(part["id"]),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (context) {
              setState(() {
                orderParts.removeAt(index);
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
          color: colors.surfaceContainer,
          border: Border.all(
            color: colors.primary,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    part["name"],
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$quantity un x "
                    "${_formatPrice(priceInCents)}/un",
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatPrice(totalItem),
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _increaseQuantity(index);
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: colors.primary,
                  ),
                ),
                Text(
                  "$quantity",
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: quantity > 1
                      ? () {
                          _decreaseQuantity(index);
                        }
                      : null,
                  icon: Icon(
                    Icons.indeterminate_check_box_outlined,
                    color: quantity > 1
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