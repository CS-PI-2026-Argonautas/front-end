import 'package:flutter/material.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/form_field_label.dart';
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
        Row(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FormFieldLabel(icon: iconeLabel, label: label),
            _buildBotao(colors),
          ],
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

  // Sem texto: so o icone (igual ao de endereco hoje).
  // Com texto: botao com icone + texto.
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
      onPressed: onPressed,
      icon: Icon(iconeBotao, color: colors.secondary, size: 22),
      label: Text(
        textoBotao!,
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
        color: colors.surfaceContainer,
        border: Border.all(color: colors.primary.withOpacity(0.5), width: 1),
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
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

/* ---------------------------------------------------------------
EXEMPLO DE USO (substitui o bloco de endereco em person_registration.dart)

SelectionField<String>(
  label: 'Endereço',
  iconeLabel: Icons.home_outlined,
  itens: _enderecos,
  tituloItem: (e) => e,
  textoVazio: 'Nenhum endereço adicionado.',
  permitirExclusao: true,
  onPressed: () async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const PersonRegistrationAddress()),
    );
    if (resultado != null && resultado.trim().isNotEmpty && mounted) {
      setState(() => _enderecos.add(resultado));
    }
  },
  onEdit: (endereco, index) async {
    final editado = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => PersonRegistrationAddress(enderecoInicial: endereco),
      ),
    );
    if (editado != null && editado.isNotEmpty && mounted) {
      setState(() => _enderecos[index] = editado);
    }
  },
  onDelete: (endereco, index) async {
    // mesma logica atual: ShowDeleteClientDialog + removeAt + snackbar DESFAZER
  },
)

// Issue #139 (equipamento da OS): exclusao desabilitada, edicao mantida
SelectionField<String>(
  label: 'Equipamento',
  iconeLabel: Icons.devices_other_outlined,
  textoBotao: 'Selecionar',
  iconeItem: Icons.build,
  itens: _equipamentos,
  tituloItem: (e) => e,
  permitirExclusao: false,
  onPressed: _abrirSheetEquipamentos, // abre o SelectionBottomSheet (#136)
  onEdit: (equip, index) => _editarEquipamento(equip, index),
)
--------------------------------------------------------------- */