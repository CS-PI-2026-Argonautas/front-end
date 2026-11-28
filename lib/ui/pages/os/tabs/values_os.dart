import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';

class ItemResumoOs {
  final String nome;
  final Dinheiro valorUnitario;
  final int quantidade;

  const ItemResumoOs({
    required this.nome,
    required this.valorUnitario,
    this.quantidade = 1,
  });

  Dinheiro get total => valorUnitario * quantidade;
}

class OsValoresController extends ChangeNotifier {
  List<ItemResumoOs> _pecas = const [];
  List<ItemResumoOs> _servicos = const [];
  Dinheiro _desconto = Dinheiro.zero;
  Dinheiro _taxas = Dinheiro.zero;

  List<ItemResumoOs> get pecas => _pecas;
  List<ItemResumoOs> get servicos => _servicos;
  Dinheiro get desconto => _desconto;
  Dinheiro get taxas => _taxas;

  int get quantidadeItens => _pecas.length + _servicos.length;

  Dinheiro get subtotalPecas => _somar(_pecas);
  Dinheiro get subtotalServicos => _somar(_servicos);

  
  Dinheiro get valorBruto => subtotalPecas + subtotalServicos + _taxas;


  Dinheiro get descontoMaximo => valorBruto;


  bool get descontoExcedeTotal => _desconto.centavos > valorBruto.centavos;

  Dinheiro get total => valorBruto - _desconto;

  void definirPecas(List<ItemResumoOs> itens) {
    _pecas = List.unmodifiable(itens);
    notifyListeners();
  }

  void definirServicos(List<ItemResumoOs> itens) {
    _servicos = List.unmodifiable(itens);
    notifyListeners();
  }

  void definirDesconto(Dinheiro valor) {
    _desconto = valor;
    notifyListeners();
  }

  void definirTaxas(Dinheiro valor) {
    _taxas = valor;
    notifyListeners();
  }

  static Dinheiro _somar(List<ItemResumoOs> itens) {
    var soma = Dinheiro.zero;
    for (final item in itens) {
      soma = soma + item.total;
    }
    return soma;
  }
}

class ValuesOs extends StatelessWidget {
  final OsValoresController valores;
  final bool concluida;
  final VoidCallback? onConcluir;

  const ValuesOs({
    super.key,
    required this.valores,
    this.concluida = false,
    this.onConcluir,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: valores,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: _buildFormCard(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormCard(BuildContext context) {
    final colors = custom_colors.colorScheme;
    final excedeu = valores.descontoExcedeTotal;

    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          spacing: 18,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'Resumo da ordem de serviço',
              'Confira os valores das peças, serviços e ajustes da ordem de serviço.',
            ),

            _buildSummarySection(
              icon: Icons.build,
              title: 'Peças',
              value: valores.subtotalPecas,
              itens: valores.pecas,
              textoVazio: 'Nenhuma peça adicionada.',
            ),

            _buildSummarySection(
              icon: Icons.handyman,
              title: 'Serviços',
              value: valores.subtotalServicos,
              itens: valores.servicos,
              textoVazio: 'Nenhum serviço adicionado.',
            ),

            _buildValueRow(
              icon: Icons.remove,
              title: 'Descontos',
              value: valores.desconto,
              prefixo: '- ',
              color: Colors.redAccent.shade400,
              editavel: !concluida,
              onTap: () => _editarDesconto(context),
            ),

            if (excedeu)
              _buildAviso(
                'O desconto é maior que o valor da OS. '
                'Reduza o desconto para poder concluir.',
              ),

            _buildValueRow(
              icon: Icons.add,
              title: 'Taxas',
              value: valores.taxas,
              prefixo: '+ ',
              color: Colors.green.shade400,
              editavel: !concluida,
              onTap: () => _editarTaxas(context),
            ),

            Divider(color: colors.outline, thickness: 1.2, height: 1),

            _buildTotalCard(total: valores.total),

            const SizedBox(height: 4),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (concluida || excedeu)
                    ? null
                    : () => _confirmarConclusao(context),
                icon: Icon(concluida ? Icons.check_circle : Icons.check),
                label: Text(
                  concluida
                      ? 'Ordem de serviço concluída'
                      : 'Concluir ordem de serviço',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: concluida ? 0 : 3,
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onSecondary,
                  disabledBackgroundColor: colors.surfaceContainerLow,
                  disabledForegroundColor: colors.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            Center(
              child: Text(
                concluida
                    ? 'Esta OS já foi concluída.'
                    : 'Confira os valores antes de concluir a ordem de serviço.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── ações ─────────────────────────

  Future<void> _editarDesconto(BuildContext context) async {
    final novo = await showDialog<Dinheiro>(
      context: context,
      builder: (_) => _AjusteDialog(
        titulo: 'Desconto',
        inicial: valores.desconto,
        validar: (valor) {
          final maximo = valores.descontoMaximo;
          if (valor.centavos > maximo.centavos) {
            return 'O desconto não pode passar de ${maximo.formatado()}.';
          }
          return null;
        },
      ),
    );

    if (novo != null) valores.definirDesconto(novo);
  }

  Future<void> _editarTaxas(BuildContext context) async {
    final novo = await showDialog<Dinheiro>(
      context: context,
      builder: (_) => _AjusteDialog(titulo: 'Taxas', inicial: valores.taxas),
    );

    if (novo != null) valores.definirTaxas(novo);
  }

  Future<void> _confirmarConclusao(BuildContext context) async {
    final colors = custom_colors.colorScheme;
    final semItens = valores.quantidadeItens == 0;
    final messenger = ScaffoldMessenger.of(context);

    final confirmou =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Concluir ordem de serviço?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text('Valor total: ${valores.total.formatado()}'),
                if (semItens)
                  Text(
                    'Nenhuma peça ou serviço foi adicionado a esta OS.',
                    style: TextStyle(color: Colors.orange.shade800),
                  ),
                const Text(
                  'Depois de concluída, o status da OS não poderá ser alterado.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('CANCELAR'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text('CONCLUIR', style: TextStyle(color: colors.primary)),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmou) return;

    onConcluir?.call();

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Ordem de serviço concluída.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ───────────────────────── widgets ─────────────────────────

  Widget _buildSectionTitle(String title, String subtitle) {
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
          style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildSummarySection({
    required IconData icon,
    required String title,
    required Dinheiro value,
    required List<ItemResumoOs> itens,
    required String textoVazio,
  }) {
    final colors = custom_colors.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        spacing: 8,
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
                value.formatado(),
                style: TextStyle(
                  color: colors.secondary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (itens.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  textoVazio,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ...itens.map(_buildItem),
        ],
      ),
    );
  }

  Widget _buildItem(ItemResumoOs item) {
    final colors = custom_colors.colorScheme;
    final nome = item.quantidade > 1
        ? '${item.quantidade}× ${item.nome}'
        : item.nome;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          Icon(Icons.chevron_right, size: 18, color: colors.onSurfaceVariant),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              nome,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
            ),
          ),
          Text(
            item.total.formatado(),
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildValueRow({
    required IconData icon,
    required String title,
    required Dinheiro value,
    required String prefixo,
    required Color color,
    required bool editavel,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.09),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: editavel ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
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
                '${value.centavos == 0 ? '' : prefixo}${value.formatado()}',
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (editavel) ...[
                const SizedBox(width: 8),
                Icon(Icons.edit_outlined, size: 18, color: color),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAviso(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(fontSize: 13, color: Colors.red.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard({required Dinheiro total}) {
    final colors = custom_colors.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
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
                const SizedBox(height: 2),
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
            total.formatado(),
            style: TextStyle(
              color: colors.secondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Diálogo para digitar um valor em reais (desconto ou taxas).
class _AjusteDialog extends StatefulWidget {
  final String titulo;
  final Dinheiro inicial;
  final String? Function(Dinheiro valor)? validar;

  const _AjusteDialog({
    required this.titulo,
    required this.inicial,
    this.validar,
  });

  @override
  State<_AjusteDialog> createState() => _AjusteDialogState();
}

class _AjusteDialogState extends State<_AjusteDialog> {
  late final TextEditingController _controller;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.inicial.centavos == 0
          ? ''
          : widget.inicial.toReais().toStringAsFixed(2).replaceAll('.', ','),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _salvar() {
    final valor = Dinheiro.fromTexto(_controller.text);
    final erro = widget.validar?.call(valor);

    if (erro != null) {
      setState(() => _erro = erro);
      return;
    }

    Navigator.pop(context, valor);
  }

  @override
  Widget build(BuildContext context) {
    final colors = custom_colors.colorScheme;

    return AlertDialog(
      title: Text(widget.titulo),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*,?\d{0,2}')),
        ],
        decoration: customInputDecoration(
          hintText: '0,00',
        ).copyWith(prefixText: 'R\$ ', errorText: _erro),
        onChanged: (_) {
          if (_erro != null) setState(() => _erro = null);
        },
        onSubmitted: (_) => _salvar(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCELAR'),
        ),
        TextButton(
          onPressed: _salvar,
          child: Text('SALVAR', style: TextStyle(color: colors.primary)),
        ),
      ],
    );
  }
}