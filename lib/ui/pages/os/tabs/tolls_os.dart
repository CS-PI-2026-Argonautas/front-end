import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/fire_base/models/dinheiro.dart';
import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/repositories/item_repository.dart';
import 'package:frontend/fire_base/services/item_service.dart';
import 'package:frontend/ui/pages/os/service_order_state.dart';
import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:frontend/ui/widgets/floatingButton.dart';

class TollsOs extends StatefulWidget {
  final ServiceOrderState serviceOrderState;
  final VoidCallback? avancarTab;
  final VoidCallback? onChanged;
  final ValueChanged<bool>? onSomenteServicosChanged;

  const TollsOs({
    super.key,
    required this.serviceOrderState,
    this.avancarTab,
    this.onChanged,
    this.onSomenteServicosChanged,
  });

  @override
  State<TollsOs> createState() => OrderServiceState();
}

class OrderServiceState extends State<TollsOs>
    with AutomaticKeepAliveClientMixin {
  final colors = custom_colors.colorScheme;

  ServiceOrder get _os => widget.serviceOrderState.serviceOrder;

  late final ItemService _itemService;
  late final Stream<List<Item>> _pecasStream;

  Timer? _snackBarTimer;
  bool _somenteServicos = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _itemService = ItemService(repository: ItemRepository());
    _pecasStream = _itemService.watchParts();

    _somenteServicos = _os.parts.isEmpty && _os.services.isNotEmpty;
  }

  void _editarOs(void Function(ServiceOrder) editar) {
    widget.serviceOrderState.applyUserEdit(editar);
    widget.onChanged?.call();
  }

  int _calcularSubtotal() {
    return _os.parts.fold<int>(0, (total, peca) => total + peca.subtotalCents);
  }

  Future<void> _abrirEdicao(Item peca) async {
    if (peca.id == null) return;

    final Item? pecaAtualizada = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductRegistration(abertoPelaOS: true, itemEdicao: peca),
      ),
    );

    if (!mounted || pecaAtualizada == null) return;

    _atualizarPecaNaOS(pecaAtualizada);
  }

  void _atualizarPecaNaOS(Item pecaAtualizada) {
    if (pecaAtualizada.id == null) return;

    final index = _os.parts.indexWhere(
      (item) => item.partId == pecaAtualizada.id,
    );

    if (index == -1) return;

    _editarOs((os) {
      final pecaAntiga = os.parts[index];
      os.parts[index] = ServiceOrderPart(
        partId: pecaAntiga.partId,
        name: pecaAtualizada.name,
        quantity: pecaAntiga.quantity,
        unitPriceCents: pecaAtualizada.valueInCents,
        discountCents: pecaAntiga.discountCents,
      );
    });
  }

  void _removerPeca(int index) {
    if (index < 0 || index >= _os.parts.length) return;

    final pecaRemovida = _os.parts[index];

    _editarOs((os) => os.parts.removeAt(index));

    final messenger = ScaffoldMessenger.of(context);

    _snackBarTimer?.cancel();
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text('${pecaRemovida.name} removida.'),
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
              os.parts.insert(index.clamp(0, os.parts.length), pecaRemovida);
            });
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

  Future<void> _confirmarRemocaoPeca(int index) async {
    if (index < 0 || index >= _os.parts.length) return;

    final peca = _os.parts[index];

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remover peça'),
          content: Text('Deseja remover "${peca.name}" da OS?'),
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
    );

    if (confirmar != true || !mounted) return;

    _removerPeca(index);
  }

  Future<void> _excluirPecaDoCadastro(Item peca) async {
    final itemId = peca.id;

    final bool naOs = _os.parts.any((item) => item.partId == itemId);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir peça'),
          content: Text(
            naOs
                ? 'Deseja excluir "${peca.name}" do cadastro? '
                      'Ela também será removida desta OS.'
                : 'Deseja excluir "${peca.name}" do cadastro?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('CANCELAR'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('EXCLUIR', style: TextStyle(color: colors.error)),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    if (itemId == null || itemId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir: ID da peça não encontrado.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      await _itemService.delete(itemId);

      if (!mounted) return;

      _editarOs((os) {
        os.parts.removeWhere((item) => item.partId == itemId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Peça excluída com sucesso.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Erro ao excluir peça: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir a peça.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _snackBarTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<List<Item>>(
      stream: _pecasStream,
      builder: (context, snapshot) {
        final pecasDisponiveis = snapshot.data ?? [];

        return Scaffold(
          backgroundColor: colors.surface,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 18,
              ),
              child: Align(
                alignment: Alignment.topCenter,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.build, color: colors.secondary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Subtotal de peças',
                                    style: TextStyle(
                                      color: colors.onSurface,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                Dinheiro(_calcularSubtotal()).formatado(),
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
                            'Selecione as peças utilizadas nesta Ordem de Serviço.',
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          CheckboxListTile(
                            value: _somenteServicos,
                            onChanged: (value) async {
                              final marcarSomenteServicos = value ?? false;

                              if (marcarSomenteServicos &&
                                  _os.parts.isNotEmpty) {
                                final confirmar = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Remover peças da OS?'),
                                      content: const Text(
                                        'Ao selecionar esta opção, todas as peças adicionadas '
                                        'serão removidas da Ordem de Serviço. Deseja continuar?',
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
                                            'REMOVER PEÇAS',
                                            style: TextStyle(
                                              color: colors.error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (!mounted || confirmar != true) return;

                                _editarOs((os) {
                                  os.parts.clear();
                                });
                                setState(() {
                                  _somenteServicos = true;
                                });
                                widget.onSomenteServicosChanged?.call(
                                  _somenteServicos,
                                );

                                return;
                              }

                              setState(() {
                                _somenteServicos = marcarSomenteServicos;
                              });

                              widget.onChanged?.call();
                              widget.onSomenteServicosChanged?.call(
                                _somenteServicos,
                              );
                            },
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: colors.primary,
                            title: Text(
                              'OS somente de serviços (sem peças)',
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Marque esta opção caso não sejam necessárias peças nesta OS.',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            const LinearProgressIndicator(),
                          if (snapshot.hasError)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'Erro ao carregar peças: ${snapshot.error}',
                                style: TextStyle(color: colors.error),
                              ),
                            ),
                          _os.parts.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhuma peça adicionada.',
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(4),
                                  itemCount: _os.parts.length,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 12);
                                  },
                                  itemBuilder: (context, index) {
                                    return _buildPieceCard(
                                      _os.parts[index],
                                      index,
                                    );
                                  },
                                ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  (_os.parts.isNotEmpty || _somenteServicos) &&
                                      widget.avancarTab != null
                                  ? () {
                                      widget.avancarTab?.call();
                                    }
                                  : null,
                              icon: const Icon(Icons.handyman),
                              label: const Text(
                                'Adicionar Serviços',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation:
                                    (_os.parts.isNotEmpty || _somenteServicos)
                                    ? 3
                                    : 0,
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
                              _somenteServicos
                                  ? 'OS configurada para serviços sem utilização de peças.'
                                  : 'Adicione peças ou marque a opção de OS somente de serviços.',
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
          floatingActionButton: CustomFloatingButton(
            onPressed: snapshot.hasData && !snapshot.hasError
                ? () => abrirListaPecas(pecasDisponiveis)
                : () {},
          ),
        );
      },
    );
  }

  void abrirListaPecas(List<Item> pecasDisponiveis) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceContainer,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StreamBuilder<List<Item>>(
          stream: _pecasStream,
          initialData: pecasDisponiveis,
          builder: (context, snapshot) {
            final pecas = snapshot.data ?? pecasDisponiveis;

            return SelectionBottomSheet<Item>(
              title: 'Selecionar peça',
              items: pecas,
              searchText: 'Buscar peça...',
              actionText: 'Nova peça',
              itemIcon: Icons.build,
              itemTitle: (peca) => peca.name,
              itemSubtitle: (peca) {
                return Dinheiro(peca.valueInCents).formatado();
              },
              onEdit: (peca) async {
                await _abrirEdicao(peca);
              },
              onDelete: (peca) async {
                await _excluirPecaDoCadastro(peca);
              },
              onSelect: (peca) {
                _adicionarPeca(peca);
                Navigator.pop(sheetContext);
              },
              onAction: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductRegistration(abertoPelaOS: true),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _adicionarPeca(Item peca) {
    if (peca.id == null) return;

    _editarOs((os) {
      final index = os.parts.indexWhere((item) => item.partId == peca.id);

      if (index != -1) {
        final parteExistente = os.parts[index];

        os.parts[index] = parteExistente.withQuantity(
          parteExistente.quantity + 1,
        );
      } else {
        os.parts.add(
          ServiceOrderPart(
            partId: peca.id!,
            name: peca.name,
            quantity: 1,
            unitPriceCents: peca.valueInCents,
            discountCents: 0,
          ),
        );
      }
    });
  }

  void _aumentarQuantidade(int index) {
    final peca = _os.parts[index];

    _editarOs((os) {
      os.parts[index] = peca.withQuantity(peca.quantity + 1);
    });
  }

  void _diminuirQuantidade(int index) {
    final peca = _os.parts[index];

    if (peca.quantity <= 1) return;

    _editarOs((os) {
      os.parts[index] = peca.withQuantity(peca.quantity - 1);
    });
  }

  Widget _buildPieceCard(ServiceOrderPart peca, int index) {
    final int quantidade = peca.quantity;
    final Dinheiro preco = Dinheiro(peca.unitPriceCents);
    final Dinheiro totalItem = Dinheiro(peca.subtotalCents);

    return Slidable(
      key: ValueKey(peca.partId),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (context) {
              _confirmarRemocaoPeca(index);
            },
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            borderRadius: BorderRadius.circular(18),
          ),
        ],
      ),
      child: Container(
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
                  Text(
                    peca.name,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$quantidade un x ${preco.formatado()}/un',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    totalItem.formatado(),
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _aumentarQuantidade(index),
                  icon: Icon(Icons.add, color: colors.primary),
                ),
                Text(
                  '$quantidade',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: quantidade > 1
                      ? () => _diminuirQuantidade(index)
                      : null,
                  icon: Icon(
                    Icons.remove,
                    color: quantidade > 1
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}