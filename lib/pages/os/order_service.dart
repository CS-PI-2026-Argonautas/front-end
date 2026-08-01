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
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Ordens e Serviços",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
                child: Center(child: Text("placeholder do menu")),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Subtotal de peças",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("R\$0,00", style: TextStyle(fontSize: 18)),
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPieceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Nome da peça",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  SizedBox(height: 6),

                  Text("1 un x R\$0,00/un"),

                  SizedBox(height: 2),

                  Text(
                    "R\$0,00",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_box_outlined),
                ),

                const Text("1"),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.indeterminate_check_box_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
