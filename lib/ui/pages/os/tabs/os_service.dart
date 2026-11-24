
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/models/service.dart';
import 'package:frontend/fire_base/services/service_service.dart';

import 'package:frontend/ui/pages/os/tabs/service_registration.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/floatingButton.dart';
import 'package:frontend/ui/widgets/bottom_sheet/bottom_sheet.dart';

class OsServicosTab extends StatefulWidget {
  final ServiceOrder serviceOrder;

  const OsServicosTab({
    super.key,
    required this.serviceOrder,
  });

  @override
  State<OsServicosTab> createState() => _OsServicosTabState();
}

class _OsServicosTabState extends State<OsServicosTab> {
  final colors = custom_colors.colorScheme;

  final ServicoService _servicoService = ServicoService();

  final TextEditingController _searchController =
      TextEditingController();

  List<Map<String, dynamic>> _servicosDisponiveis = [];

  bool _carregandoServicos = true;

  @override
  void initState() {
    super.initState();
    _carregarServicosDoBanco();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  Future<void> _carregarServicosDoBanco() async {
    try {
      final servicosDoFirebase =
          await _servicoService.buscarServicosDisponiveis();

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
      }).toList();

      if (!mounted) return;

      setState(() {
        _servicosDisponiveis = servicosFormatados;
        _carregandoServicos = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _carregandoServicos = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar serviços: $e'),
        ),
      );
    }
  }
  List<ServiceOrderService> get _servicosExibidos {
    final query = _searchController.text.toLowerCase().trim();

    return widget.serviceOrder.services.where((servico) {
      return servico.description.toLowerCase().contains(query);
    }).toList();
  }

  int get _subtotal {
    return widget.serviceOrder.services.fold<int>(
      0,
      (total, servico) => total + servico.subtotalCents,
    );
  }

  String _formatar(int centavos) {
    return Dinheiro(centavos)
        .formatado()
        .replaceAll(RegExp(r'[\s\u00A0]'), '');
  }

  void _adicionarServico(Map<String, dynamic> servico) {
    final preco = servico['valueInCents'];

    if (preco is! num) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível adicionar o serviço: preço inválido.',
          ),
        ),
      );
      return;
    }

    final String? serviceId =
        servico['servicoId']?.toString() ??
        servico['id']?.toString();

    if (serviceId == null || serviceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Serviço sem identificador válido.'),
        ),
      );
      return;
    }

    final String nome = servico['nome']?.toString() ?? '';
    final String descricao =
        servico['descricao']?.toString().trim() ?? '';

    setState(() {
      widget.serviceOrder.services.add(
        ServiceOrderService(
          serviceId: serviceId,
          description: descricao.isNotEmpty ? descricao : nome,
          valueCents: preco.toInt(),
        ),
      );
    });
  }
  void _removerServico(ServiceOrderService servico) {
    final indiceOriginal =
        widget.serviceOrder.services.indexOf(servico);

    if (indiceOriginal == -1) return;

    setState(() {
      widget.serviceOrder.services.removeAt(indiceOriginal);
    });

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text('${servico.description} removido.'),
        backgroundColor: colors.primary,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'DESFAZER',
          textColor: Colors.white,
          onPressed: () {
            if (!mounted) return;

            setState(() {
              widget.serviceOrder.services.insert(
                indiceOriginal.clamp(
                  0,
                  widget.serviceOrder.services.length,
                ),
                servico,
              );
            });
          },
        ),
      ),
    );
  }

  Future<void> _confirmarRemocao(
    ServiceOrderService servico,
  ) async {
    final confirmar = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Remover Serviço'),
              content: Text(
                'Deseja remover "${servico.description}" da OS?',
              ),
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
                  child: Text(
                    'REMOVER',
                    style: TextStyle(
                      color: colors.error,
                    ),
                  ),
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
    await _servicoService.atualizarServico(atualizado);

    if (!mounted) return;

    setState(() {
      for (final servico in _servicosDisponiveis) {
        if (servico['servicoId']?.toString() ==
            atualizado.id?.toString()) {
          servico['nome'] = atualizado.name;
          servico['descricao'] = atualizado.description;
          servico['valueInCents'] = atualizado.valueInCents;
        }
      }

      for (int i = 0;
          i < widget.serviceOrder.services.length;
          i++) {
        final servicoOS = widget.serviceOrder.services[i];

        if (servicoOS.serviceId == atualizado.id) {
          final descricao =
              atualizado.description.trim().isNotEmpty
                  ? atualizado.description
                  : atualizado.name;

          widget.serviceOrder.services[i] =
              ServiceOrderService(
            serviceId: servicoOS.serviceId,
            description: descricao,
            valueCents: atualizado.valueInCents,
          );
        }
      }
    });

    await _carregarServicosDoBanco();
  }

  Future<void> _abrirEdicao(
    Map<String, dynamic> servico,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _EditServiceSheet(
          servico: servico,
          onSave: _atualizarServico,
        );
      },
    );
  }

  void _abrirListaServicos() {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
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
                return _formatar(
                  servico['valueInCents'] as int? ?? 0,
                );
              },

              itemIcon: Icons.build,
              loading: _carregandoServicos,

              onEdit: (servico) async {
                await _abrirEdicao(servico);

                if (sheetContext.mounted) {
                  setSheetState(() {});
                }
              },

              onAction: () async {
                Navigator.pop(sheetContext);

                final dadosNovos = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ServiceRegistration(),
                  ),
                );

                if (!mounted) return;

                if (dadosNovos != null) {
                  final novoServico = {
                    'id': dadosNovos['id']?.toString() ??
                        'novo_${DateTime.now().millisecondsSinceEpoch}',
                    'servicoId': dadosNovos['id']?.toString() ??
                        'novo_${DateTime.now().millisecondsSinceEpoch}',
                    'nome': dadosNovos['nome'],
                    'descricao': dadosNovos['descricao'],
                    'valueInCents': dadosNovos['valor'],
                  };

                  _adicionarServico(novoServico);
                }

                await _carregarServicosDoBanco();
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
            padding: const EdgeInsets.fromLTRB(
              16,
              18,
              16,
              90,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 650,
                ),
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
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                _formatar(_subtotal),
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _searchController,
                            onChanged: (_) {
                              setState(() {});
                            },
                            decoration: customInputDecoration(
                              hintText: 'Procurar serviço',
                            ).copyWith(
                              prefixIcon: Icon(
                                Icons.search,
                                color: colors.secondary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          if (listaAtual.isEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 24,
                              ),
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
                              physics:
                                  const NeverScrollableScrollPhysics(),
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
          child: CustomFloatingButton(
            onPressed: _abrirListaServicos,
          ),
        ),
      ],
    );
  }


  Widget _buildServiceCard(
    ServiceOrderService servico,
    int index,
  ) {
    final int preco = servico.subtotalCents < 0
        ? 0
        : servico.subtotalCents;

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
          color: colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              servico.description,
              style: TextStyle(
                color: Colors.blueGrey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

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

class _EditServiceSheet extends StatefulWidget {
  final Map<String, dynamic> servico;

  final Future<void> Function(Service atualizado) onSave;

  const _EditServiceSheet({
    required this.servico,
    required this.onSave,
  });

  @override
  State<_EditServiceSheet> createState() =>
      _EditServiceSheetState();
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

    final int centavos =
        servico['valueInCents'] as int? ?? 0;

    _valorController = TextEditingController(
      text: (centavos / 100)
          .toStringAsFixed(2)
          .replaceAll('.', ','),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();

    super.dispose();
  }

  int? _parseCentavos(String texto) {
    final valor = texto.trim();

    if (valor.isEmpty) return null;

    final normalizado = valor
        .replaceAll('.', '')
        .replaceAll(',', '.');

    final numero = double.tryParse(normalizado);

    if (numero == null || !numero.isFinite || numero < 0) {
      return null;
    }

    return Dinheiro.fromReais(numero).centavos;
  }


  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) {
      return;
    }

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final String id =
        widget.servico['servicoId']?.toString() ??
        widget.servico['id'].toString();

    final atualizado = Service(
      id: id,
      name: _nomeController.text.trim(),
      description: _descricaoController.text.trim(),
      valueInCents: _parseCentavos(
        _valorController.text,
      )!,
    );

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
          content: Text(
            'Não foi possível atualizar o serviço.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          24,
          16,
          24,
          24,
        ),
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
                      Icon(
                        Icons.edit_outlined,
                        color: colors.primary,
                      ),
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
                    textCapitalization:
                        TextCapitalization.sentences,
                    decoration: customInputDecoration(
                      hintText: 'Nome do serviço',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Informe o nome.';
                      }

                      return null;
                    },
                  ),

                  _label('Descrição'),

                  TextFormField(
                    controller: _descricaoController,
                    maxLength: 50,
                    textCapitalization:
                        TextCapitalization.sentences,
                    decoration: customInputDecoration(
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
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: customInputDecoration(
                      hintText: '0,00',
                    ).copyWith(
                      prefixText: 'R\$ ',
                    ),
                    validator: (value) {
                      if (_parseCentavos(value ?? '') == null) {
                        return 'Informe um valor válido.';
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
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: const Text(
                        'Salvar alterações',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onSecondary,
                        disabledBackgroundColor:
                            Colors.grey.shade300,
                        disabledForegroundColor:
                            Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
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
