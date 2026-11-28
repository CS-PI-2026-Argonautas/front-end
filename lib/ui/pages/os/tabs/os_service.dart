import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/models/service.dart';
import 'package:frontend/fire_base/services/service_service.dart';
import 'package:frontend/ui/pages/os/service_order_state.dart';
import 'package:frontend/ui/pages/service_registration/service_registration.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:frontend/utils/formatters/currency_input_formatter.dart';
import 'package:frontend/ui/widgets/floatingButton.dart';


class OsServicosTab extends StatefulWidget {
  final ServiceOrderState serviceOrderState;
  final VoidCallback? avancarTab;
  final VoidCallback? onChanged;

  const OsServicosTab({
    super.key,
    required this.serviceOrderState,
    this.avancarTab,
    this.onChanged,
  });

  @override
  State<OsServicosTab> createState() => _OsServicosTabState();
}

class _OsServicosTabState extends State<OsServicosTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final colors = custom_colors.colorScheme;

  final ServiceService _servicoService = ServiceService();

  Timer? _snackBarTimer;

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _servicosDisponiveis = [];

  bool _carregandoServicos = true;

  ServiceOrder get _os => widget.serviceOrderState.serviceOrder;

  void _editarOs(void Function(ServiceOrder) editar) {
    setState(() => widget.serviceOrderState.applyUserEdit(editar));
  }

  List<ServiceOrderService> get _servicosExibidos {
    final query = _searchController.text.toLowerCase().trim();

    return _os.services.where((servico) {
      return servico.description.toLowerCase().contains(query) ||
          servico.name.toLowerCase().contains(query);
    }).toList();
  }

  int get _subtotal {
    return _os.services.fold<int>(
      0,
      (total, servico) => total + servico.subtotalCents,
    );
  }

  @override
  void initState() {
    super.initState();
    _carregarServicosDoBanco();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _snackBarTimer?.cancel();
    super.dispose();
  }

  Future<void> _carregarServicosDoBanco() async {
    try {
      final servicosDoFirebase = await _servicoService.watchServices().first;

      final servicosFormatados = servicosDoFirebase
          .where((servico) => servico.id != null)
          .map((servico) {
            return {
              'id': servico.id,
              'servicoId': servico.id,
              'nome': servico.name,
              'descricao': servico.description,
              'valueInCents': servico.valueInCents,
            };
          })
          .toList();

      if (!mounted) return;

      setState(() {
        _servicosDisponiveis = servicosFormatados;
        _carregandoServicos = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar serviços: $e');

      if (!mounted) return;

      setState(() {
        _carregandoServicos = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar serviços: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatar(int centavos) {
    return Dinheiro(centavos).formatado().replaceAll(RegExp(r'[\s\u00A0]'), '');
  }

  void _adicionarServico(Map<String, dynamic> servico) {
    final preco = servico['valueInCents'];

    if (preco is! num) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível adicionar o serviço: preço inválido.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final serviceId =
        servico['servicoId']?.toString() ?? servico['id']?.toString();

    if (serviceId == null || serviceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Serviço sem identificador válido.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final nome = servico['nome']?.toString() ?? '';
    final descricao = servico['descricao']?.toString().trim() ?? '';

    _editarOs((os) {
      os.services.add(
        ServiceOrderService(
          serviceId: serviceId,
          name: nome,
          description: descricao.isNotEmpty ? descricao : nome,
          valueCents: preco.toInt(),
        ),
      );
    });

    widget.onChanged?.call();
  }

  void _removerServico(ServiceOrderService servico) {
    final indiceOriginal = _os.services.indexOf(servico);

    if (indiceOriginal == -1) return;

    _editarOs((os) => os.services.removeAt(indiceOriginal));

    widget.onChanged?.call();

    final messenger = ScaffoldMessenger.of(context);

    _snackBarTimer?.cancel();
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text('${servico.name} removido.'),
        backgroundColor: colors.primary,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        action: SnackBarAction(
          label: 'DESFAZER',
          textColor: Colors.white,
          onPressed: () {
            _snackBarTimer?.cancel();
            if (!mounted) return;

            _editarOs((os) {
              os.services.insert(
                indiceOriginal.clamp(0, os.services.length),
                servico,
              );
            });

            widget.onChanged?.call();
          },
        ),
      ),
    );

    _snackBarTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        messenger.hideCurrentSnackBar();
      }
    });
  }

  Future<void> _confirmarRemocao(ServiceOrderService servico) async {
    final confirmar =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Remover Serviço'),
              content: Text('Deseja remover "${servico.name}" da OS?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('CANCELAR'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                  },
                  child: Text('REMOVER', style: TextStyle(color: colors.error)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmar || !mounted) return;

    _removerServico(servico);
  }

  Future<void> _atualizarServico(Service atualizado) async {
    await _servicoService.update(atualizado);

    if (!mounted) return;

    setState(() {
      for (final servico in _servicosDisponiveis) {
        if (servico['servicoId']?.toString() == atualizado.id?.toString()) {
          servico['nome'] = atualizado.name;
          servico['descricao'] = atualizado.description;
          servico['valueInCents'] = atualizado.valueInCents;
        }
      }
    });

    _editarOs((os) {
      for (int i = 0; i < os.services.length; i++) {
        final servicoOS = os.services[i];

        if (servicoOS.serviceId == atualizado.id) {
          final descricao = atualizado.description.trim().isNotEmpty
              ? atualizado.description
              : atualizado.name;

          os.services[i] = ServiceOrderService(
            serviceId: servicoOS.serviceId,
            name: atualizado.name,
            description: descricao,
            valueCents: atualizado.valueInCents,
            discountCents: servicoOS.discountCents,
          );
        }
      }
    });

    widget.onChanged?.call();

    await _carregarServicosDoBanco();
  }

  Future<void> _abrirEdicao(Map<String, dynamic> servico) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _EditServiceSheet(servico: servico, onSave: _atualizarServico),
    );
  }

  Future<void> _abrirListaServicos() async {
    if (_carregandoServicos) {
      await _carregarServicosDoBanco();
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SelectionBottomSheet<Map<String, dynamic>>(
              title: 'Selecionar serviço',
              items: _servicosDisponiveis,
              searchText: 'Procurar serviço',
              actionText: 'Novo serviço',
              itemTitle: (servico) {
                return servico['nome'].toString();
              },
              itemSubtitle: (servico) {
                final valor = servico['valueInCents'];
                return _formatar(valor is num ? valor.toInt() : 0);
              },
              itemIcon: Icons.handyman,
              loading: _carregandoServicos,
              onEdit: (servico) async {
                await _abrirEdicao(servico);

                if (sheetContext.mounted) {
                  setSheetState(() {});
                }
              },
              onAction: () async {
                Navigator.pop(sheetContext);

                final dadosNovos = await Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ServiceRegistration(abertoPelaOS: true),
                  ),
                );

                if (!mounted) return;

                if (dadosNovos != null) {
                  final idNovo = dadosNovos is Map
                      ? dadosNovos['id']?.toString()
                      : null;

                  if (idNovo == null || idNovo.isEmpty) {
                    _mostrarMensagem(
                      'O cadastro não retornou o identificador do serviço.',
                    );
                  } else {
                    await _carregarServicosDoBanco();

                    if (!mounted) return;

                    final novoServico = _servicosDisponiveis
                        .where(
                          (servico) =>
                              servico['servicoId']?.toString() == idNovo,
                        )
                        .firstOrNull;

                    if (novoServico != null) {
                      _adicionarServico(novoServico);
                    } else {
                      _mostrarMensagem(
                        'O serviço foi cadastrado, mas não foi encontrado na lista.',
                      );
                    }
                  }
                } else {
                  await _carregarServicosDoBanco();
                }
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

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final listaAtual = _servicosExibidos;

    return Scaffold(
      backgroundColor: colors.surface,
      floatingActionButton: CustomFloatingButton(
  onPressed: _abrirListaServicos,
  icon: Icons.add,
  tooltip: 'Adicionar serviço',
),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 90),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.handyman, color: colors.secondary),
                                const SizedBox(width: 8),
                                Text(
                                  'Subtotal de serviços',
                                  style: TextStyle(
                                    color: colors.onSurface,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              _formatar(_subtotal),
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Selecione os serviços prestados nesta Ordem de Serviço.',
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (listaAtual.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'Nenhum serviço adicionado.',
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
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 12);
                            },
                            itemBuilder: (context, index) {
                              return _buildServiceCard(
                                listaAtual[index],
                                index,
                              );
                            },
                          ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                _os.services.isNotEmpty &&
                                    widget.avancarTab != null
                                ? widget.avancarTab
                                : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text(
                              'Próximo: Valores',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: _os.services.isNotEmpty ? 3 : 0,
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onSecondary,
                              disabledBackgroundColor:
                                  colors.surfaceContainerLow,
                              disabledForegroundColor:
                                  colors.onSurfaceVariant,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Informe os serviços prestados para acessar o resumo da Ordem de Serviço.',
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceOrderService servico, int index) {
    final preco = servico.subtotalCents < 0 ? 0 : servico.subtotalCents;

    return Slidable(
      key: ValueKey('${servico.serviceId}_$index'),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (_) {
              _confirmarRemocao(servico);
            },
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
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          servico.name,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _confirmarRemocao(servico),
                        tooltip: 'Remover serviço',
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.delete_outline,
                          color: colors.error,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  if (servico.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      servico.description,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    _formatar(preco),
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

    final servico = widget.servico;

    _nomeController = TextEditingController(
      text: servico['nome']?.toString() ?? '',
    );

    _descricaoController = TextEditingController(
      text: servico['descricao']?.toString() ?? '',
    );

    final centavos = servico['valueInCents'] is num
        ? (servico['valueInCents'] as num).toInt()
        : 0;

    final valorFormatado = Dinheiro(
      centavos,
    ).formatado().replaceFirst('R\$', '').trim();

    _valorController = TextEditingController(text: valorFormatado);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  int _parseCentavos(String texto) {
    return Dinheiro.fromTexto(texto).centavos;
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) {
      return;
    }

    final valorEmCentavos = _parseCentavos(_valorController.text);

    if (valorEmCentavos <= 0) return;

    final id =
        widget.servico['servicoId']?.toString() ??
        widget.servico['id']?.toString();

    if (id == null || id.isEmpty) {
      _mostrarErro('Serviço sem identificador válido.');
      return;
    }

    final atualizado = Service(
      id: id,
      name: _nomeController.text.trim(),
      description: _descricaoController.text.trim(),
      valueInCents: valorEmCentavos,
    );

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _saving = true;
    });

    try {
      await widget.onSave(atualizado);

      if (!mounted) return;

      navigator.pop();

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Serviço atualizado com sucesso.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Erro ao atualizar serviço: $e');

      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível atualizar o serviço.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), behavior: SnackBarBehavior.floating),
    );
  }

  Widget _label(String texto) {
    return Text(
      texto,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: colors.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
                    decoration: customInputDecoration(
                      hintText: 'Nome do serviço',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o nome.';
                      }

                      return null;
                    },
                  ),
                  _label('Descrição'),
                  TextFormField(
                    controller: _descricaoController,
                    maxLength: 50,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        customInputDecoration(
                          hintText: 'Descrição (opcional)',
                        ).copyWith(
                          counterStyle: TextStyle(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                  ),
                  _label('Valor'),
                  TextFormField(
                    controller: _valorController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: customInputDecoration(
                      hintText: '0,00',
                    ).copyWith(prefixText: 'R\$ '),
                    validator: (value) {
                      final valor = _parseCentavos(value ?? '');

                      if (valor <= 0) {
                        return 'O valor deve ser maior que zero.';
                      }

                      return null;
                    },
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