
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/fire_base/models/os.dart';

class ValuesOs extends StatefulWidget {
  final ServiceOrder serviceOrder;
  final VoidCallback? onConcluir;

  const ValuesOs({
    super.key,
    required this.serviceOrder,
    this.onConcluir,
  });

  @override
  State<ValuesOs> createState() => _ValuesOsState();
}

class _ValuesOsState extends State<ValuesOs>
    with AutomaticKeepAliveClientMixin {
  final colors = custom_colors.colorScheme;

  late final TextEditingController _taxaController;
  late final TextEditingController _descontoController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _taxaController = TextEditingController(
      text: _formatarInput(widget.serviceOrder.globalFeeCents),
    );

    _descontoController = TextEditingController(
      text: _formatarInput(widget.serviceOrder.globalDiscountCents),
    );
  }

  @override
  void dispose() {
    _taxaController.dispose();
    _descontoController.dispose();
    super.dispose();
  }

  String _formatarInput(int centavos) {
    return (centavos / 100).toStringAsFixed(2).replaceAll('.', ',');
  }

  int _converterParaCentavos(String valor) {
    final numeros = valor.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.isEmpty) return 0;

    return int.parse(numeros);
  }

  int get _subtotalPecas {
    return widget.serviceOrder.parts.fold<int>(
      0,
      (total, peca) => total + peca.subtotalCents,
    );
  }

  int get _subtotalServicos {
    return widget.serviceOrder.services.fold<int>(
      0,
      (total, servico) => total + servico.subtotalCents,
    );
  }

  int get _taxas => widget.serviceOrder.globalFeeCents;

  int get _desconto => widget.serviceOrder.globalDiscountCents;

  int get _total {
    return _subtotalPecas + _subtotalServicos + _taxas - _desconto;
  }

  void _atualizarTaxa(String valor) {
    setState(() {
      widget.serviceOrder.globalFeeCents =
          _converterParaCentavos(valor);
    });
  }

  void _atualizarDesconto(String valor) {
    setState(() {
      widget.serviceOrder.globalDiscountCents =
          _converterParaCentavos(valor);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final subtotalPecas = _subtotalPecas;
    final subtotalServicos = _subtotalServicos;
    final taxas = _taxas;
    final desconto = _desconto;
    final total = _total;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Card(
            color: Colors.white,
            elevation: 8,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'Resumo da ordem de serviço',
                    'Confira os valores das peças, serviços e ajustes.',
                  ),

                  const SizedBox(height: 18),

                  _buildSummarySection(
                    icon: Icons.build,
                    title: 'Peças',
                    value: subtotalPecas,
                    children: widget.serviceOrder.parts.map((peca) {
                      return _buildItem(
                        name: '${peca.name} (${peca.quantity}x)',
                        value: peca.subtotalCents,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  _buildSummarySection(
                    icon: Icons.handyman,
                    title: 'Serviços',
                    value: subtotalServicos,
                    children: widget.serviceOrder.services.map((servico) {
                      return _buildItem(
                        name: servico.description,
                        value: servico.subtotalCents,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  _buildInputValor(
                    titulo: 'Taxas',
                    controller: _taxaController,
                    onChanged: _atualizarTaxa,
                    cor: Colors.green.shade700,
                    icone: Icons.add,
                  ),

                  const SizedBox(height: 12),

                  _buildInputValor(
                    titulo: 'Desconto global',
                    controller: _descontoController,
                    onChanged: _atualizarDesconto,
                    cor: Colors.redAccent.shade400,
                    icone: Icons.remove,
                  ),

                  const SizedBox(height: 20),

                  Divider(
                    color: colors.outline,
                    thickness: 1.2,
                  ),

                  const SizedBox(height: 12),

                  _buildTotalCard(total),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: widget.onConcluir,
                      icon: const Icon(Icons.check),
                      label: const Text(
                        'Concluir ordem de serviço e voltar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      total < 0
                          ? 'O total não pode ser negativo.'
                          : 'Confira os valores antes de concluir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: total < 0
                            ? colors.error
                            : Colors.blueGrey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection({
    required IconData icon,
    required String title,
    required int value,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colors.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.secondary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                Dinheiro(value).formatado(),
                style: TextStyle(
                  color: colors.secondary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (children.isEmpty)
            Text(
              'Nenhum item adicionado.',
              style: TextStyle(color: colors.onSurfaceVariant),
            )
          else
            ...children,
        ],
      ),
    );
  }

  Widget _buildItem({
    required String name,
    required int value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 3,
      ),
      child: Row(
        children: [
          Icon(
            Icons.chevron_right,
            size: 18,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            Dinheiro(value).formatado(),
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputValor({
    required String titulo,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required Color cor,
    required IconData icone,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cor.withOpacity(0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(icone, color: cor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                color: cor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9,.]'),
                ),
              ],
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                prefixText: 'R\$ ',
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.payments_outlined,
              color: colors.onSecondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  'Valor final da ordem de serviço',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Dinheiro(total).formatado(),
            style: TextStyle(
              color: total < 0 ? colors.error : colors.secondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
