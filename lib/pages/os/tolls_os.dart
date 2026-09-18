import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/pages/product_registration/product_registration.dart';
import 'package:frontend/widgets/bottom_sheet/bottom_sheet.dart';

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
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
     return SelectionBottomSheet<Map<String, dynamic>>(
  titulo: "Selecionar peça",
  itens: pecasDisponiveis,

  textoBusca: "Buscar peça...",
  textoAcao: "Nova peça",

  iconeItem: Icons.build_outlined,

  tituloItem: (peca) => peca["nome"],

  subtituloItem: (peca) =>
      "R\$${peca["preco"].toStringAsFixed(2)}",

  onSelecionar: (peca) {
    _adicionarPeca(peca);
    Navigator.pop(context);
  },

  onAcao: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductRegistration(),
      ),
    );
  },
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
