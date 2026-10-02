import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:frontend/firebase_options.dart';
import 'package:frontend/fire_base/models/services.dart';
import 'package:frontend/fire_base/repositories/service_repository.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final repository = ServicesRepository();

  try {
    // 1. SALVAR
    final os = Services(
      id: 'teste-os-001',
      name: 'OS Teste Firestore',
      part: 'Peça Teste',
      equipment: 'Equipamento Teste',
      client: 'Cliente Teste',
      assignee: 'Técnico Teste',
      date: DateTime.now(),
      status: 'Pendente',
      report: 'Teste do ServicesRepository',
      city: 'Paranavaí',
    );

    await repository.save(os);

    print('✅ 1 - OS salva com sucesso');

    // 2. LISTAR
    final ordens = await repository.listAll();

    print('✅ 2 - OS encontradas: ${ordens.length}');

    for (final ordem in ordens) {
      print('   ${ordem.id} - ${ordem.name}');
    }

    // 3. DELETAR
    await repository.delete('teste-os-001');

    print('✅ 3 - OS deletada logicamente');

    // 4. VERIFICAR SE SUMIU DA LISTA
    final depoisDeletar = await repository.listAll();

    print(
      '✅ 4 - OS após exclusão: ${depoisDeletar.length}',
    );

    // 5. RESTAURAR
    await repository.restore('teste-os-001');

    print('✅ 5 - OS restaurada');

    // 6. VERIFICAR NOVAMENTE
    final depoisDeRestaurar = await repository.listAll();

    print(
      '✅ 6 - OS após restauração: ${depoisDeRestaurar.length}',
    );

    print('======================================');
    print('🎉 TESTE DO SERVICES REPOSITORY OK!');
    print('======================================');
  } catch (e, stackTrace) {
    print('❌ ERRO NO TESTE:');
    print(e);
    print(stackTrace);
  }
}