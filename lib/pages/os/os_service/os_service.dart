import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/pages/stand_in_page.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/widgets/slidable/slidable_delete_card.dart';

class OsServicosTab extends StatefulWidget {
  const OsServicosTab({super.key});

  @override
  State<OsServicosTab> createState() => _OsServicosTabState();
}

class _OsServicosTabState extends State<OsServicosTab> {
  final colors = custom_colors.colorScheme;
  final TextEditingController _searchController = TextEditingController();

  // Dados mockados de serviços
  final List<Map<String, dynamic>> _servicosMock = [
    {
      'id': '1',
      'nome': 'Troca de sensor',
      'descricao': 'Substituição do sensor óptico danificado',
      'preco': 74.00,
      'removido': false,
    },
    {
      'id': '2',
      'nome': 'Orçamento',
      'descricao': 'Análise técnica preventiva e diagnósticos',
      'preco': 74.00,
      'removido': false,
    },
    {
      'id': '3',
      'nome': 'Deslocamento',
      'descricao': 'Taxa de visita técnica residencial',
      'preco': 74.00,
      'removido': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _servicosExibidos {
    final query = _searchController.text.toLowerCase();
    return _servicosMock.where((servico) {
      final bool naoRemovido = servico['removido'] == false;
      final bool atendeFiltro =
          servico['nome'].toString().toLowerCase().contains(query) ||
          servico['descricao'].toString().toLowerCase().contains(query);
      return naoRemovido && atendeFiltro;
    }).toList();
  }

  // Subtotal garantido >= 0
  double get _subtotal {
    final total = _servicosExibidos.fold(
      0.0,
      (sum, item) {
        final double precoItem = (item['preco'] as double? ?? 0.0);
        return sum + max(0.0, precoItem);
      },
    );
    return max(0.0, total);
  }

  Future<void> _deletarServico(Map<String, dynamic> servico) async {
    setState(() {
      servico['removido'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listaAtual = _servicosExibidos;

    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo de Busca
                  TextFormField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Procurar serviço',
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: colors.onSurface),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cabeçalho de Subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal de serviços',
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'R\$ ${_subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Listagem de Cards
                  if (listaAtual.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text('Nenhum serviço encontrado.'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listaAtual.length,
                      itemBuilder: (context, index) {
                        return _buildServiceCard(listaAtual[index]);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),

        // Botão [+] flutuante
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StandInPage()),
              );
            },
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> servico) {
    final double precoCru = (servico['preco'] as double? ?? 0.0);
    final double preco = max(0.0, precoCru);
    final String descricao = servico['descricao'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SlidableDeleteCard(
          slidableKey: ValueKey(servico['id']),
          onDelete: () async {
            final confirmarExclusao = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Remover Serviço'),
                    content: Text('Deseja remover "${servico['nome']}" da OS?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('CANCELAR'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'REMOVER',
                          style: TextStyle(color: colors.error),
                        ),
                      ),
                    ],
                  ),
                ) ??
                false;

            if (!confirmarExclusao) return;

            await _deletarServico(servico);

            if (!mounted) return;

            final messenger = ScaffoldMessenger.of(context);
            messenger.hideCurrentSnackBar();

            messenger.showSnackBar(
              SnackBar(
                content: Text('${servico['nome']} removido.'),
                backgroundColor: colors.primary,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'DESFAZER',
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      servico['removido'] = false;
                    });
                    messenger.hideCurrentSnackBar();
                  },
                ),
              ),
            );
          },
          extentRatio: 0.20,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              border: Border.all(color: colors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  servico['nome'],
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (descricao.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    descricao,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}