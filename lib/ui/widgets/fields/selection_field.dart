import 'package:flutter/material.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/form/form_field_label.dart';
import 'package:frontend/ui/widgets/slidable/slidable_delete_card.dart';

class SelectionField<T> extends StatelessWidget {
  final String label;
  final IconData iconeLabel;

  final String? textoBotao;
  final IconData iconeBotao;
  final VoidCallback? onPressed;

  final List<T> itens;
  final String Function(T item) tituloItem;
  final IconData iconeItem;
  final String textoVazio;

  final bool permitirExclusao;
  final void Function(T item, int index)? onDelete;
  final void Function(T item, int index)? onEdit;

  const SelectionField({
    super.key,
    required this.label,
    required this.itens,
    required this.tituloItem,
    this.iconeLabel = Icons.home_outlined,
    this.textoBotao,
    this.iconeBotao = Icons.add_box_rounded,
    this.onPressed,
    this.iconeItem = Icons.location_on,
    this.textoVazio = 'Nenhum item adicionado.',
    this.permitirExclusao = true,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
  builder: (context, constraints) {
    // Se a largura disponível for menor que 320px, muda para Column
    final bool eTelaPequena = constraints.maxWidth < 320;

    if (eTelaPequena) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldLabel(
            icon: iconeLabel,
            label: label,
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildBotao(colors),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FormFieldLabel(
            icon: iconeLabel,
            label: label,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: _buildBotao(colors),
        ),
      ],
    );
  },
),
        const SizedBox(height: 8),
        if (itens.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              textoVazio,
              style: TextStyle(
                color: colors.onSurfaceVariant.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itens.length,
            itemBuilder: (context, index) {
              final item = itens[index];
              final titulo = tituloItem(item);

              final card = _buildCard(colors, item, index, titulo);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: permitirExclusao
                      ? SlidableDeleteCard(
                          slidableKey: ValueKey('$titulo-$index'),
                          extentRatio: 0.20,
                          onDelete: () => onDelete?.call(item, index),
                          child: card,
                        )
                      : card,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildBotao(ColorScheme colors) {
    if (textoBotao == null || textoBotao!.isEmpty) {
      return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(iconeBotao, color: colors.secondary, size: 26),
        onPressed: onPressed,
      );
    }

    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      icon: Icon(iconeBotao, color: colors.secondary, size: 20),
      label: Text(
        textoBotao!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: colors.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCard(ColorScheme colors, T item, int index, String titulo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border.all(color: colors.surfaceContainerHigh, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(iconeItem, color: colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              titulo, 
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: Icon(Icons.edit, color: colors.primary),
              onPressed: () => onEdit!(item, index),
            )
          else
            const SizedBox(height: 48),
        ],
      ),
    );
  }
}