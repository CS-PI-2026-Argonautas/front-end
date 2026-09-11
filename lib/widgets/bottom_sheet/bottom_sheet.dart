import 'package:flutter/material.dart';

class SelectionBottomSheet<T> extends StatefulWidget {
  final String titulo;
  final List<T> itens;

  final String textoBusca;
  final String textoAcao;

  final String Function(T item) tituloItem;
  final String Function(T item)? subtituloItem;

  final bool carregando;

  final VoidCallback? onAcao;
  final void Function(T item) onSelecionar;

  const SelectionBottomSheet({
    super.key,
    required this.titulo,
    required this.itens,
    required this.textoBusca,
    required this.textoAcao,
    required this.tituloItem,
    this.subtituloItem,
    this.carregando = false,
    this.onAcao,
    required this.onSelecionar,
  });

  @override
  State<SelectionBottomSheet<T>> createState() =>
      _SelectionBottomSheetState<T>();
}

class _SelectionBottomSheetState<T> extends State<SelectionBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
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
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: widget.onAcao,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                hintText: widget.textoBusca,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.itens.length,
                itemBuilder: (context, index) {
                  final item = widget.itens[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,

                    title: Text(widget.tituloItem(item)),

                    subtitle: widget.subtituloItem != null
                        ? Text(widget.subtituloItem!(item))
                        : null,

                    trailing: const Icon(Icons.chevron_right),

                    onTap: () {
                      widget.onSelecionar(item);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onAcao,
                icon: const Icon(Icons.add),
                label: Text(widget.textoAcao),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
