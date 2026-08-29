import 'package:flutter/material.dart';
import 'package:frontend/style/ColorScheme.dart' as custom_colors;

class ValuesOs extends StatefulWidget{

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

    final double total = subtotalPecas + subtotalServicos + taxas - desconto;

    return Container(
      color: colors.surface,
      child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo:',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(
              title: 'Peças',
              value: subtotalPecas,
              colors: colors,
            ),

            const SizedBox(height: 4),

            _buildItem(
              name: 'Peça',
              value: 50.00,
              colors: colors,
            ),

            _buildItem(
              name: 'Peça',
              value: 50.00,
              colors: colors,
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(
              title: 'Serviços',
              value: subtotalServicos,
              colors: colors,
            ),

            const SizedBox(height: 4),

            _buildItem(
              name: 'Serviço',
              value: 50.00,
              colors: colors,
            ),

            _buildItem(
              name: 'Serviço',
              value: 50.00,
              colors: colors,
            ),

            const SizedBox(height: 24),

            _buildValueRow(
              title: 'Descontos',
              value: desconto,
              color: Colors.redAccent,
              colors: colors,
            ),

            const SizedBox(height: 14),

            _buildValueRow(
              title: 'Taxas',
              value: taxas,
              color: Colors.green,
              colors: colors,
            ),

            const SizedBox(height: 12),

            Divider(
              color: colors.outline,
              thickness: 1.5,
              height: 1,
            ),

            const SizedBox(height: 12),

            _buildTotalRow(
              total: total,
              colors: colors,
            ),

            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Concluir OS e voltar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
    );
    
    
  }


  Widget _buildSectionHeader({
    required String title,
    required double value,
    required dynamic colors,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          _formatMoney(value),
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildItem({
    required String name,
    required double value,
    required dynamic colors,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 4,
      ),
      child: Row(
        children: [
          Text(
            '- $name',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 14,
            ),
          ),

          const Spacer(),

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
    required String title,
    required double value,
    required Color color,
    required dynamic colors,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),

        Text(
          _formatMoney(value),
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow({
    required double total,
    required dynamic colors,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TOTAL',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),

        Text(
          _formatMoney(total),
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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