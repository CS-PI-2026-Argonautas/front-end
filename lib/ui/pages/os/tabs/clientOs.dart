import 'package:flutter/material.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/bottom_sheet/bottom_sheet.dart';

class ClientOs extends StatefulWidget {
  final VoidCallback onNext;

  const ClientOs({super.key, required this.onNext});

  
  @override
  State<ClientOs> createState() => _ClientOsState();
}

class _ClientOsState extends State<ClientOs> {

  final List<Map<String, dynamic>> clientesDisponiveis = [
    {"id": 1, "nome": "João Silva", "telefone": "(44) 99876-5432"},
    {"id": 2, "nome": "Maria Santos", "telefone": "(44) 98765-4321"},
    {"id": 3, "nome": "Carlos Oliveira", "telefone": "(44) 99123-4567"},
    {"id": 4, "nome": "Ana Paula", "telefone": "(44) 99988-7766"},
  ];

  Map<String, dynamic>? clienteSelecionado;
  
  void _abrirListaClientes() {
    final colors = custom_colors.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SelectionBottomSheet<Map<String, dynamic>>(
          titulo: 'Selecionar cliente',
          itens: clientesDisponiveis,
          textoBusca: 'Procurar cliente',
          textoAcao: 'Novo cliente',
          tituloItem: (cliente) => cliente['nome'].toString(),
          subtituloItem: (cliente) => cliente['telefone'].toString(),
          iconeItem: Icons.person_outline,
          carregando: false,
          onAcao: null,
          onSelecionar: (cliente) {
            _selecionarCliente(cliente);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _selecionarCliente(Map<String, dynamic> cliente) {
    setState(() {
      clienteSelecionado = cliente;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return Container(
      color: colors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(
                'Cliente *',
                colors,
                onAdd: _abrirListaClientes,
                addLabel: 'Adicionar cliente',
              ),
              const SizedBox(height: 35),
              _buildLabel(
                'Endereço *',
                colors,
                onAdd: () {},
                addLabel: 'Adicionar Endereço',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(
    String text,
    ColorScheme colors, {
    VoidCallback? onAdd,
    String addLabel = 'Adicionar',
  }) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (onAdd != null)
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: Text(addLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E9E5F),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }
}
