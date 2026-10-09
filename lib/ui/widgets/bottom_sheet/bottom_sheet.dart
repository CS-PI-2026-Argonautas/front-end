import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';
import 'package:frontend/ui/style/ColorScheme.dart' as custom_colors;

class SelectionBottomSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;

  final String searchText;
  final String actionText;

  final String Function(T item) itemTitle;
  final String Function(T item)? itemSubtitle;

  final IconData? itemIcon;

  final bool loading;

  final VoidCallback? onAction;
  final void Function(T item) onSelect;

  final void Function(T item)? onEdit;
  final void Function(T item)? onDelete;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.searchText,
    required this.actionText,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemIcon,
    this.loading = false,
    this.onAction,
    required this.onSelect,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<SelectionBottomSheet<T>> createState() =>
      _SelectionBottomSheetState<T>();
}

class _SelectionBottomSheetState<T>
    extends State<SelectionBottomSheet<T>> {
  final colors = custom_colors.colorScheme;

  final TextEditingController _searchController =
      TextEditingController();

  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();

    _filteredItems = List.from(widget.items);

    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(
    covariant SelectionBottomSheet<T> oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.items != widget.items) {
      _filterItems();
    }
  }

  void _filterItems() {
    final search = removeDiacritics(
      _searchController.text,
    ).toLowerCase();

    setState(() {
      _filteredItems = widget.items.where((item) {
        final title = removeDiacritics(
          widget.itemTitle(item),
        ).toLowerCase();

        return title.contains(search);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            26,
            20,
            26,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.onAction != null)
                    IconButton(
                      onPressed: widget.onAction,
                      icon: Icon(
                        Icons.add,
                        color: colors.primary,
                        size: 28,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.searchText,
                  prefixIcon: Icon(
                    Icons.search,
                    color: colors.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: colors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: widget.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _filteredItems.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'Nenhum item encontrado',
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item =
                                  _filteredItems[index];

                              return ListTile(
                                contentPadding:
                                    EdgeInsets.zero,
                                leading: widget.itemIcon != null
                                    ? Icon(
                                        widget.itemIcon,
                                        color: colors.primary,
                                        size: 30,
                                      )
                                    : null,
                                title: Text(
                                  widget.itemTitle(item),
                                  style: TextStyle(
                                    color: colors.onSurface,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle:
                                    widget.itemSubtitle != null
                                        ? Text(
                                            widget.itemSubtitle!(
                                              item,
                                            ),
                                            style: TextStyle(
                                              color: colors
                                                  .onSurfaceVariant,
                                              fontSize: 15,
                                            ),
                                          )
                                        : null,
                                trailing: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    if (widget.onEdit != null)
                                      IconButton(
                                        onPressed: () {
                                          widget.onEdit!(item);
                                        },
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color: colors.primary,
                                        ),
                                      ),
                                    if (widget.onDelete != null)
                                      IconButton(
                                        onPressed: () {
                                          widget.onDelete!(item);
                                        },
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: colors.error,
                                        ),
                                      ),
                                    Icon(
                                      Icons.chevron_right,
                                      color:
                                          colors.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  widget.onSelect(item);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}