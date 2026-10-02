import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/fire_base/models/services.dart';
import 'package:frontend/fire_base/repositories/service_repository.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final repository = ServicesRepository();

  try {
    print('======================================');
    print('   TESTE DO FIRESTORE - ORDENS DE OS');
    print('======================================');

    final ordens = [
      Services(
        id: 'teste-os-001',
        name: 'Manutenção preventiva',
        part: 'Filtro de ar',
        equipment: 'Compressor Industrial',
        client: 'Empresa Alpha',
        assignee: 'João Técnico',
        date: DateTime.now(),
        status: 'Pendente',
        report: 'Manutenção preventiva solicitada.',
        city: 'Paranavaí',
      ),

      Services(
        id: 'teste-os-002',
        name: 'Troca de componente',
        part: 'Motor',
        equipment: 'Gerador',
        client: 'Empresa Beta',
        assignee: 'Carlos Técnico',
        date: DateTime.now().subtract(
          const Duration(days: 1),
        ),
        status: 'Em Andamento',
        report: 'Troca de componente em execução.',
        city: 'Maringá',
      ),

      Services(
        id: 'teste-os-003',
        name: 'Inspeção técnica',
        part: 'Sensor',
        equipment: 'Máquina CNC',
        client: 'Empresa Gamma',
        assignee: 'Pedro Técnico',
        date: DateTime.now().subtract(
          const Duration(days: 2),
        ),
        status: 'Concluída',
        report: 'Inspeção concluída com sucesso.',
        city: 'Londrina',
      ),
    ];


    for (final os in ordens) {
      await repository.save(os);

      print(
        '✅ OS salva: ${os.id} - ${os.name}',
      );
    }


    final ordensSalvas = await repository.listAll();

    print('');
    print('======================================');
    print('OS ENCONTRADAS NO FIRESTORE:');
    print('======================================');

    for (final os in ordensSalvas) {
      print(
        '${os.id} | ${os.name} | ${os.status} | ${os.city}',
      );
    }

    print('');
    print(
      ' Total de OS encontradas: ${ordensSalvas.length}',
    );


    await repository.delete('teste-os-003');

    print('');
    print(' OS teste-os-003 marcada como excluída.');

    final depoisDaExclusao =
        await repository.listAll();

    print(
      ' OS ativas após exclusão: '
      '${depoisDaExclusao.length}',
    );


    await repository.restore('teste-os-003');

    print('');
    print(' OS teste-os-003 restaurada.');

    final depoisDaRestauracao =
        await repository.listAll();

    print(
      ' OS ativas após restauração: '
      '${depoisDaRestauracao.length}',
    );


    print('');
    print('======================================');
    print(' TESTE CONCLUÍDO!');
    print('======================================');
    print('');
    print(
      'As OS de teste foram gravadas na coleção:',
    );
    print('service_orders');
    print('');
    print(
      'Agora abra a OsListPage para verificar se elas aparecem.',
    );
    print('');
  } catch (e, stackTrace) {
    print('');
    print('======================================');
    print(' ERRO NO TESTE');
    print('======================================');
    print(e);
    print('');
    print(stackTrace);
  }
}