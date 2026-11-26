import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/os.dart';

class ServiceOrderState extends ChangeNotifier {
  ServiceOrderState(this.serviceOrder);

  final ServiceOrder serviceOrder;

  void applyUserEdit(void Function(ServiceOrder) edit) {
    final before = _editableState();
    edit(serviceOrder);
    if (!_sameValue(before, _editableState())) {
      notifyListeners();
    }
  }

  Map<String, dynamic> _editableState() => {
    ...serviceOrder.toFirestore(),
    'relatorio': serviceOrder.report,
  };

  bool _sameValue(Object? before, Object? after) {
    if (before is Map && after is Map) {
      return before.length == after.length &&
          before.keys.every(
            (key) =>
                after.containsKey(key) && _sameValue(before[key], after[key]),
          );
    }
    if (before is List && after is List) {
      if (before.length != after.length) return false;
      for (var index = 0; index < before.length; index++) {
        if (!_sameValue(before[index], after[index])) return false;
      }
      return true;
    }
    return before == after;
  }
}
