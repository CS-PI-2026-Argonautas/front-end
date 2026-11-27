import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/fire_base/Enums/StatusOrderService.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/ui/pages/os/service_order_state.dart';

void main() {
  final rejection = StateError('Gravação rejeitada');

  testWidgets('a failed local write is retried on the next flush', (tester) async {
    final reports = <String>[];
    final state = ServiceOrderState(
      ServiceOrder.createNew(),
      saveDraft: (os, {required includeEquipmentChange, required onSyncSuccess, required onSyncError}) async {
        reports.add(os.report);
        if (reports.length == 1) throw rejection;
      },
    );
    addTearDown(state.dispose);

    state.applyUserEdit((os) => os.report = 'Diagnóstico');
    expect(await state.flushPending(), isFalse);
    expect(state.serviceOrder.report, 'Diagnóstico');
    expect(reports, ['Diagnóstico']);

    expect(await state.flushPending(), isTrue);
    expect(reports, ['Diagnóstico', 'Diagnóstico']);
  });

  testWidgets('remote rejection retries the latest revision only', (tester) async {
    final reports = <String>[];
    final failures = <void Function(Object, StackTrace)>[];
    final state = ServiceOrderState(
      ServiceOrder.createNew(),
      saveDraft: (os, {required includeEquipmentChange, required onSyncSuccess, required onSyncError}) async {
        reports.add(os.report);
        failures.add(onSyncError);
      },
    );
    addTearDown(state.dispose);

    state.applyUserEdit((os) => os.report = 'Anterior');
    await state.flushPending();
    state.applyUserEdit((os) => os.report = 'Atual');
    await state.flushPending();

    failures.first(rejection, StackTrace.empty);
    await state.flushPending();
    expect(reports, ['Anterior', 'Atual']);

    failures.last(rejection, StackTrace.empty);
    await state.flushPending();
    expect(reports, ['Anterior', 'Atual', 'Atual']);
  });

  testWidgets('waiting for local acceptance is not a new write', (tester) async {
    final local = Completer<void>();
    var writes = 0;
    final state = ServiceOrderState(
      ServiceOrder.createNew(),
      saveDraft: (_, {required includeEquipmentChange, required onSyncSuccess, required onSyncError}) {
        writes++;
        return local.future;
      },
    );
    addTearDown(state.dispose);

    state.applyUserEdit((os) => os.report = 'Na fila');
    final first = state.flushPending();
    final second = state.flushPending();
    await tester.pump(const Duration(seconds: 4));
    expect(writes, 1);

    local.complete();
    await Future.wait([first, second]);
    expect(state.serviceOrder.report, 'Na fila');
  });

  for (final status in [ServiceOrderStatus.ENTREGUE, ServiceOrderStatus.PAGA]) {
    testWidgets('includes the last valid equipment change on ${status.name}', (
      tester,
    ) async {
      final writes = <(bool, bool, String?)>[];
      final confirmations = <void Function()>[];
      final os = ServiceOrder(
        persisted: true,
        equipment: ServiceOrderEquipment(serialNumber: 'anterior'),
      );
      final state = ServiceOrderState(
        os,
        saveDraft: (draft, {required includeEquipmentChange, required onSyncSuccess, required onSyncError}) async {
          writes.add((draft.equipmentBlocked, includeEquipmentChange, draft.equipment?.serialNumber));
          confirmations.add(onSyncSuccess);
        },
      );
      addTearDown(state.dispose);

      state.applyUserEdit((draft) {
        draft.equipment = ServiceOrderEquipment(serialNumber: 'novo');
      });
      await tester.pump(const Duration(seconds: 2));
      state.applyUserEdit((draft) => draft.changeStatus(status));
      await tester.pump(const Duration(seconds: 3));
      expect(writes, [(true, true, 'novo')]);

      confirmations.single();
      state.applyUserEdit((draft) => draft.report = 'Relatório');
      expect(await state.flushPending(), isTrue);
      expect(writes.last, (true, false, 'novo'));
    });
  }
}
