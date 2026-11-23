import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/floatingButton.dart';
import 'package:frontend/ui/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:frontend/ui/pages/os/tabs/service_registration.dart';
import 'package:frontend/fire_base/services/service_service.dart';
import 'package:frontend/fire_base/models/service.dart';

class OsServicosTab extends StatefulWidget {
  const OsServicosTab({super.key});

  @override
  State<OsServicosTab> createState() => _OsServicosTabState();
}

class _OsServicosTabState extends State<OsServicosTab> {
  final colors = custom_colors.colorScheme;
  final ServicoService _servicoService = ServicoService();

  // 'valueInCents' é SEMPRE int em centavos (nunca reais/double).
  List<Map<String, dynamic>> _servicosDisponiveis = [];
  bool _carregandoServicos = true;

  final List<Map<String, dynamic>> _servicosNaOrdem = [];

  @override
  void initState() {
    super.initState();
    _carregarServicosDoBanco();
  }

  Future<void> _carregarServicosDoBanco() async {
    try {
      final servicosDoFirebase =
          await _servicoService.buscarServicosDisponiveis();

      final servicosFormatados = servicosDoFirebase.map((servico) {
        return {
          'id': servico.id ?? 'sem_id_${DateTime.now().millisecondsSinceEpoch}',
          'nome': servico.name,
          'descricao': servico.description,
          'valueInCents': servico.valueInCents,
        };
      }).toList();

      if (mounted) {
        setState(() {
          _servicosDisponiveis = servicosFormatados;
          _carregandoServicos = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _carregandoServicos = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar serviços: $e')),
        );
      }
    }
  }

  List<Map<String, dynamic>> get _servicosExibidos =>
      _servicosNaOrdem.where((s) => s['removido'] == false).toList();

  /// "R$12,34" (sem espaço), igual ao formato da aba "Peças".
  String _formatar(int centavos) => Dinheiro(centavos)
      .formatado()
      .replaceAll(RegExp(r'[\s\u00A0]'), '');

  Dinheiro get _subtotal {
    var total = Dinheiro.zero;
    for (final item in _servicosExibidos) {
      total = total + Dinheiro(item['valueInCents'] as int? ?? 0);
    }
    return total;
  }

  void _adicionarServico(Map<String, dynamic> servico) {
    setState(() {
      _servicosNaOrdem.add({
        'id': '${servico['id']}_${DateTime.now().millisecondsSinceEpoch}',
        'servicoId': servico['id'],
        'nome': servico['nome'],
        'descricao': servico['descricao'],
        'valueInCents': servico['valueInCents'],
        'removido': false,
      });
    });
  }

  Future<void> _deletarServico(Map<String, dynamic> servico) async {
    setState(() {
      servico['removido'] = true;
    });
  }

  Future<void> _atualizarServico(Service atualizado) async {
    // ATENÇÃO: ajuste o nome do método se o ServicoService usar outro.
    await _servicoService.atualizarServico(atualizado);

    if (!mounted) return;

    setState(() {
      for (final s in _servicosNaOrdem) {
        if (s['servicoId'] == atualizado.id) {
          s['nome'] = atualizado.name;
          s['descricao'] = atualizado.description;
          s['valueInCents'] = atualizado.valueInCents;
        }
      }
    });

    await _carregarServicosDoBanco();
  }

  Future<void> _abrirEdicao(Map<String, dynamic> servico) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditServiceSheet(
        servico: servico,
        onSave: _atualizarServico,
      ),
    );
  }

  void _abrirListaServicos() {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        // StatefulBuilder + reload: o sheet fica aberto durante o cadastro e
        // a lista é atualizada assim que o usuário volta.
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SelectionBottomSheet<Map<String, dynamic>>(
              title: 'Selecionar serviço',
              items: _servicosDisponiveis,
              searchText: 'Procurar serviço',
              actionText: 'Novo serviço',
              itemTitle: (servico) => servico['nome'].toString(),
              itemSubtitle: (servico) =>
                  _formatar(servico['valueInCents'] as int? ?? 0),
              itemIcon: Icons.build,
              loading: _carregandoServicos,
              onEdit: (servico) async {
                await _abrirEdicao(servico);
                setSheetState(() {});
              },
              onAction: () async {
                await Navigator.push(
                  sheetContext,
                  MaterialPageRoute(
                    builder: (_) => const ServiceRegistration(),
                  ),
                );

                if (!mounted) return;

                await _carregarServicosDoBanco();
                if (sheetContext.mounted) setSheetState(() {});
              },
              onSelect: (servico) {
                _adicionarServico(servico);
                Navigator.pop(sheetContext);
              },
            );
          },
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
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 90),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                // Card externo: mesmo estilo do card da aba "Dados".
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal de serviços',
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatar(_subtotal.centavos),
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (listaAtual.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  'Nenhum serviço adicionado',
                                  style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: listaAtual.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) =>
                                  _buildServiceCard(listaAtual[index]),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: CustomFloatingButton(onPressed: _abrirListaServicos),
        ),
      ],
    );
  }

  Future<void> _confirmarRemocao(Map<String, dynamic> servico) async {
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
            setState(() => servico['removido'] = false);
            messenger.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Card no mesmo estilo dos itens da aba "Peças".
  Widget _buildServiceCard(Map<String, dynamic> servico) {
    final int preco = servico['valueInCents'] as int? ?? 0;
    final String descricao = servico['descricao'] ?? '';

    return Slidable(
      key: ValueKey(servico['id']),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (_) => _confirmarRemocao(servico),
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            borderRadius: BorderRadius.circular(18),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              servico['nome'] as String,
              style: TextStyle(
                color: Colors.blueGrey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (descricao.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                descricao,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 2),
            Text(
              _formatar(preco),
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet de edição de serviço (mesmo padrão da edição de peças).
class _EditServiceSheet extends StatefulWidget {
  final Map<String, dynamic> servico;
  final Future<void> Function(Service atualizado) onSave;

  const _EditServiceSheet({required this.servico, required this.onSave});

  @override
  State<_EditServiceSheet> createState() => _EditServiceSheetState();
}

class _EditServiceSheetState extends State<_EditServiceSheet> {
  final colors = custom_colors.colorScheme;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _valorController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.servico;
    _nomeController = TextEditingController(text: s['nome']?.toString() ?? '');
    _descricaoController =
        TextEditingController(text: s['descricao']?.toString() ?? '');
    final int cents = s['valueInCents'] as int? ?? 0;
    _valorController = TextEditingController(
      text: (cents / 100).toStringAsFixed(2).replaceAll('.', ','),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  /// "1.234,56" / "12,5" / "12" -> centavos. Retorna null se inválido.
  int? _parseCentavos(String texto) {
    final t = texto.trim().replaceAll('.', '').replaceAll(',', '.');
    final v = double.tryParse(t);
    if (v == null || v < 0) return null;
    return Dinheiro.fromReais(v).centavos;
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final atualizado = Service(
      id: widget.servico['servicoId'] ?? widget.servico['id'],
      name: _nomeController.text.trim(),
      description: _descricaoController.text.trim(),
      valueInCents: _parseCentavos(_valorController.text)!,
    );

    setState(() => _saving = true);

    try {
      await widget.onSave(atualizado);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Serviço atualizado com sucesso.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Erro ao atualizar serviço: $e');
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível atualizar o serviço.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: colors.onSurface,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 12,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    spacing: 6,
                    children: [
                      Icon(Icons.edit_outlined, color: colors.primary),
                      Text(
                        'Editar serviço',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _label('Nome'),
                  TextFormField(
                    controller: _nomeController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: customInputDecoration(hintText: 'Nome do serviço'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Informe o nome.'
                        : null,
                  ),
                  _label('Descrição'),
                  TextFormField(
                    controller: _descricaoController,
                    maxLength: 50,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: customInputDecoration(
                      hintText: 'Descrição (opcional)',
                    ).copyWith(
                      counterStyle: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ),
                  _label('Valor'),
                  TextFormField(
                    controller: _valorController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: customInputDecoration(hintText: '0,00')
                        .copyWith(prefixText: 'R\$ '),
                    validator: (v) => _parseCentavos(v ?? '') == null
                        ? 'Informe um valor válido.'
                        : null,
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: const Text(
                        'Salvar alterações',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onSecondary,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
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
}