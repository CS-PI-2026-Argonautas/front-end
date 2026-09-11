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
    return Container();
  }
}
