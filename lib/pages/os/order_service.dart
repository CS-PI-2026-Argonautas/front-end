import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderService extends StatefulWidget {
  const OrderService({super.key});

  @override
  State<OrderService> createState() => _OrderService();
}

class _OrderService extends State<OrderService> {
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
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Ordens e Serviços",
          style: TextStyle(
            color: colors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Placeholder do menu",
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ),
              ),

              const SizedBox(height: 24),

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
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        onPressed: _abrirListaPecas,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _abrirListaPecas() {
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

                const SizedBox(height: 20),

                Text(
                  "Selecionar peça",
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
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

  startActionPane: ActionPane(
    motion: const DrawerMotion(),
    extentRatio: 0.25,
    children: [
      SlidableAction(
        onPressed: (context) {
          setState(() {
            pecasDaOrdem.removeAt(index);
          });
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Excluir',
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
