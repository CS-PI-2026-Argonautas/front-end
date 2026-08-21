import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/pages/product_registration/product_registration.dart';

class TollsOs extends StatefulWidget {
  const TollsOs({super.key});

  @override
  State<TollsOs> createState() => OrderServiceState();
}

class OrderServiceState extends State<TollsOs> {
  final colors = custom_colors.colorScheme;

  final List<Map<String, dynamic>> pecasDisponiveis = [
    {"id": 1, "nome": "Pastilha de freio", "preco": 120.00},
    {"id": 2, "nome": "Filtro de óleo", "preco": 35.90},
    {"id": 3, "nome": "Filtro de ar", "preco": 48.50},
    {"id": 4, "nome": "Correia dentada", "preco": 180.00},
    {"id": 5, "nome": "Vela de ignição", "preco": 25.00},
  ];

  final List<Map<String, dynamic>> pecasDaOrdem = [];

  double _calcularSubtotal() {
    double subtotal = 0;

    for (final peca in pecasDaOrdem) {
      final int quantidade = peca["quantidade"];
      final double preco = peca["preco"];

      subtotal += quantidade * preco;
    }

    return subtotal;
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = _calcularSubtotal();

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    "R\$${subtotal.toStringAsFixed(2)}",
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
                child: pecasDaOrdem.isEmpty
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
                        itemCount: pecasDaOrdem.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          return _buildPieceCard(pecasDaOrdem[index], index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirListaPecas,
        backgroundColor: Colors.white,
        elevation: 3,
        child: Icon(Icons.add, color: colors.primary, size: 28),
      ),
    );
  }

  void abrirListaPecas() {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selecionar peça",
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: colors.primary, size: 26),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductRegistration(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: pecasDisponiveis.length,
                    itemBuilder: (context, index) {
                      final peca = pecasDisponiveis[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.build_outlined,
                          color: colors.primary,
                        ),
                        title: Text(
                          peca["nome"],
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "R\$${peca["preco"].toStringAsFixed(2)}",
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: colors.onSurfaceVariant,
                        ),
                        onTap: () {
                          _adicionarPeca(peca);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _adicionarPeca(Map<String, dynamic> peca) {
    setState(() {
      pecasDaOrdem.add({
        "id": peca["id"],
        "nome": peca["nome"],
        "preco": peca["preco"],
        "quantidade": 1,
      });
    });
  }

  void _aumentarQuantidade(int index) {
    setState(() {
      pecasDaOrdem[index]["quantidade"]++;
    });
  }

  void _diminuirQuantidade(int index) {
    if (pecasDaOrdem[index]["quantidade"] <= 1) {
      return;
    }

    setState(() {
      pecasDaOrdem[index]["quantidade"]--;
    });
  }

  Widget _buildPieceCard(Map<String, dynamic> peca, int index) {
    final int quantidade = peca["quantidade"];
    final double preco = peca["preco"];
    final double totalItem = quantidade * preco;

    return Slidable(
      key: ValueKey(peca["id"]),

      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (context) {
              setState(() {
                pecasDaOrdem.removeAt(index);
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
          border: Border.all(color: colors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peca["nome"],
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "$quantidade un x R\$${preco.toStringAsFixed(2)}/un",
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "R\$${totalItem.toStringAsFixed(2)}",
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
                  onPressed: () => _aumentarQuantidade(index),
                  icon: Icon(Icons.add_box_outlined, color: colors.primary),
                ),

                Text(
                  "$quantidade",
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
                    Icons.indeterminate_check_box_outlined,
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
