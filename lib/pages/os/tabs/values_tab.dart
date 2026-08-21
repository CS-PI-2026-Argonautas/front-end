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