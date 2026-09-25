import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableDeleteCard extends StatelessWidget {
  final Key? slidableKey;
  final Widget child;
  final VoidCallback? onDelete;
  final double extentRatio;

  const SlidableDeleteCard({
    super.key,
    required this.slidableKey,
    required this.child,
    this.onDelete,
    this.extentRatio = 0.18,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: slidableKey,
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: extentRatio,
        children: [
          SlidableAction(
            onPressed: (_) {
              onDelete?.call();
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
      child: child,
    );
  }
}
