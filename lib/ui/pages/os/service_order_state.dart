import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/os.dart';

class ServiceOrderState extends ChangeNotifier {
  ServiceOrderState(this.serviceOrder, {required this.saveDraft});

  final ServiceOrder serviceOrder;
  final Future<void> Function(
    ServiceOrder, {
    required void Function(Object, StackTrace) onSyncError,
  }) saveDraft;
  Timer? _autosaveTimer;
  Future<void>? _localWrite;
  bool _hasPendingEdit = false;
  bool _completing = false;
  bool _disposed = false;
  int _writeRevision = 0;

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
      _localWrite = _saveDraft(++_writeRevision);
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
    if (saved) {
      _writeRevision++;
      _hasPendingEdit = false;
    }
  }

  Future<void> _saveDraft(int revision) async {
    void registerFailure(Object error, StackTrace stackTrace) {
      if (!_disposed && revision == _writeRevision) {
        _hasPendingEdit = true;
      }
      debugPrint('Erro no autosave da OS ${serviceOrder.id}: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    try {
      await saveDraft(serviceOrder, onSyncError: registerFailure);
    } catch (error, stackTrace) {
      registerFailure(error, stackTrace);
    }
  }

  @override
  void dispose() {
    _disposed = true;
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
