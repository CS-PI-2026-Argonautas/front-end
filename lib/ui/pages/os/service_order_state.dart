import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/os.dart';

class ServiceOrderState extends ChangeNotifier {
  ServiceOrderState(this.serviceOrder, {required this.saveDraft});

  final ServiceOrder serviceOrder;
  final Future<void> Function(
    ServiceOrder, {
    required bool includeEquipmentChange,
    required VoidCallback onSyncSuccess,
    required void Function(Object, StackTrace) onSyncError,
  }) saveDraft;
  Timer? _autosaveTimer;
  Future<bool>? _localWrite;
  bool _hasPendingEdit = false;
  bool _completing = false;
  bool _disposed = false;
  int _writeRevision = 0;
  int _equipmentRevision = 0;
  int _syncedEquipmentRevision = 0;

  void applyUserEdit(void Function(ServiceOrder) edit) {
    final before = _editableState();
    final equipmentWasBlocked = serviceOrder.equipmentBlocked;
    edit(serviceOrder);
    final after = _editableState();
    if (!equipmentWasBlocked &&
        !_sameValue(before['equipamento'], after['equipamento'])) {
      _equipmentRevision++;
    }
    if (!_sameValue(before, after)) {
      _hasPendingEdit = true;
      _autosaveTimer?.cancel();
      if (!_completing) {
        _autosaveTimer = Timer(const Duration(seconds: 3), flushPending);
      }
      notifyListeners();
    }
  }

  Future<bool> flushPending() async {
    if (_completing) return false;
    if (_hasPendingEdit) {
      _autosaveTimer?.cancel();
      _hasPendingEdit = false;
      _localWrite = _saveDraft(++_writeRevision);
    }
    var write = _localWrite;
    while (write != null) {
      final saved = await write;
      if (identical(write, _localWrite)) return saved && !_hasPendingEdit;
      write = _localWrite;
    }
    return true;
  }

  Future<bool> beginCompletion() {
    final localWrite = flushPending();
    _completing = true;
    _autosaveTimer?.cancel();
    return localWrite;
  }

  void endCompletion({required bool saved}) {
    _completing = false;
    if (saved) {
      _writeRevision++;
      _hasPendingEdit = false;
      _localWrite = null;
    }
  }

  Future<bool> _saveDraft(int revision) async {
    final equipmentRevision = _equipmentRevision;
    void registerFailure(Object error, StackTrace stackTrace) {
      if (!_disposed && revision == _writeRevision) {
        _hasPendingEdit = true;
      }
      debugPrint('Erro no autosave da OS ${serviceOrder.id}: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    try {
      await saveDraft(
        serviceOrder,
        includeEquipmentChange: equipmentRevision > _syncedEquipmentRevision,
        onSyncSuccess: () {
          if (equipmentRevision > _syncedEquipmentRevision) {
            _syncedEquipmentRevision = equipmentRevision;
          }
        },
        onSyncError: registerFailure,
      );
      return true;
    } catch (error, stackTrace) {
      registerFailure(error, stackTrace);
      return false;
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
