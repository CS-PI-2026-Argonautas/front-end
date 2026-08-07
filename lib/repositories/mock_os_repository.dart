import 'package:frontend/models/os.dart';
import 'package:frontend/repositories/os_repository.dart';

class MockOsRepository implements OsRepository {

  static final MockOsRepository _instance = MockOsRepository._internal();

  MockOsRepository._internal();

  factory MockOsRepository() => _instance;

final List<OrdemServicos> _bd = [
    OrdemServicos(
      nome: 'Calibração e aferição anual',
      peca: 'Lacre Inmetro',
      equipamento: 'Balança Comercial Toledo Prix 3 Plus',
      cliente: 'Giovanna',
      responsavel: 'Carlos (Técnico)',
      data: DateTime(2026, 8, 1, 9, 30),
      statusOdemDeServico: 'Concluída',
      relatorio: 'Equipamento calibrado e selado conforme exigências do Inmetro.',
    ),
    OrdemServicos(
      nome: 'Substituição de célula de carga',
      peca: 'Célula de carga Zemic 500kg',
      equipamento: 'Balança Industrial de Plataforma',
      cliente: 'Murilo',
      responsavel: 'Roberto (Técnico)',
      data: DateTime(2026, 8, 5, 14, 0),
      statusOdemDeServico: 'Em Andamento',
      relatorio: 'Peça instalada. Aguardando colocação dos pesos padrão para ajuste fino de tara.',
    ),
    OrdemServicos(
      nome: 'Limpeza interna e desoxidação',
      peca: 'Nenhuma',
      equipamento: 'Balança Analítica de Precisão',
      cliente: 'Isaque',
      responsavel: 'Ana (Especialista)',
      data: DateTime(2026, 8, 7, 10, 15),
      statusOdemDeServico: 'Pendente',
      relatorio: 'Visor apresentando oscilação na leitura de gramatura. Equipamento na fila para triagem.',
    ),
    OrdemServicos(
      nome: 'Troca do mecanismo de impressão',
      peca: 'Cabeça Térmica de Impressão',
      equipamento: 'Balança Etiquetadora Filizola',
      cliente: 'Maria',
      responsavel: 'Carlos (Técnico)',
      data: DateTime(2026, 8, 6, 16, 45),
      statusOdemDeServico: 'Concluída',
      relatorio: 'Cabeça de impressão antiga estava com falha nos pixels. Substituição e teste concluídos.',
    ),
    OrdemServicos(
      nome: 'Reparo na fonte de alimentação',
      peca: 'Bateria 6V 4.5Ah e Fusível 2A',
      equipamento: 'Balança Pediátrica',
      cliente: 'Felipe',
      responsavel: 'Roberto (Técnico)',
      data: DateTime(2026, 8, 2, 11, 20),
      statusOdemDeServico: 'Concluída',
      relatorio: 'Bateria viciada trocada e fusível rompido substituído. Calibração mantida.',
    ),
    OrdemServicos(
      nome: 'Recabeamento de módulo',
      peca: 'Cabo blindado 4 vias (15m)',
      equipamento: 'Balança Rodoviária 80t',
      cliente: 'Arthur',
      responsavel: 'Ana (Especialista)',
      data: DateTime(2026, 8, 7, 8, 0),
      statusOdemDeServico: 'Cancelada',
      relatorio: 'Cliente optou por não realizar o serviço no momento.',
      removido: true,
    ),
  ];

  @override
  Future<List<OrdemServicos>> listarTodos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_bd.where((cliente) => !cliente.removido));
  }

  @override
  Future<void> salvar(OrdemServicos os) async {
    await Future.delayed(const Duration(milliseconds: 300));
    os.id = _bd.length + 1;
    _bd.add(os);
  }

  @override
  Future<void> deletar(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _bd.remove(id);
  }
}
