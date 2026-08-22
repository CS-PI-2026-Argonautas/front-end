import 'package:frontend/models/os.dart';
import 'package:frontend/repositories/os_repository.dart';

class MockOsRepository implements OsRepository {

  static final MockOsRepository _instance = MockOsRepository._internal();

  MockOsRepository._internal();

  factory MockOsRepository() => _instance;
final List<OrdemServicos> _bd = [
    OrdemServicos(
      id:1,
      nome: 'Calibração e aferição anual',
      peca: 'Lacre Inmetro',
      equipamento: 'Balança Comercial Toledo Prix 3 Plus',
      cliente: 'Giovanna',
      cidade: 'PResidente Prudente - SP',
      responsavel: 'Carlos (Técnico)',
      data: DateTime(2026, 8, 1, 9, 30),
      statusOdemDeServico: 'Concluída',
      relatorio: 'Equipamento calibrado e selado conforme exigências do Inmetro.',
      criadoEm: DateTime(2026, 7, 28, 10, 0),
    ),
    OrdemServicos(
      id: 13,
      nome: 'Substituição de célula de carga',
      peca: 'Célula de carga Zemic 500kg',
      equipamento: 'Balança Industrial de Plataforma',
      cliente: 'Murilo',
      cidade: 'Campinas - SP', 
      responsavel: 'Roberto (Técnico)',
      data: DateTime(2026, 8, 5, 14, 0),
      statusOdemDeServico: 'Em Andamento',
      relatorio: 'Peça instalada. Aguardando colocação dos pesos padrão para ajuste fino de tara.',
      criadoEm: DateTime(2026, 7, 30, 9, 15),
    ),
    OrdemServicos(
      id: 12,
      nome: 'Limpeza interna e desoxidação',
      peca: 'Nenhuma',
      equipamento: 'Balança Analítica de Precisão',
      cliente: 'Isaque',
      cidade: 'Belo Horizonte - BH',
      responsavel: 'Ana (Especialista)',
      data: DateTime(2026, 8, 7, 10, 15),
      statusOdemDeServico: 'Em Andamento',
      relatorio: 'Visor apresentando oscilação na leitura de gramatura. Equipamento na fila para triagem.',
      criadoEm: DateTime(2026, 8, 1, 16, 40),
    ),
    OrdemServicos(
      id:3,
      nome: 'Troca do mecanismo de impressão',
      peca: 'Cabeça Térmica de Impressão',
      equipamento: 'Balança Etiquetadora Filizola',
      cliente: 'Maria',
      cidade: 'Curitiba - PR',
      responsavel: 'Carlos (Técnico)',
      data: DateTime(2026, 8, 6, 16, 45),
      statusOdemDeServico: 'Concluída',
      relatorio: 'Cabeça de impressão antiga estava com falha nos pixels. Substituição e teste concluídos.',
      criadoEm: DateTime(2026, 8, 2, 11, 5),
    ),
    OrdemServicos(
      id: 9,
      nome: 'Reparo na fonte de alimentação',
      peca: 'Bateria 6V 4.5Ah e Fusível 2A',
      equipamento: 'Balança Pediátrica',
      cliente: 'Felipe',
      cidade: 'Rio de Janeiro - RJ',
      responsavel: 'Roberto (Técnico)',
      data: DateTime(2026, 8, 2, 11, 20),
      statusOdemDeServico: 'Concluída',
      relatorio: 'Bateria viciada trocada e fusível rompido substituído. Calibração mantida.',
      criadoEm: DateTime(2026, 8, 3, 8, 50),
    ),
    OrdemServicos(
      id: 10,
      nome: 'Recabeamento de módulo',
      peca: 'Cabo blindado 4 vias (15m)',
      equipamento: 'Balança Rodoviária 80t',
      cliente: 'Arthur',
      cidade: 'Porto Alegre - RS', 
      responsavel: 'Ana (Especialista)',
      data: DateTime(2026, 8, 7, 8, 0),
      statusOdemDeServico: 'Cancelada',
      relatorio: 'Cliente optou por não realizar o serviço no momento.',
      criadoEm: DateTime(2026, 8, 5, 13, 30),
      removido: true,
    ),
  ];

  @override
  Future<List<OrdemServicos>> listarTodos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_bd.where((os) => !os.removido).toList()..sort((a,b)=>b.criadoEm.compareTo(a.criadoEm)));
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
