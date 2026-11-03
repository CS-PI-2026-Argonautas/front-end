import 'package:flutter/material.dart';
import 'package:frontend/ui/widgets/fields/selection_field.dart';

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
      label: 'Equipamento*',
      iconeLabel: Icons.devices_other_outlined,
      textoBotao: equipamento == null
          ? 'Cadastrar Equipamento'
          : 'Editar Equipamento',
      iconeBotao: Icons.add,
      iconeItem: Icons.scale,
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
      onPressed: equipamento == null
          ? onOpenCadastro
          : () => onEdit(equipamento),
      onEdit: (equip, index) => onEdit(equip),
    );
  }
}
