import 'package:drift/drift.dart';
import 'package:frontend/Enums/StatusOrdemServico.dart';
import 'package:frontend/Enums/TiposItens.dart';
import 'package:frontend/Enums/Turno.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
part 'database.g.dart';

class Endereco extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cep => text()();
  TextColumn get rua => text()();
  TextColumn get complemento => text()();
  TextColumn get cidade => text()();
  TextColumn get numero => text()();
  TextColumn get uf => text()();
}

class Pessoa extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get telefone => text()();
  IntColumn get enderecoId => integer().references(Endereco, #id)();
}

class Funcionario extends Table {
  IntColumn get pessoaId => integer().references(Pessoa, #id)();
  TextColumn get cpf => text()();
  TextColumn get turno => textEnum<Turno>()();
  IntColumn get cargoId => integer().references(Cargo, #id)();

  @override
  Set<Column> get primaryKey => {pessoaId};
}

class Cargo extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  RealColumn get salario => real()();
}

class PessoaJuridica extends Table {
  // cria uma chave estrangeira que referencia o id da tabela Cliente
  IntColumn get clienteId => integer().references(Cliente, #pessoaId)();
  TextColumn get cnpj => text()();
  TextColumn get setor => text()();

  // define clienteId como a chave primária desta tabela.
  @override
  Set<Column> get primaryKey => {clienteId};
}

class PessoaFisica extends Table {
  IntColumn get clienteId => integer().references(Cliente, #pessoaId)();
  TextColumn get cpf => text()();

  @override
  Set<Column> get primaryKey => {clienteId};
}

class Cliente extends Table {
  IntColumn get pessoaId => integer().references(Pessoa, #id)();
  TextColumn get email => text()();
  TextColumn get obs => text()();

  @override
  Set<Column> get primaryKey => {pessoaId};
}

class Peca extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get descricao => text()();
  TextColumn get tipo => textEnum<TipoProduto>()();
  RealColumn get valor => real()();

  //nullable permite que uma peça exista sem a OS
  IntColumn get ordemServicoId =>
      integer().references(OrdemServicos, #id).nullable()();
}

class Servico extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get descricao => text()();
  RealColumn get valor => real()();
}

class Equipamento extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get marca => text()();
  TextColumn get modelo => text()();
  TextColumn get numeroSerie => text()();
  TextColumn get portaria => text()();
  TextColumn get numeroInmetro => text()();
  TextColumn get numeroVerificacao => text()();
  TextColumn get seloAnterior => text()();
  TextColumn get seloAtual => text()();
  TextColumn get lacreAnterior => text()();
  TextColumn get lacreAtual => text()();
}

class OrdemServicoServico extends Table {
  IntColumn get ordemServicoId => integer().references(OrdemServicos, #id)();
  IntColumn get servicoId => integer().references(Servico, #id)();

  @override
  Set<Column> get primaryKey => {ordemServicoId, servicoId};
}

class OrdemServicos extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get data => dateTime()();
  TextColumn get relatorio => text()();
  TextColumn get status => textEnum<Statusordemservico>()();
  IntColumn get responsavelId => integer().references(Funcionario, #pessoaId)();
  IntColumn get equipamentoId => integer().references(Equipamento, #id)();
  IntColumn get clienteId => integer().references(Cliente, #pessoaId)();
}

@DriftDatabase(
  tables: [
    Endereco,
    Pessoa,
    Funcionario,
    Cargo,
    PessoaJuridica,
    PessoaFisica,
    Cliente,
    Peca,
    Servico,
    Equipamento,
    OrdemServicoServico,
    OrdemServicos,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'argonautas_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}

//sempre que houver alguma mudança nessa tabela rodar o comando: dart run build_runner build
