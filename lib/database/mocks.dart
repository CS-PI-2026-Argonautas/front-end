import 'package:drift/drift.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/Enums/StatusOrdemServico.dart';
import 'package:frontend/Enums/TiposItens.dart';
import 'package:frontend/Enums/Turno.dart';

Future<void> inserirDadosMock(AppDatabase db) async {
  await db.transaction(() async {
    //comentarios são meus n é de ia
    //mocks da tabela Endereco
    final endereco1 = await db.into(db.endereco).insert(
      EnderecoCompanion.insert(
        cep: '87701-000',
        rua: 'Rua Paraná',
        complemento: 'Casa',
        cidade: 'Paranavaí',
        numero: '100',
        uf: 'PR',
      ),
    );

    final endereco2 = await db.into(db.endereco).insert(
      EnderecoCompanion.insert(
        cep: '87702-000',
        rua: 'Avenida Brasil',
        complemento: 'Sala 2',
        cidade: 'Paranavaí',
        numero: '250',
        uf: 'PR',
      ),
    );

    // mocks da tabela Pessoa
    final pessoa1 = await db.into(db.pessoa).insert(
      PessoaCompanion.insert(
        nome: 'João da Silva',
        telefone: '(44) 99999-1111',
        enderecoId: endereco1,
      ),
    );

    final pessoa2 = await db.into(db.pessoa).insert(
      PessoaCompanion.insert(
        nome: 'Maria Oliveira',
        telefone: '(44) 99999-2222',
        enderecoId: endereco2,
      ),
    );

    // mocks da tabela Cargo
    final cargo = await db.into(db.cargo).insert(
      CargoCompanion.insert(
        nome: 'Técnico',
        salario: 3500.00,
      ),
    );

    //mocks da tabela Funcionario
    await db.into(db.funcionario).insert(
      FuncionarioCompanion.insert(
        pessoaId: Value(pessoa1),
        cpf: '12345678900',
        turno: Turno.DIURNO,
        cargoId: cargo,
      ),
    );

    //mocks da tabela Cliente
    await db.into(db.cliente).insert(
      ClienteCompanion.insert(
        pessoaId: Value(pessoa2),
        email: 'maria@email.com',
        obs: 'Cliente de teste',
      ),
    );

    // mocks tabela PessoaFisica
    await db.into(db.pessoaFisica).insert(
      PessoaFisicaCompanion.insert(
        clienteId: Value(pessoa2),
        cpf: '98765432100',
      ),
    );

    // mocks da tabela Equipamento
    final equipamento1 = await db.into(db.equipamento).insert(
      EquipamentoCompanion.insert(
        marca: 'Toledo',
        modelo: 'Prix 3',
        numeroSerie: 'BAL001',
        portaria: 'Portaria 236/94',
        numeroInmetro: 'INM001',
        numeroVerificacao: 'VER001',
        seloAnterior: 'SEL001',
        seloAtual: 'SEL002',
        lacreAnterior: 'LAC001',
        lacreAtual: 'LAC002',
      ),
    );

    final equipamento2 = await db.into(db.equipamento).insert(
      EquipamentoCompanion.insert(
        marca: 'Filizola',
        modelo: 'CS-15',
        numeroSerie: 'BAL002',
        portaria: 'Portaria 236/94',
        numeroInmetro: 'INM002',
        numeroVerificacao: 'VER002',
        seloAnterior: 'SEL003',
        seloAtual: 'SEL004',
        lacreAnterior: 'LAC003',
        lacreAtual: 'LAC004',
      ),
    );

    // mocks da tabela Servico
    final servico1 = await db.into(db.servico).insert(
      ServicoCompanion.insert(
        nome: 'Calibração',
        descricao: 'Calibração de balança',
        valor: 150.00,
      ),
    );

    final servico2 = await db.into(db.servico).insert(
      ServicoCompanion.insert(
        nome: 'Manutenção',
        descricao: 'Manutenção preventiva de balança',
        valor: 200.00,
      ),
    );

    // mocks da tabela OrdemServicos
    final ordem1 = await db.into(db.ordemServicos).insert(
      OrdemServicosCompanion.insert(
        data: DateTime(2026, 8, 28),
        relatorio: 'Balança necessita de calibração.',
        status: Statusordemservico.EM_ORCAMENTO,
        responsavelId: pessoa1,
        equipamentoId: equipamento1,
        clienteId: pessoa2,
      ),
    );

    final ordem2 = await db.into(db.ordemServicos).insert(
      OrdemServicosCompanion.insert(
        data: DateTime(2026, 8, 27),
        relatorio: 'Realizada manutenção preventiva.',
        status: Statusordemservico.CONCLUIDA,
        responsavelId: pessoa1,
        equipamentoId: equipamento2,
        clienteId: pessoa2,
      ),
    );

    // mocks da tabela Peca
    await db.into(db.peca).insert(
      PecaCompanion.insert(
        nome: 'Célula de carga',
        descricao: 'Célula de carga para balança',
        tipo: TipoProduto.pecas,
        valor: 250.00,
        ordemServicoId: Value(ordem1),
      ),
    );

    await db.into(db.peca).insert(
      PecaCompanion.insert(
        nome: 'Placa eletrônica',
        descricao: 'Placa eletrônica para balança',
        tipo: TipoProduto.pecas,
        valor: 450.00,
        ordemServicoId: Value(ordem2),
      ),
    );

    // mocks da tabela OrdemServicoServico
    await db.into(db.ordemServicoServico).insert(
      OrdemServicoServicoCompanion.insert(
        ordemServicoId: ordem1,
        servicoId: servico1,
      ),
    );

    await db.into(db.ordemServicoServico).insert(
      OrdemServicoServicoCompanion.insert(
        ordemServicoId: ordem2,
        servicoId: servico2,
      ),
    );
  });
}