import 'package:flutter/material.dart';
import 'package:frontend/ui/widgets/selection_field.dart';

class EquipmentSection extends StatelessWidget {
  final dynamic equipamento;
  final VoidCallback onOpenCadastro;
  final VoidCallback onBuscar;
  final void Function(dynamic equip) onEdit;

  const EquipmentSection({
    super.key,
    required this.equipamento,
    required this.onOpenCadastro,
    required this.onBuscar,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionField<dynamic>(
      label: 'Equipamento *',
      iconeLabel: Icons.devices_other_outlined,
      textoBotao: equipamento == null
          ? 'Buscar equipamento'
          : 'Editar equipamento',
      iconeBotao: Icons.build_outlined,
      iconeItem: Icons.scale_outlined,
      itens: equipamento != null ? [equipamento] : [],
      tituloItem: (equip) {
        if (equip is String) return equip;
        if (equip is Map) {
          final marca = equip['marca'] ?? '';
          final modelo = equip['modelo'] ?? '';
          return '$marca - $modelo'.trim();
        }
        return equip.toString();
      },
      textoVazio: 'Nenhum equipamento selecionado.',
      permitirExclusao: false,
      onPressed: equipamento == null ? onBuscar : onOpenCadastro,
      onEdit: (equip, index) => onEdit(equip),
    );
  }
}
