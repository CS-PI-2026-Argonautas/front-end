import 'package:frontend/fire_base/models/so.dart';

class MockOSRepository {
  static final MockOSRepository _instance =
      MockOSRepository._internal();

  MockOSRepository._internal();

  factory MockOSRepository() => _instance;

  final List<ServiceOrder> _serviceOrders = [
    ServiceOrder(
      id: '1',
      name: 'Calibração e aferição anual',
      part: 'Lacre Inmetro',
      equipment: 'Balança Comercial Toledo Prix 3 Plus',
      client: 'Giovanna',
      city: 'Presidente Prudente - SP',
      assignee: 'Carlos (Técnico)',
      date: DateTime(2026, 8, 1, 9, 30),
      status: 'Concluída',
      report:
          'Equipamento calibrado e selado conforme exigências do Inmetro.',
      createdAt: DateTime(2026, 7, 28, 10, 0),
    ),

    ServiceOrder(
      id: '13',
      name: 'Substituição de célula de carga',
      part: 'Célula de carga Zemic 500kg',
      equipment: 'Balança Industrial de Plataforma',
      client: 'Murilo',
      city: 'Campinas - SP',
      assignee: 'Roberto (Técnico)',
      date: DateTime(2026, 8, 5, 14, 0),
      status: 'Em Andamento',
      report:
          'Peça instalada. Aguardando colocação dos pesos padrão para ajuste fino de tara.',
      createdAt: DateTime(2026, 7, 30, 9, 15),
    ),

    ServiceOrder(
      id: '12',
      name: 'Limpeza interna e desoxidação',
      part: 'Nenhuma',
      equipment: 'Balança Analítica de Precisão',
      client: 'Isaque',
      city: 'Belo Horizonte - BH',
      assignee: 'Ana (Especialista)',
      date: DateTime(2026, 8, 7, 10, 15),
      status: 'Em Andamento',
      report:
          'Visor apresentando oscilação na leitura de gramatura. Equipamento na fila para triagem.',
      createdAt: DateTime(2026, 8, 1, 16, 40),
    ),

    ServiceOrder(
      id: '3',
      name: 'Troca do mecanismo de impressão',
      part: 'Cabeça Térmica de Impressão',
      equipment: 'Balança Etiquetadora Filizola',
      client: 'Maria',
      city: 'Curitiba - PR',
      assignee: 'Carlos (Técnico)',
      date: DateTime(2026, 8, 6, 16, 45),
      status: 'Concluída',
      report:
          'Cabeça de impressão antiga estava com falha nos pixels. Substituição e teste concluídos.',
      createdAt: DateTime(2026, 8, 2, 11, 5),
    ),

    ServiceOrder(
      id: '9',
      name: 'Reparo na fonte de alimentação',
      part: 'Bateria 6V 4.5Ah e Fusível 2A',
      equipment: 'Balança Pediátrica',
      client: 'Felipe',
      city: 'Rio de Janeiro - RJ',
      assignee: 'Roberto (Técnico)',
      date: DateTime(2026, 8, 2, 11, 20),
      status: 'Concluída',
      report:
          'Bateria viciada trocada e fusível rompido substituído. Calibração mantida.',
      createdAt: DateTime(2026, 8, 3, 8, 50),
    ),

    ServiceOrder(
      id: '10',
      name: 'Recabeamento de módulo',
      part: 'Cabo blindado 4 vias (15m)',
      equipment: 'Balança Rodoviária 80t',
      client: 'Arthur',
      city: 'Porto Alegre - RS',
      assignee: 'Ana (Especialista)',
      date: DateTime(2026, 8, 7, 8, 0),
      status: 'Cancelada',
      report: 'Cliente optou por não realizar o serviço no momento.',
      createdAt: DateTime(2026, 8, 5, 13, 30),
      isDeleted: true,
    ),
  ];

  Future<List<ServiceOrder>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final activeOrders = _serviceOrders
        .where((order) => !order.isDeleted)
        .toList();

    activeOrders.sort((a, b) {
      final dateA = a.createdAt;
      final dateB = b.createdAt;

      if (dateA == null && dateB == null) {
        return 0;
      }

      if (dateA == null) {
        return 1;
      }

      if (dateB == null) {
        return -1;
      }

      return dateB.compareTo(dateA);
    });

    return List.unmodifiable(activeOrders);
  }

  Future<void> save(ServiceOrder order) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newOrder = ServiceOrder(
      id: _generateId(),
      name: order.name,
      part: order.part,
      equipment: order.equipment,
      client: order.client,
      assignee: order.assignee,
      date: order.date,
      status: order.status,
      report: order.report,
      city: order.city,
      createdAt: order.createdAt ?? DateTime.now(),
      isDeleted: false,
    );

    _serviceOrders.add(newOrder);
  }

  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _serviceOrders.indexWhere((order) => order.id == id);

    if (index == -1) {
      return;
    }

    _serviceOrders[index].isDeleted = true;
  }

  Future<void> restore(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _serviceOrders.indexWhere((order) => order.id == id);

    if (index == -1) {
      return;
    }

    _serviceOrders[index].isDeleted = false;
  }

  String _generateId() {
    return '${DateTime.now().microsecondsSinceEpoch}-${_serviceOrders.length}';
  }
}