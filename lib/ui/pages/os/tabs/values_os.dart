import 'package:flutter/material.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;

class ValuesOs extends StatefulWidget {
  const ValuesOs({super.key});

  @override
  State<ValuesOs> createState() => _ValuesOsState();
}

class _ValuesOsState extends State<ValuesOs> {

  @override
  Widget build(BuildContext context) {

    final colors = custom_colors.colorScheme;

    const double subtotalPecas = 100.00;
    const double subtotalServicos = 100.00;
    const double desconto = 0.00;
    const double taxas = 0.00;

    final double total =
        subtotalPecas + subtotalServicos + taxas - desconto;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 650,
          ),
          child: _buildFormCard(
            subtotalPecas: subtotalPecas,
            subtotalServicos: subtotalServicos,
            desconto: desconto,
            taxas: taxas,
            total: total,
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard({
    required double subtotalPecas,
    required double subtotalServicos,
    required double desconto,
    required double taxas,
    required double total,
  }) {
    final colors = custom_colors.colorScheme;
    return Card(
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
          spacing: 18,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'Resumo da OS',
              'Confira os valores das peças, serviços e ajustes da ordem de serviço.',
            ),

            _buildSummarySection(
              icon: Icons.build_outlined,
              title: 'Peças',
              value: subtotalPecas,
              children: [
                _buildItem(
                  name: 'Peça',
                  value: 50.00,
                ),
                _buildItem(
                  name: 'Peça',
                  value: 50.00,
                ),
              ],
            ),

            _buildSummarySection(
              icon: Icons.handyman_outlined,
              title: 'Serviços',
              value: subtotalServicos,
              children: [
                _buildItem(
                  name: 'Serviço',
                  value: 50.00,
                ),
                _buildItem(
                  name: 'Serviço',
                  value: 50.00,
                ),
              ],
            ),

            _buildValueRow(
              icon: Icons.remove_circle_outline,
              title: 'Descontos',
              value: desconto,
              color: Colors.redAccent,
            ),

            _buildValueRow(
              icon: Icons.add_circle_outline,
              title: 'Taxas',
              value: taxas,
              color: Colors.green,
            ),

            Divider(
              color: colors.outline,
              thickness: 1.2,
              height: 1,
            ),

            _buildTotalCard(
              total: total,
            ),

            const SizedBox(height: 4),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.check_circle_outline,
                ),
                label: const Text(
                  'Concluir OS e voltar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onSecondary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            Center(
              child: Text(
                'Confira os valores antes de concluir a OS.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    final colors = custom_colors.colorScheme;
    return Column(
      spacing: 6,
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
    required double value,
    required List<Widget> children,
  }) {
    final colors = custom_colors.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withOpacity(0.18),
        ),
      ),
      child: Column(
        spacing: 8,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: colors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                _formatMoney(value),
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Divider(
            color: colors.outline.withOpacity(0.5),
            height: 1,
          ),

          ...children,
        ],
      ),
    );
  }

  Widget _buildItem({
    required String name,
    required double value,
  }) {
    final colors = custom_colors.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      child: Row(
        children: [
          Icon(
            Icons.chevron_right,
            size: 18,
            color: colors.onSurface,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            _formatMoney(value),
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueRow({
    required IconData icon,
    required String title,
    required double value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            _formatMoney(value),
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard({
    required double total,
  }) {
    final colors = custom_colors.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.primary.withOpacity(0.25),
        ),
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
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Valor final da OS',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          Text(
            _formatMoney(total),
            style: TextStyle(
              color: colors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMoney(double value) {
    return 'R\$${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}





















// ESTUDAR ChangeNotifier E Provider

// class OrdemServicoController extends ChangeNotifier {
//   final OrdemServico os;

//   OrdemServicoController(this.os);

//   double get totalPecas {
//     return os.pecas.fold(
//       0,
//       (total, peca) => total + peca.valor,
//     );
//   }

//   double get totalServicos {
//     return os.servicos.fold(
//       0,
//       (total, servico) => total + servico.valor,
//     );
//   }

//   double get subtotal {
//     return totalPecas + totalServicos;
//   }

//   double get total {
//     return subtotal + os.taxas - os.desconto;
//   }

//   bool get descontoInvalido {
//     return total < 0;
//   }

//   void setDesconto(double valor) {
//     os.desconto = valor;
//     notifyListeners();
//   }

//   void setTaxas(double valor) {
//     os.taxas = valor;
//     notifyListeners();
//   }

//   void adicionarPeca(Peca peca) {
//     os.pecas.add(peca);
//     notifyListeners();
//   }

//   void adicionarServico(Servico servico) {
//     os.servicos.add(servico);
//     notifyListeners();
//   }

//   void concluir() {
//     os.status = StatusOS.concluida;
//     notifyListeners();
//   }
// }








// class ValoresTab extends StatelessWidget {
//   const ValoresTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final os = context.watch<OrdemServicoController>();

//     return Column(
//       children: [
//         Text('Peças: R\$ ${os.totalPecas}'),

//         Text('Serviços: R\$ ${os.totalServicos}'),

//         Text('Total: R\$ ${os.total}'),
//       ],
//     );
//   }
// }