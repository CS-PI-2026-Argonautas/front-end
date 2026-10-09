import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:frontend/fire_base/Enums/TiposItens.dart';
import 'package:frontend/fire_base/models/item.dart';
import 'package:frontend/fire_base/repositories/item_repository.dart';
import 'package:frontend/fire_base/services/item_service.dart';

import 'package:frontend/ui/pages/product_registration/product_registration.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;
import 'package:frontend/ui/widgets/floatingButton.dart';
import 'package:frontend/ui/style/inputDecorationStyles.dart';
import 'package:frontend/ui/widgets/bottom_sheet/bottom_sheet.dart';

class TollsOs extends StatefulWidget {
  const TollsOs({super.key});

  @override
  State<TollsOs> createState() => TollsOsState();
}

class TollsOsState extends State<TollsOs>
    with AutomaticKeepAliveClientMixin {
  final colors = custom_colors.colorScheme;

  final ItemService _itemService = ItemService(
    ItemRepository(),
  );

  final List<Map<String, dynamic>> orderParts = [];

  @override
  bool get wantKeepAlive => true;

  int _calculateSubtotal() {
    int subtotal = 0;

    for (final part in orderParts) {
      final int quantity = part['quantity'] as int;
      final int priceInCents = part['price'] as int;

      subtotal += quantity * priceInCents;
    }

    return subtotal;
  }

  String _formatPrice(int cents) {
    final int reais = cents ~/ 100;
    final int decimal = cents % 100;

    return 'R\$${reais.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )},${decimal.toString().padLeft(2, '0')}';
  }

  int _parseValueInCents(String value) {
    final input = value.trim();

    if (input.isEmpty) {
      throw const FormatException('Valor vazio.');
    }

    String integerPart;
    String decimalPart;

    if (input.contains(',')) {
      final parts = input.split(',');

      if (parts.length != 2) {
        throw const FormatException('Valor inválido.');
      }

      integerPart = parts[0].replaceAll('.', '');
      decimalPart = parts[1];
    } else if (input.contains('.')) {
      final parts = input.split('.');

      if (parts.length == 2 && parts[1].length <= 2) {
        integerPart = parts[0];
        decimalPart = parts[1];
      } else {
        integerPart = input.replaceAll('.', '');
        decimalPart = '00';
      }
    } else {
      integerPart = input;
      decimalPart = '00';
    }

    if (integerPart.isEmpty) {
      integerPart = '0';
    }

    if (decimalPart.length == 1) {
      decimalPart += '0';
    }

    if (decimalPart.length != 2 ||
        !RegExp(r'^\d+$').hasMatch(integerPart) ||
        !RegExp(r'^\d{2}$').hasMatch(decimalPart)) {
      throw const FormatException('Valor inválido.');
    }

    return int.parse(integerPart) * 100 + int.parse(decimalPart);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final int subtotal = _calculateSubtotal();

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal de peças',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatPrice(subtotal),
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: orderParts.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhuma peça adicionada',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: orderParts.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          return _buildPartCard(
                            orderParts[index],
                            index,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        onPressed: _openPartList,
      ),
    );
  }

  void _openPartList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return StreamBuilder<List<Item>>(
          stream: _itemService.watchParts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar peças.',
                  style: TextStyle(
                    color: colors.onSurface,
                  ),
                ),
              );
            }

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<Item> parts = snapshot.data ?? [];

            return SelectionBottomSheet<Item>(
              title: 'Selecionar peça',
              items: parts,
              searchText: 'Buscar peça...',
              actionText: 'Nova peça',
              itemIcon: Icons.build_outlined,
              itemTitle: (part) => part.name,
              itemSubtitle: (part) =>
                  _formatPrice(part.valueInCents),
              onEdit: (part) {
                _showEditItemSheet(part);
              },
              onDelete: (part) {
                _showDeleteConfirmation(part);
              },
              onSelect: (part) {
                final bool alreadyAdded = orderParts.any(
                  (item) => item['id'] == part.id,
                );

                if (alreadyAdded) {
                  _showDuplicatePartDialog(part);
                  return;
                }

                _addPart(part);
                Navigator.pop(bottomSheetContext);
              },
              onAction: () {
                Navigator.push(
                  bottomSheetContext,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProductRegistration(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDuplicatePartDialog(Item part) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Peça já adicionada',
          ),
          content: Text(
            'A peça "${part.name}" já está adicionada nesta OS.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addPart(Item part) {
    setState(() {
      orderParts.add({
        'id': part.id,
        'name': part.name,
        'price': part.valueInCents,
        'quantity': 1,
      });
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      orderParts[index]['quantity'] =
          (orderParts[index]['quantity'] as int) + 1;
    });
  }

  void _decreaseQuantity(int index) {
    final int quantity =
        orderParts[index]['quantity'] as int;

    if (quantity <= 1) {
      return;
    }

    setState(() {
      orderParts[index]['quantity'] = quantity - 1;
    });
  }

  void _removePart(int index) {
    setState(() {
      orderParts.removeAt(index);
    });
  }

  Future<void> _updateItem(Item updatedItem) async {
    await _itemService.update(updatedItem);

    if (!mounted) return;

    setState(() {
      for (final part in orderParts) {
        if (part['id'] == updatedItem.id) {
          part['name'] = updatedItem.name;
          part['price'] = updatedItem.valueInCents;
        }
      }
    });
  }

  Future<void> _showEditItemSheet(Item item) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _EditItemSheet(
          item: item,
          formatPrice: _formatPrice,
          parseValueInCents: _parseValueInCents,
          onSave: _updateItem,
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(Item item) async {
    final bool inOrder = orderParts.any(
      (part) => part['id'] == item.id,
    );

    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Excluir peça'),
              content: Text(
                inOrder
                    ? 'Deseja excluir "${item.name}"? '
                        'Ela também será removida desta OS.'
                    : 'Deseja excluir "${item.name}"?',
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
                    'EXCLUIR',
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

    if (!confirmed) return;

    try {
      await _itemService.delete(item);

      if (!mounted) return;

      setState(() {
        orderParts.removeWhere(
          (part) => part['id'] == item.id,
        );
      });

      _showMessage('Peça excluída com sucesso.');
    } catch (e) {
      debugPrint('Erro ao excluir peça: $e');

      if (!mounted) return;

      _showMessage('Não foi possível excluir a peça.');
    }
  }

  Widget _buildPartCard(
    Map<String, dynamic> part,
    int index,
  ) {
    final int quantity = part['quantity'] as int;
    final int priceInCents = part['price'] as int;

    final int totalItem = quantity * priceInCents;

    return Slidable(
      key: ValueKey(part['id']),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (context) {
              _removePart(index);
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
          color: colors.surfaceContainer,

          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    part['name'] as String,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$quantity un x '
                    '${_formatPrice(priceInCents)}/un',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatPrice(totalItem),
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _increaseQuantity(index);
                  },
                  icon: Icon(
                    Icons.add,
                    color: colors.primary,
                  ),
                ),
                Text(
                  '$quantity',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: quantity > 1
                      ? () {
                          _decreaseQuantity(index);
                        }
                      : null,
                  icon: Icon(
                    Icons.remove,
                    color: quantity > 1
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
class _EditItemSheet extends StatefulWidget {
  final Item item;
  final String Function(int cents) formatPrice;
  final int Function(String value) parseValueInCents;
  final Future<void> Function(Item updatedItem) onSave;

  const _EditItemSheet({
    required this.item,
    required this.formatPrice,
    required this.parseValueInCents,
    required this.onSave,
  });

  @override
  State<_EditItemSheet> createState() => _EditItemSheetState();
}

class _EditItemSheetState extends State<_EditItemSheet> {
  final colors = custom_colors.colorScheme;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _valueController;
  late final TextEditingController _minimumQuantityController;

  late TipoProduto _selectedType;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _nameController = TextEditingController(text: item.name);
    _descriptionController = TextEditingController(
      text: item.description ?? '',
    );
    _valueController = TextEditingController(
      text: widget
          .formatPrice(item.valueInCents)
          .replaceFirst('R\$', ''),
    );
    _minimumQuantityController = TextEditingController(
      text: item.minimumQuantity.toString(),
    );

    _selectedType = item.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _minimumQuantityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final String description =
        _descriptionController.text.trim();

    final Item updatedItem = Item(
      id: widget.item.id,
      name: _nameController.text.trim(),
      description: description.isEmpty ? null : description,
      valueInCents: widget.parseValueInCents(
        _valueController.text,
      ),
      minimumQuantity: int.parse(
        _minimumQuantityController.text.trim(),
      ),
      type: _selectedType,
      createdAt: widget.item.createdAt,
      updatedAt: widget.item.updatedAt,
      deletedAt: widget.item.deletedAt,
    );

    setState(() {
      _saving = true;
    });

    try {
      await widget.onSave(updatedItem);

      navigator.pop();

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Peça atualizada com sucesso.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Erro ao atualizar peça: $e');

      if (mounted) {
        setState(() {
          _saving = false;
        });
      }

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível atualizar a peça.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
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
                      Icon(
                        Icons.edit_outlined,
                        color: colors.primary,
                      ),
                      Text(
                        'Editar peça',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildLabel('Nome'),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization:
                        TextCapitalization.sentences,
                    decoration: customInputDecoration(
                      hintText: 'Nome da peça',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Informe o nome.';
                      }

                      return null;
                    },
                  ),
                  _buildLabel('Descrição'),
                  TextFormField(
                    controller: _descriptionController,
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
                  _buildLabel('Valor'),
                  TextFormField(
                    controller: _valueController,
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
                      try {
                        widget.parseValueInCents(value ?? '');
                        return null;
                      } catch (_) {
                        return 'Informe um valor válido.';
                      }
                    },
                  ),
                  _buildLabel('Quantidade mínima'),
                  TextFormField(
                    controller: _minimumQuantityController,
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration(
                      hintText: '0',
                    ),
                    validator: (value) {
                      final int? quantity =
                          int.tryParse((value ?? '').trim());

                      if (quantity == null || quantity < 0) {
                        return 'Informe uma quantidade válida.';
                      }

                      return null;
                    },
                  ),
                  _buildLabel('Tipo'),
                  DropdownButtonFormField<TipoProduto>(
                    value: _selectedType,
                    decoration: customInputDecoration(
                      hintText: 'Selecione o tipo',
                    ),
                    items: TipoProduto.values.map((type) {
                      return DropdownMenuItem<TipoProduto>(
                        value: type,
                        child: Text(type.label),
                      );
                    }).toList(),
                    onChanged: (type) {
                      if (type == null) return;

                      setState(() {
                        _selectedType = type;
                      });
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
                          borderRadius:
                              BorderRadius.circular(14),
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