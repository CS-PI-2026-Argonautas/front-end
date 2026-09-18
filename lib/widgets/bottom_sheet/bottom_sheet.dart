import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class SelectionBottomSheet<T> extends StatefulWidget {
  final String titulo;
  final List<T> itens;

  final String textoBusca;
  final String textoAcao;

  final String Function(T item) tituloItem;
  final String Function(T item)? subtituloItem;

  final IconData? iconeItem;

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
    this.iconeItem,
    this.carregando = false,
    this.onAcao,
    required this.onSelecionar,
  });

  @override
  State<SelectionBottomSheet<T>> createState() =>
      _SelectionBottomSheetState<T>();
}

class _SelectionBottomSheetState<T>
    extends State<SelectionBottomSheet<T>> {
  
  final colors = custom_colors.colorScheme;

  final TextEditingController _buscaController =
      TextEditingController();

  late List<T> _itensFiltrados;

  @override
  void initState() {
    super.initState();

    _itensFiltrados = List.from(widget.itens);

    _buscaController.addListener(_filtrarItens);
  }

  @override
  void dispose() {
    _buscaController.removeListener(_filtrarItens);
    _buscaController.dispose();

    super.dispose();
  }

  void _filtrarItens() {
    final busca = removeDiacritics(
      _buscaController.text,
    ).toLowerCase();

    setState(() {
      _itensFiltrados = widget.itens.where((item) {
        final titulo = removeDiacritics(
          widget.tituloItem(item),
        ).toLowerCase();

        return titulo.contains(busca);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.titulo,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: widget.onAcao,
                  icon: Icon(
                    Icons.add,
                    color: colors.primary,
                    size: 28,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                hintText: widget.textoBusca,
                prefixIcon: Icon(
                  Icons.search,
                  color: colors.onSurfaceVariant,
                ),
                filled: true,
                fillColor: colors.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Flexible(
              child: widget.carregando
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _itensFiltrados.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Nenhum item encontrado',
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _itensFiltrados.length,
                          itemBuilder: (context, index) {
                            final item = _itensFiltrados[index];

                            return ListTile(
                              contentPadding: EdgeInsets.zero,

                              leading: widget.iconeItem != null
                                  ? Icon(
                                      widget.iconeItem,
                                      color: colors.primary,
                                      size: 30,
                                    )
                                  : null,

                              title: Text(
                                widget.tituloItem(item),
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              subtitle: widget.subtituloItem != null
                                  ? Text(
                                      widget.subtituloItem!(item),
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 15,
                                      ),
                                    )
                                  : null,

                              trailing: Icon(
                                Icons.chevron_right,
                                color: colors.onSurfaceVariant,
                              ),

                              onTap: () {
                                widget.onSelecionar(item);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}