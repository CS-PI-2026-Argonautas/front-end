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

  // Catálogo de serviços disponíveis para seleção no Bottom Sheet
  final List<Map<String, dynamic>> _servicosDisponiveis = [
    {
      'id': '1',
      'nome': 'Troca de sensor',
      'descricao': 'Substituição do sensor óptico danificado',
      'preco': 74.00,
    },
    {
      'id': '2',
      'nome': 'Orçamento',
      'descricao': 'Análise técnica preventiva e diagnósticos',
      'preco': 74.00,
    },
    {
      'id': '3',
      'nome': 'Deslocamento',
      'descricao': 'Taxa de visita técnica residencial',
      'preco': 74.00,
    },
    {
      'id': '4',
      'nome': 'Manutenção Preventiva',
      'descricao': 'Limpeza e regulagem geral de componentes',
      'preco': 150.00,
    },
    {
      'id': '5',
      'nome': 'Formatação e Reinstalação',
      'descricao': 'Restauração do sistema operacional',
      'preco': 120.00,
    },
  ];

  // Serviços adicionados à Ordem de Serviço
  final List<Map<String, dynamic>> _servicosNaOrdem = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _servicosExibidos {
    final query = _searchController.text.toLowerCase();
    return _servicosNaOrdem.where((servico) {
      final bool naoRemovido = servico['removido'] == false;
      final bool atendeFiltro =
          servico['nome'].toString().toLowerCase().contains(query) ||
          servico['descricao'].toString().toLowerCase().contains(query);
      return naoRemovido && atendeFiltro;
    }).toList();
  }

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

  void _adicionarServico(Map<String, dynamic> servico) {
    setState(() {
      _servicosNaOrdem.add({
        'id': '${servico['id']}_${DateTime.now().millisecondsSinceEpoch}',
        'nome': servico['nome'],
        'descricao': servico['descricao'],
        'preco': servico['preco'],
        'removido': false,
      });
    });
  }

  Future<void> _deletarServico(Map<String, dynamic> servico) async {
    setState(() {
      servico['removido'] = true;
    });
  }

  void _abrirListaServicos() {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
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
                      color: colors.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selecionar serviço',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: colors.primary, size: 26),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StandInPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _servicosDisponiveis.length,
                    itemBuilder: (context, index) {
                      final servico = _servicosDisponiveis[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.build_outlined,
                          color: colors.primary,
                        ),
                        title: Text(
                          servico['nome'],
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'R\$ ${(servico['preco'] as double).toStringAsFixed(2).replaceAll('.', ',')}',
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: colors.onSurfaceVariant,
                        ),
                        onTap: () {
                          _adicionarServico(servico);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                        child: Text('Nenhum serviço adicionado.'),
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
            onPressed: _abrirListaServicos,
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