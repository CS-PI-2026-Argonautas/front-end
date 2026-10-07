import 'package:flutter/material.dart';
import 'package:frontend/fire_base/models/endereco.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/form_field_label.dart';
import 'package:frontend/ui/widgets/show_dialog/show_delete_client_dialog.dart';
import 'package:frontend/ui/widgets/show_snackbar/show_delete_client_snackbar.dart';
import 'package:frontend/ui/widgets/slidable/slidable_delete_card.dart';
import 'package:frontend/utils/data_os/address_formatter.dart';

class EnderecosEditor extends StatefulWidget {
  final List<Endereco> enderecos;

  final Future<Endereco?> Function(Endereco? inicial) abrirFormulario;

  const EnderecosEditor({
    super.key,
    required this.enderecos,
    required this.abrirFormulario,
  });

  @override
  State<EnderecosEditor> createState() => _EnderecosEditorState();
}

class _EnderecosEditorState extends State<EnderecosEditor> {
  final colors = custom_colors.colorScheme;

  Future<void> _adicionar() async {
    final novo = await widget.abrirFormulario(null);

    if (novo != null && mounted) {
      setState(() {
        widget.enderecos.add(novo);
      });
    }
  }

  Future<void> _editar(int index) async {
    final editado = await widget.abrirFormulario(widget.enderecos[index]);

    if (editado != null && mounted) {
      setState(() {
        widget.enderecos[index] = editado;
      });
    }
  }

  Future<void> _remover(int index) async {
    final endereco = widget.enderecos[index];

    final confirmar =
        await showDialog<bool>(
          context: context,
          builder: (_) =>
              ShowDeleteClientDialog(nome: formatarEndereco(endereco)),
        ) ??
        false;

    if (!confirmar || !mounted) return;

    setState(() {
      widget.enderecos.removeAt(index);
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      ShowDeleteClientSnackbar(
        color: colors.primary,
        onPressed: () {
          if (!mounted) return;
          setState(() {
            widget.enderecos.insert(index, endereco);
          });
          messenger.hideCurrentSnackBar();
        },
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 18,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const FormFieldLabel(icon: Icons.home_outlined, label: "Endereços"),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                Icons.add_box_rounded,
                color: colors.secondary,
                size: 26,
              ),
              onPressed: _adicionar,
            ),
          ],
        ),

        if (widget.enderecos.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Nenhum endereço adicionado.",
              style: TextStyle(
                color: colors.onSurfaceVariant.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.enderecos.length,
            itemBuilder: (context, index) {
              final endereco = widget.enderecos[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SlidableDeleteCard(
                    // [ALTERADO] id agora nunca é nulo (UUID)
                    slidableKey: ValueKey(endereco.id),
                    extentRatio: 0.20,
                    onDelete: () => _remover(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer,
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: colors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              formatarEndereco(endereco),
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: colors.primary),
                            onPressed: () => _editar(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
