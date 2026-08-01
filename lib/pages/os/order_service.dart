import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class OrderService extends StatefulWidget {
  const OrderService({super.key});

  @override
  State<OrderService> createState() => _OrderService();
}

class _OrderService extends State<OrderService> {
  final colors = custom_colors.colorScheme;

  @override
  Widget build(BuildContext context) {
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
                    "R\$0,00",
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
                child: ListView(
                  children: [
                    _buildPieceCard(),
                    const SizedBox(height: 12),
                    _buildPieceCard(),
                    const SizedBox(height: 12),
                    _buildPieceCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPieceCard() {
    return Container(
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
                  "Nome da peça",
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "1 un x R\$0,00/un",
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "R\$0,00",
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
                onPressed: () {},
                icon: Icon(Icons.add_box_outlined, color: colors.primary),
              ),

              Text(
                "1",
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.indeterminate_check_box_outlined,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
