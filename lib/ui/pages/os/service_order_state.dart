import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/os.dart';

class ServiceOrderState extends ChangeNotifier {
  ServiceOrderState(this.serviceOrder, {required this.saveDraft});

  final ServiceOrder serviceOrder;
  final Future<void> Function(ServiceOrder) saveDraft;
  Timer? _autosaveTimer;
  Future<void>? _localWrite;
  bool _hasPendingEdit = false;
  bool _completing = false;

  void applyUserEdit(void Function(ServiceOrder) edit) {
    final before = _editableState();
    edit(serviceOrder);
    if (!_sameValue(before, _editableState())) {
      _hasPendingEdit = true;
      _autosaveTimer?.cancel();
      if (!_completing) {
        _autosaveTimer = Timer(const Duration(seconds: 3), flushPending);
      }
      notifyListeners();
    }
  }

  Future<void> flushPending() async {
    if (_completing) return;
    if (_hasPendingEdit) {
      _autosaveTimer?.cancel();
      _hasPendingEdit = false;
      _localWrite = _saveDraft();
    }
    await _localWrite;
  }

  Future<void> beginCompletion() async {
    _completing = true;
    _autosaveTimer?.cancel();
    await _localWrite;
  }

  void endCompletion({required bool saved}) {
    _completing = false;
    if (saved) _hasPendingEdit = false;
  }

  Future<void> _saveDraft() async {
    try {
      await saveDraft(serviceOrder);
    } catch (error, stackTrace) {
      debugPrint('Erro no autosave da OS ${serviceOrder.id}: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    super.dispose();
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
