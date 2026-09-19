// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EnderecoTable extends Endereco
    with TableInfo<$EnderecoTable, EnderecoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnderecoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cepMeta = const VerificationMeta('cep');
  @override
  late final GeneratedColumn<String> cep = GeneratedColumn<String>(
    'cep',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ruaMeta = const VerificationMeta('rua');
  @override
  late final GeneratedColumn<String> rua = GeneratedColumn<String>(
    'rua',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _complementoMeta = const VerificationMeta(
    'complemento',
  );
  @override
  late final GeneratedColumn<String> complemento = GeneratedColumn<String>(
    'complemento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cidadeMeta = const VerificationMeta('cidade');
  @override
  late final GeneratedColumn<String> cidade = GeneratedColumn<String>(
    'cidade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ufMeta = const VerificationMeta('uf');
  @override
  late final GeneratedColumn<String> uf = GeneratedColumn<String>(
    'uf',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cep,
    rua,
    complemento,
    cidade,
    numero,
    uf,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'endereco';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnderecoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cep')) {
      context.handle(
        _cepMeta,
        cep.isAcceptableOrUnknown(data['cep']!, _cepMeta),
      );
    } else if (isInserting) {
      context.missing(_cepMeta);
    }
    if (data.containsKey('rua')) {
      context.handle(
        _ruaMeta,
        rua.isAcceptableOrUnknown(data['rua']!, _ruaMeta),
      );
    } else if (isInserting) {
      context.missing(_ruaMeta);
    }
    if (data.containsKey('complemento')) {
      context.handle(
        _complementoMeta,
        complemento.isAcceptableOrUnknown(
          data['complemento']!,
          _complementoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_complementoMeta);
    }
    if (data.containsKey('cidade')) {
      context.handle(
        _cidadeMeta,
        cidade.isAcceptableOrUnknown(data['cidade']!, _cidadeMeta),
      );
    } else if (isInserting) {
      context.missing(_cidadeMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('uf')) {
      context.handle(_ufMeta, uf.isAcceptableOrUnknown(data['uf']!, _ufMeta));
    } else if (isInserting) {
      context.missing(_ufMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnderecoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnderecoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cep: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cep'],
      )!,
      rua: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rua'],
      )!,
      complemento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}complemento'],
      )!,
      cidade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cidade'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero'],
      )!,
      uf: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uf'],
      )!,
    );
  }

  @override
  $EnderecoTable createAlias(String alias) {
    return $EnderecoTable(attachedDatabase, alias);
  }
}

class EnderecoData extends DataClass implements Insertable<EnderecoData> {
  final int id;
  final String cep;
  final String rua;
  final String complemento;
  final String cidade;
  final String numero;
  final String uf;
  const EnderecoData({
    required this.id,
    required this.cep,
    required this.rua,
    required this.complemento,
    required this.cidade,
    required this.numero,
    required this.uf,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cep'] = Variable<String>(cep);
    map['rua'] = Variable<String>(rua);
    map['complemento'] = Variable<String>(complemento);
    map['cidade'] = Variable<String>(cidade);
    map['numero'] = Variable<String>(numero);
    map['uf'] = Variable<String>(uf);
    return map;
  }

  EnderecoCompanion toCompanion(bool nullToAbsent) {
    return EnderecoCompanion(
      id: Value(id),
      cep: Value(cep),
      rua: Value(rua),
      complemento: Value(complemento),
      cidade: Value(cidade),
      numero: Value(numero),
      uf: Value(uf),
    );
  }

  factory EnderecoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnderecoData(
      id: serializer.fromJson<int>(json['id']),
      cep: serializer.fromJson<String>(json['cep']),
      rua: serializer.fromJson<String>(json['rua']),
      complemento: serializer.fromJson<String>(json['complemento']),
      cidade: serializer.fromJson<String>(json['cidade']),
      numero: serializer.fromJson<String>(json['numero']),
      uf: serializer.fromJson<String>(json['uf']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cep': serializer.toJson<String>(cep),
      'rua': serializer.toJson<String>(rua),
      'complemento': serializer.toJson<String>(complemento),
      'cidade': serializer.toJson<String>(cidade),
      'numero': serializer.toJson<String>(numero),
      'uf': serializer.toJson<String>(uf),
    };
  }

  EnderecoData copyWith({
    int? id,
    String? cep,
    String? rua,
    String? complemento,
    String? cidade,
    String? numero,
    String? uf,
  }) => EnderecoData(
    id: id ?? this.id,
    cep: cep ?? this.cep,
    rua: rua ?? this.rua,
    complemento: complemento ?? this.complemento,
    cidade: cidade ?? this.cidade,
    numero: numero ?? this.numero,
    uf: uf ?? this.uf,
  );
  EnderecoData copyWithCompanion(EnderecoCompanion data) {
    return EnderecoData(
      id: data.id.present ? data.id.value : this.id,
      cep: data.cep.present ? data.cep.value : this.cep,
      rua: data.rua.present ? data.rua.value : this.rua,
      complemento: data.complemento.present
          ? data.complemento.value
          : this.complemento,
      cidade: data.cidade.present ? data.cidade.value : this.cidade,
      numero: data.numero.present ? data.numero.value : this.numero,
      uf: data.uf.present ? data.uf.value : this.uf,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnderecoData(')
          ..write('id: $id, ')
          ..write('cep: $cep, ')
          ..write('rua: $rua, ')
          ..write('complemento: $complemento, ')
          ..write('cidade: $cidade, ')
          ..write('numero: $numero, ')
          ..write('uf: $uf')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cep, rua, complemento, cidade, numero, uf);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnderecoData &&
          other.id == this.id &&
          other.cep == this.cep &&
          other.rua == this.rua &&
          other.complemento == this.complemento &&
          other.cidade == this.cidade &&
          other.numero == this.numero &&
          other.uf == this.uf);
}

class EnderecoCompanion extends UpdateCompanion<EnderecoData> {
  final Value<int> id;
  final Value<String> cep;
  final Value<String> rua;
  final Value<String> complemento;
  final Value<String> cidade;
  final Value<String> numero;
  final Value<String> uf;
  const EnderecoCompanion({
    this.id = const Value.absent(),
    this.cep = const Value.absent(),
    this.rua = const Value.absent(),
    this.complemento = const Value.absent(),
    this.cidade = const Value.absent(),
    this.numero = const Value.absent(),
    this.uf = const Value.absent(),
  });
  EnderecoCompanion.insert({
    this.id = const Value.absent(),
    required String cep,
    required String rua,
    required String complemento,
    required String cidade,
    required String numero,
    required String uf,
  }) : cep = Value(cep),
       rua = Value(rua),
       complemento = Value(complemento),
       cidade = Value(cidade),
       numero = Value(numero),
       uf = Value(uf);
  static Insertable<EnderecoData> custom({
    Expression<int>? id,
    Expression<String>? cep,
    Expression<String>? rua,
    Expression<String>? complemento,
    Expression<String>? cidade,
    Expression<String>? numero,
    Expression<String>? uf,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cep != null) 'cep': cep,
      if (rua != null) 'rua': rua,
      if (complemento != null) 'complemento': complemento,
      if (cidade != null) 'cidade': cidade,
      if (numero != null) 'numero': numero,
      if (uf != null) 'uf': uf,
    });
  }

  EnderecoCompanion copyWith({
    Value<int>? id,
    Value<String>? cep,
    Value<String>? rua,
    Value<String>? complemento,
    Value<String>? cidade,
    Value<String>? numero,
    Value<String>? uf,
  }) {
    return EnderecoCompanion(
      id: id ?? this.id,
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      complemento: complemento ?? this.complemento,
      cidade: cidade ?? this.cidade,
      numero: numero ?? this.numero,
      uf: uf ?? this.uf,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cep.present) {
      map['cep'] = Variable<String>(cep.value);
    }
    if (rua.present) {
      map['rua'] = Variable<String>(rua.value);
    }
    if (complemento.present) {
      map['complemento'] = Variable<String>(complemento.value);
    }
    if (cidade.present) {
      map['cidade'] = Variable<String>(cidade.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (uf.present) {
      map['uf'] = Variable<String>(uf.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnderecoCompanion(')
          ..write('id: $id, ')
          ..write('cep: $cep, ')
          ..write('rua: $rua, ')
          ..write('complemento: $complemento, ')
          ..write('cidade: $cidade, ')
          ..write('numero: $numero, ')
          ..write('uf: $uf')
          ..write(')'))
        .toString();
  }
}

class $PessoaTable extends Pessoa with TableInfo<$PessoaTable, PessoaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PessoaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefoneMeta = const VerificationMeta(
    'telefone',
  );
  @override
  late final GeneratedColumn<String> telefone = GeneratedColumn<String>(
    'telefone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enderecoIdMeta = const VerificationMeta(
    'enderecoId',
  );
  @override
  late final GeneratedColumn<int> enderecoId = GeneratedColumn<int>(
    'endereco_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES endereco (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, telefone, enderecoId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pessoa';
  @override
  VerificationContext validateIntegrity(
    Insertable<PessoaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('telefone')) {
      context.handle(
        _telefoneMeta,
        telefone.isAcceptableOrUnknown(data['telefone']!, _telefoneMeta),
      );
    } else if (isInserting) {
      context.missing(_telefoneMeta);
    }
    if (data.containsKey('endereco_id')) {
      context.handle(
        _enderecoIdMeta,
        enderecoId.isAcceptableOrUnknown(data['endereco_id']!, _enderecoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_enderecoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PessoaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PessoaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      telefone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefone'],
      )!,
      enderecoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}endereco_id'],
      )!,
    );
  }

  @override
  $PessoaTable createAlias(String alias) {
    return $PessoaTable(attachedDatabase, alias);
  }
}

class PessoaData extends DataClass implements Insertable<PessoaData> {
  final int id;
  final String nome;
  final String telefone;
  final int enderecoId;
  const PessoaData({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.enderecoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['telefone'] = Variable<String>(telefone);
    map['endereco_id'] = Variable<int>(enderecoId);
    return map;
  }

  PessoaCompanion toCompanion(bool nullToAbsent) {
    return PessoaCompanion(
      id: Value(id),
      nome: Value(nome),
      telefone: Value(telefone),
      enderecoId: Value(enderecoId),
    );
  }

  factory PessoaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PessoaData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      telefone: serializer.fromJson<String>(json['telefone']),
      enderecoId: serializer.fromJson<int>(json['enderecoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'telefone': serializer.toJson<String>(telefone),
      'enderecoId': serializer.toJson<int>(enderecoId),
    };
  }

  PessoaData copyWith({
    int? id,
    String? nome,
    String? telefone,
    int? enderecoId,
  }) => PessoaData(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    telefone: telefone ?? this.telefone,
    enderecoId: enderecoId ?? this.enderecoId,
  );
  PessoaData copyWithCompanion(PessoaCompanion data) {
    return PessoaData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      telefone: data.telefone.present ? data.telefone.value : this.telefone,
      enderecoId: data.enderecoId.present
          ? data.enderecoId.value
          : this.enderecoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PessoaData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('telefone: $telefone, ')
          ..write('enderecoId: $enderecoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, telefone, enderecoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PessoaData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.telefone == this.telefone &&
          other.enderecoId == this.enderecoId);
}

class PessoaCompanion extends UpdateCompanion<PessoaData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> telefone;
  final Value<int> enderecoId;
  const PessoaCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.telefone = const Value.absent(),
    this.enderecoId = const Value.absent(),
  });
  PessoaCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String telefone,
    required int enderecoId,
  }) : nome = Value(nome),
       telefone = Value(telefone),
       enderecoId = Value(enderecoId);
  static Insertable<PessoaData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? telefone,
    Expression<int>? enderecoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (telefone != null) 'telefone': telefone,
      if (enderecoId != null) 'endereco_id': enderecoId,
    });
  }

  PessoaCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? telefone,
    Value<int>? enderecoId,
  }) {
    return PessoaCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      enderecoId: enderecoId ?? this.enderecoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (telefone.present) {
      map['telefone'] = Variable<String>(telefone.value);
    }
    if (enderecoId.present) {
      map['endereco_id'] = Variable<int>(enderecoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PessoaCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('telefone: $telefone, ')
          ..write('enderecoId: $enderecoId')
          ..write(')'))
        .toString();
  }
}

class $CargoTable extends Cargo with TableInfo<$CargoTable, CargoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CargoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salarioMeta = const VerificationMeta(
    'salario',
  );
  @override
  late final GeneratedColumn<double> salario = GeneratedColumn<double>(
    'salario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, salario];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cargo';
  @override
  VerificationContext validateIntegrity(
    Insertable<CargoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('salario')) {
      context.handle(
        _salarioMeta,
        salario.isAcceptableOrUnknown(data['salario']!, _salarioMeta),
      );
    } else if (isInserting) {
      context.missing(_salarioMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CargoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CargoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      salario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salario'],
      )!,
    );
  }

  @override
  $CargoTable createAlias(String alias) {
    return $CargoTable(attachedDatabase, alias);
  }
}

class CargoData extends DataClass implements Insertable<CargoData> {
  final int id;
  final String nome;
  final double salario;
  const CargoData({
    required this.id,
    required this.nome,
    required this.salario,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['salario'] = Variable<double>(salario);
    return map;
  }

  CargoCompanion toCompanion(bool nullToAbsent) {
    return CargoCompanion(
      id: Value(id),
      nome: Value(nome),
      salario: Value(salario),
    );
  }

  factory CargoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CargoData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      salario: serializer.fromJson<double>(json['salario']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'salario': serializer.toJson<double>(salario),
    };
  }

  CargoData copyWith({int? id, String? nome, double? salario}) => CargoData(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    salario: salario ?? this.salario,
  );
  CargoData copyWithCompanion(CargoCompanion data) {
    return CargoData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      salario: data.salario.present ? data.salario.value : this.salario,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CargoData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('salario: $salario')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, salario);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CargoData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.salario == this.salario);
}

class CargoCompanion extends UpdateCompanion<CargoData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<double> salario;
  const CargoCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.salario = const Value.absent(),
  });
  CargoCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required double salario,
  }) : nome = Value(nome),
       salario = Value(salario);
  static Insertable<CargoData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<double>? salario,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (salario != null) 'salario': salario,
    });
  }

  CargoCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<double>? salario,
  }) {
    return CargoCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      salario: salario ?? this.salario,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (salario.present) {
      map['salario'] = Variable<double>(salario.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CargoCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('salario: $salario')
          ..write(')'))
        .toString();
  }
}

class $FuncionarioTable extends Funcionario
    with TableInfo<$FuncionarioTable, FuncionarioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuncionarioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pessoaIdMeta = const VerificationMeta(
    'pessoaId',
  );
  @override
  late final GeneratedColumn<int> pessoaId = GeneratedColumn<int>(
    'pessoa_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pessoa (id)',
    ),
  );
  static const VerificationMeta _cpfMeta = const VerificationMeta('cpf');
  @override
  late final GeneratedColumn<String> cpf = GeneratedColumn<String>(
    'cpf',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Turno, String> turno =
      GeneratedColumn<String>(
        'turno',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Turno>($FuncionarioTable.$converterturno);
  static const VerificationMeta _cargoIdMeta = const VerificationMeta(
    'cargoId',
  );
  @override
  late final GeneratedColumn<int> cargoId = GeneratedColumn<int>(
    'cargo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cargo (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [pessoaId, cpf, turno, cargoId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'funcionario';
  @override
  VerificationContext validateIntegrity(
    Insertable<FuncionarioData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pessoa_id')) {
      context.handle(
        _pessoaIdMeta,
        pessoaId.isAcceptableOrUnknown(data['pessoa_id']!, _pessoaIdMeta),
      );
    }
    if (data.containsKey('cpf')) {
      context.handle(
        _cpfMeta,
        cpf.isAcceptableOrUnknown(data['cpf']!, _cpfMeta),
      );
    } else if (isInserting) {
      context.missing(_cpfMeta);
    }
    if (data.containsKey('cargo_id')) {
      context.handle(
        _cargoIdMeta,
        cargoId.isAcceptableOrUnknown(data['cargo_id']!, _cargoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cargoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pessoaId};
  @override
  FuncionarioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuncionarioData(
      pessoaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pessoa_id'],
      )!,
      cpf: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cpf'],
      )!,
      turno: $FuncionarioTable.$converterturno.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}turno'],
        )!,
      ),
      cargoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cargo_id'],
      )!,
    );
  }

  @override
  $FuncionarioTable createAlias(String alias) {
    return $FuncionarioTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Turno, String, String> $converterturno =
      const EnumNameConverter<Turno>(Turno.values);
}

class FuncionarioData extends DataClass implements Insertable<FuncionarioData> {
  final int pessoaId;
  final String cpf;
  final Turno turno;
  final int cargoId;
  const FuncionarioData({
    required this.pessoaId,
    required this.cpf,
    required this.turno,
    required this.cargoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pessoa_id'] = Variable<int>(pessoaId);
    map['cpf'] = Variable<String>(cpf);
    {
      map['turno'] = Variable<String>(
        $FuncionarioTable.$converterturno.toSql(turno),
      );
    }
    map['cargo_id'] = Variable<int>(cargoId);
    return map;
  }

  FuncionarioCompanion toCompanion(bool nullToAbsent) {
    return FuncionarioCompanion(
      pessoaId: Value(pessoaId),
      cpf: Value(cpf),
      turno: Value(turno),
      cargoId: Value(cargoId),
    );
  }

  factory FuncionarioData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuncionarioData(
      pessoaId: serializer.fromJson<int>(json['pessoaId']),
      cpf: serializer.fromJson<String>(json['cpf']),
      turno: $FuncionarioTable.$converterturno.fromJson(
        serializer.fromJson<String>(json['turno']),
      ),
      cargoId: serializer.fromJson<int>(json['cargoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pessoaId': serializer.toJson<int>(pessoaId),
      'cpf': serializer.toJson<String>(cpf),
      'turno': serializer.toJson<String>(
        $FuncionarioTable.$converterturno.toJson(turno),
      ),
      'cargoId': serializer.toJson<int>(cargoId),
    };
  }

  FuncionarioData copyWith({
    int? pessoaId,
    String? cpf,
    Turno? turno,
    int? cargoId,
  }) => FuncionarioData(
    pessoaId: pessoaId ?? this.pessoaId,
    cpf: cpf ?? this.cpf,
    turno: turno ?? this.turno,
    cargoId: cargoId ?? this.cargoId,
  );
  FuncionarioData copyWithCompanion(FuncionarioCompanion data) {
    return FuncionarioData(
      pessoaId: data.pessoaId.present ? data.pessoaId.value : this.pessoaId,
      cpf: data.cpf.present ? data.cpf.value : this.cpf,
      turno: data.turno.present ? data.turno.value : this.turno,
      cargoId: data.cargoId.present ? data.cargoId.value : this.cargoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuncionarioData(')
          ..write('pessoaId: $pessoaId, ')
          ..write('cpf: $cpf, ')
          ..write('turno: $turno, ')
          ..write('cargoId: $cargoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pessoaId, cpf, turno, cargoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuncionarioData &&
          other.pessoaId == this.pessoaId &&
          other.cpf == this.cpf &&
          other.turno == this.turno &&
          other.cargoId == this.cargoId);
}

class FuncionarioCompanion extends UpdateCompanion<FuncionarioData> {
  final Value<int> pessoaId;
  final Value<String> cpf;
  final Value<Turno> turno;
  final Value<int> cargoId;
  const FuncionarioCompanion({
    this.pessoaId = const Value.absent(),
    this.cpf = const Value.absent(),
    this.turno = const Value.absent(),
    this.cargoId = const Value.absent(),
  });
  FuncionarioCompanion.insert({
    this.pessoaId = const Value.absent(),
    required String cpf,
    required Turno turno,
    required int cargoId,
  }) : cpf = Value(cpf),
       turno = Value(turno),
       cargoId = Value(cargoId);
  static Insertable<FuncionarioData> custom({
    Expression<int>? pessoaId,
    Expression<String>? cpf,
    Expression<String>? turno,
    Expression<int>? cargoId,
  }) {
    return RawValuesInsertable({
      if (pessoaId != null) 'pessoa_id': pessoaId,
      if (cpf != null) 'cpf': cpf,
      if (turno != null) 'turno': turno,
      if (cargoId != null) 'cargo_id': cargoId,
    });
  }

  FuncionarioCompanion copyWith({
    Value<int>? pessoaId,
    Value<String>? cpf,
    Value<Turno>? turno,
    Value<int>? cargoId,
  }) {
    return FuncionarioCompanion(
      pessoaId: pessoaId ?? this.pessoaId,
      cpf: cpf ?? this.cpf,
      turno: turno ?? this.turno,
      cargoId: cargoId ?? this.cargoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pessoaId.present) {
      map['pessoa_id'] = Variable<int>(pessoaId.value);
    }
    if (cpf.present) {
      map['cpf'] = Variable<String>(cpf.value);
    }
    if (turno.present) {
      map['turno'] = Variable<String>(
        $FuncionarioTable.$converterturno.toSql(turno.value),
      );
    }
    if (cargoId.present) {
      map['cargo_id'] = Variable<int>(cargoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuncionarioCompanion(')
          ..write('pessoaId: $pessoaId, ')
          ..write('cpf: $cpf, ')
          ..write('turno: $turno, ')
          ..write('cargoId: $cargoId')
          ..write(')'))
        .toString();
  }
}

class $ClienteTable extends Cliente with TableInfo<$ClienteTable, ClienteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClienteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pessoaIdMeta = const VerificationMeta(
    'pessoaId',
  );
  @override
  late final GeneratedColumn<int> pessoaId = GeneratedColumn<int>(
    'pessoa_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pessoa (id)',
    ),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _obsMeta = const VerificationMeta('obs');
  @override
  late final GeneratedColumn<String> obs = GeneratedColumn<String>(
    'obs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [pessoaId, email, obs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cliente';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClienteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pessoa_id')) {
      context.handle(
        _pessoaIdMeta,
        pessoaId.isAcceptableOrUnknown(data['pessoa_id']!, _pessoaIdMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('obs')) {
      context.handle(
        _obsMeta,
        obs.isAcceptableOrUnknown(data['obs']!, _obsMeta),
      );
    } else if (isInserting) {
      context.missing(_obsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pessoaId};
  @override
  ClienteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClienteData(
      pessoaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pessoa_id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      obs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}obs'],
      )!,
    );
  }

  @override
  $ClienteTable createAlias(String alias) {
    return $ClienteTable(attachedDatabase, alias);
  }
}

class ClienteData extends DataClass implements Insertable<ClienteData> {
  final int pessoaId;
  final String email;
  final String obs;
  const ClienteData({
    required this.pessoaId,
    required this.email,
    required this.obs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pessoa_id'] = Variable<int>(pessoaId);
    map['email'] = Variable<String>(email);
    map['obs'] = Variable<String>(obs);
    return map;
  }

  ClienteCompanion toCompanion(bool nullToAbsent) {
    return ClienteCompanion(
      pessoaId: Value(pessoaId),
      email: Value(email),
      obs: Value(obs),
    );
  }

  factory ClienteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClienteData(
      pessoaId: serializer.fromJson<int>(json['pessoaId']),
      email: serializer.fromJson<String>(json['email']),
      obs: serializer.fromJson<String>(json['obs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pessoaId': serializer.toJson<int>(pessoaId),
      'email': serializer.toJson<String>(email),
      'obs': serializer.toJson<String>(obs),
    };
  }

  ClienteData copyWith({int? pessoaId, String? email, String? obs}) =>
      ClienteData(
        pessoaId: pessoaId ?? this.pessoaId,
        email: email ?? this.email,
        obs: obs ?? this.obs,
      );
  ClienteData copyWithCompanion(ClienteCompanion data) {
    return ClienteData(
      pessoaId: data.pessoaId.present ? data.pessoaId.value : this.pessoaId,
      email: data.email.present ? data.email.value : this.email,
      obs: data.obs.present ? data.obs.value : this.obs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteData(')
          ..write('pessoaId: $pessoaId, ')
          ..write('email: $email, ')
          ..write('obs: $obs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pessoaId, email, obs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteData &&
          other.pessoaId == this.pessoaId &&
          other.email == this.email &&
          other.obs == this.obs);
}

class ClienteCompanion extends UpdateCompanion<ClienteData> {
  final Value<int> pessoaId;
  final Value<String> email;
  final Value<String> obs;
  const ClienteCompanion({
    this.pessoaId = const Value.absent(),
    this.email = const Value.absent(),
    this.obs = const Value.absent(),
  });
  ClienteCompanion.insert({
    this.pessoaId = const Value.absent(),
    required String email,
    required String obs,
  }) : email = Value(email),
       obs = Value(obs);
  static Insertable<ClienteData> custom({
    Expression<int>? pessoaId,
    Expression<String>? email,
    Expression<String>? obs,
  }) {
    return RawValuesInsertable({
      if (pessoaId != null) 'pessoa_id': pessoaId,
      if (email != null) 'email': email,
      if (obs != null) 'obs': obs,
    });
  }

  ClienteCompanion copyWith({
    Value<int>? pessoaId,
    Value<String>? email,
    Value<String>? obs,
  }) {
    return ClienteCompanion(
      pessoaId: pessoaId ?? this.pessoaId,
      email: email ?? this.email,
      obs: obs ?? this.obs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pessoaId.present) {
      map['pessoa_id'] = Variable<int>(pessoaId.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (obs.present) {
      map['obs'] = Variable<String>(obs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClienteCompanion(')
          ..write('pessoaId: $pessoaId, ')
          ..write('email: $email, ')
          ..write('obs: $obs')
          ..write(')'))
        .toString();
  }
}

class $PessoaJuridicaTable extends PessoaJuridica
    with TableInfo<$PessoaJuridicaTable, PessoaJuridicaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PessoaJuridicaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cliente (pessoa_id)',
    ),
  );
  static const VerificationMeta _cnpjMeta = const VerificationMeta('cnpj');
  @override
  late final GeneratedColumn<String> cnpj = GeneratedColumn<String>(
    'cnpj',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setorMeta = const VerificationMeta('setor');
  @override
  late final GeneratedColumn<String> setor = GeneratedColumn<String>(
    'setor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [clienteId, cnpj, setor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pessoa_juridica';
  @override
  VerificationContext validateIntegrity(
    Insertable<PessoaJuridicaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    }
    if (data.containsKey('cnpj')) {
      context.handle(
        _cnpjMeta,
        cnpj.isAcceptableOrUnknown(data['cnpj']!, _cnpjMeta),
      );
    } else if (isInserting) {
      context.missing(_cnpjMeta);
    }
    if (data.containsKey('setor')) {
      context.handle(
        _setorMeta,
        setor.isAcceptableOrUnknown(data['setor']!, _setorMeta),
      );
    } else if (isInserting) {
      context.missing(_setorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clienteId};
  @override
  PessoaJuridicaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PessoaJuridicaData(
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      cnpj: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cnpj'],
      )!,
      setor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setor'],
      )!,
    );
  }

  @override
  $PessoaJuridicaTable createAlias(String alias) {
    return $PessoaJuridicaTable(attachedDatabase, alias);
  }
}

class PessoaJuridicaData extends DataClass
    implements Insertable<PessoaJuridicaData> {
  final int clienteId;
  final String cnpj;
  final String setor;
  const PessoaJuridicaData({
    required this.clienteId,
    required this.cnpj,
    required this.setor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cliente_id'] = Variable<int>(clienteId);
    map['cnpj'] = Variable<String>(cnpj);
    map['setor'] = Variable<String>(setor);
    return map;
  }

  PessoaJuridicaCompanion toCompanion(bool nullToAbsent) {
    return PessoaJuridicaCompanion(
      clienteId: Value(clienteId),
      cnpj: Value(cnpj),
      setor: Value(setor),
    );
  }

  factory PessoaJuridicaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PessoaJuridicaData(
      clienteId: serializer.fromJson<int>(json['clienteId']),
      cnpj: serializer.fromJson<String>(json['cnpj']),
      setor: serializer.fromJson<String>(json['setor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clienteId': serializer.toJson<int>(clienteId),
      'cnpj': serializer.toJson<String>(cnpj),
      'setor': serializer.toJson<String>(setor),
    };
  }

  PessoaJuridicaData copyWith({int? clienteId, String? cnpj, String? setor}) =>
      PessoaJuridicaData(
        clienteId: clienteId ?? this.clienteId,
        cnpj: cnpj ?? this.cnpj,
        setor: setor ?? this.setor,
      );
  PessoaJuridicaData copyWithCompanion(PessoaJuridicaCompanion data) {
    return PessoaJuridicaData(
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      cnpj: data.cnpj.present ? data.cnpj.value : this.cnpj,
      setor: data.setor.present ? data.setor.value : this.setor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PessoaJuridicaData(')
          ..write('clienteId: $clienteId, ')
          ..write('cnpj: $cnpj, ')
          ..write('setor: $setor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(clienteId, cnpj, setor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PessoaJuridicaData &&
          other.clienteId == this.clienteId &&
          other.cnpj == this.cnpj &&
          other.setor == this.setor);
}

class PessoaJuridicaCompanion extends UpdateCompanion<PessoaJuridicaData> {
  final Value<int> clienteId;
  final Value<String> cnpj;
  final Value<String> setor;
  const PessoaJuridicaCompanion({
    this.clienteId = const Value.absent(),
    this.cnpj = const Value.absent(),
    this.setor = const Value.absent(),
  });
  PessoaJuridicaCompanion.insert({
    this.clienteId = const Value.absent(),
    required String cnpj,
    required String setor,
  }) : cnpj = Value(cnpj),
       setor = Value(setor);
  static Insertable<PessoaJuridicaData> custom({
    Expression<int>? clienteId,
    Expression<String>? cnpj,
    Expression<String>? setor,
  }) {
    return RawValuesInsertable({
      if (clienteId != null) 'cliente_id': clienteId,
      if (cnpj != null) 'cnpj': cnpj,
      if (setor != null) 'setor': setor,
    });
  }

  PessoaJuridicaCompanion copyWith({
    Value<int>? clienteId,
    Value<String>? cnpj,
    Value<String>? setor,
  }) {
    return PessoaJuridicaCompanion(
      clienteId: clienteId ?? this.clienteId,
      cnpj: cnpj ?? this.cnpj,
      setor: setor ?? this.setor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (cnpj.present) {
      map['cnpj'] = Variable<String>(cnpj.value);
    }
    if (setor.present) {
      map['setor'] = Variable<String>(setor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PessoaJuridicaCompanion(')
          ..write('clienteId: $clienteId, ')
          ..write('cnpj: $cnpj, ')
          ..write('setor: $setor')
          ..write(')'))
        .toString();
  }
}

class $PessoaFisicaTable extends PessoaFisica
    with TableInfo<$PessoaFisicaTable, PessoaFisicaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PessoaFisicaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cliente (pessoa_id)',
    ),
  );
  static const VerificationMeta _cpfMeta = const VerificationMeta('cpf');
  @override
  late final GeneratedColumn<String> cpf = GeneratedColumn<String>(
    'cpf',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [clienteId, cpf];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pessoa_fisica';
  @override
  VerificationContext validateIntegrity(
    Insertable<PessoaFisicaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    }
    if (data.containsKey('cpf')) {
      context.handle(
        _cpfMeta,
        cpf.isAcceptableOrUnknown(data['cpf']!, _cpfMeta),
      );
    } else if (isInserting) {
      context.missing(_cpfMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clienteId};
  @override
  PessoaFisicaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PessoaFisicaData(
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      cpf: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cpf'],
      )!,
    );
  }

  @override
  $PessoaFisicaTable createAlias(String alias) {
    return $PessoaFisicaTable(attachedDatabase, alias);
  }
}

class PessoaFisicaData extends DataClass
    implements Insertable<PessoaFisicaData> {
  final int clienteId;
  final String cpf;
  const PessoaFisicaData({required this.clienteId, required this.cpf});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cliente_id'] = Variable<int>(clienteId);
    map['cpf'] = Variable<String>(cpf);
    return map;
  }

  PessoaFisicaCompanion toCompanion(bool nullToAbsent) {
    return PessoaFisicaCompanion(clienteId: Value(clienteId), cpf: Value(cpf));
  }

  factory PessoaFisicaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PessoaFisicaData(
      clienteId: serializer.fromJson<int>(json['clienteId']),
      cpf: serializer.fromJson<String>(json['cpf']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clienteId': serializer.toJson<int>(clienteId),
      'cpf': serializer.toJson<String>(cpf),
    };
  }

  PessoaFisicaData copyWith({int? clienteId, String? cpf}) => PessoaFisicaData(
    clienteId: clienteId ?? this.clienteId,
    cpf: cpf ?? this.cpf,
  );
  PessoaFisicaData copyWithCompanion(PessoaFisicaCompanion data) {
    return PessoaFisicaData(
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      cpf: data.cpf.present ? data.cpf.value : this.cpf,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PessoaFisicaData(')
          ..write('clienteId: $clienteId, ')
          ..write('cpf: $cpf')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(clienteId, cpf);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PessoaFisicaData &&
          other.clienteId == this.clienteId &&
          other.cpf == this.cpf);
}

class PessoaFisicaCompanion extends UpdateCompanion<PessoaFisicaData> {
  final Value<int> clienteId;
  final Value<String> cpf;
  const PessoaFisicaCompanion({
    this.clienteId = const Value.absent(),
    this.cpf = const Value.absent(),
  });
  PessoaFisicaCompanion.insert({
    this.clienteId = const Value.absent(),
    required String cpf,
  }) : cpf = Value(cpf);
  static Insertable<PessoaFisicaData> custom({
    Expression<int>? clienteId,
    Expression<String>? cpf,
  }) {
    return RawValuesInsertable({
      if (clienteId != null) 'cliente_id': clienteId,
      if (cpf != null) 'cpf': cpf,
    });
  }

  PessoaFisicaCompanion copyWith({Value<int>? clienteId, Value<String>? cpf}) {
    return PessoaFisicaCompanion(
      clienteId: clienteId ?? this.clienteId,
      cpf: cpf ?? this.cpf,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (cpf.present) {
      map['cpf'] = Variable<String>(cpf.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PessoaFisicaCompanion(')
          ..write('clienteId: $clienteId, ')
          ..write('cpf: $cpf')
          ..write(')'))
        .toString();
  }
}

class $EquipamentoTable extends Equipamento
    with TableInfo<$EquipamentoTable, EquipamentoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipamentoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
    'modelo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroSerieMeta = const VerificationMeta(
    'numeroSerie',
  );
  @override
  late final GeneratedColumn<String> numeroSerie = GeneratedColumn<String>(
    'numero_serie',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portariaMeta = const VerificationMeta(
    'portaria',
  );
  @override
  late final GeneratedColumn<String> portaria = GeneratedColumn<String>(
    'portaria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroInmetroMeta = const VerificationMeta(
    'numeroInmetro',
  );
  @override
  late final GeneratedColumn<String> numeroInmetro = GeneratedColumn<String>(
    'numero_inmetro',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroVerificacaoMeta = const VerificationMeta(
    'numeroVerificacao',
  );
  @override
  late final GeneratedColumn<String> numeroVerificacao =
      GeneratedColumn<String>(
        'numero_verificacao',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _seloAnteriorMeta = const VerificationMeta(
    'seloAnterior',
  );
  @override
  late final GeneratedColumn<String> seloAnterior = GeneratedColumn<String>(
    'selo_anterior',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seloAtualMeta = const VerificationMeta(
    'seloAtual',
  );
  @override
  late final GeneratedColumn<String> seloAtual = GeneratedColumn<String>(
    'selo_atual',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lacreAnteriorMeta = const VerificationMeta(
    'lacreAnterior',
  );
  @override
  late final GeneratedColumn<String> lacreAnterior = GeneratedColumn<String>(
    'lacre_anterior',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lacreAtualMeta = const VerificationMeta(
    'lacreAtual',
  );
  @override
  late final GeneratedColumn<String> lacreAtual = GeneratedColumn<String>(
    'lacre_atual',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    marca,
    modelo,
    numeroSerie,
    portaria,
    numeroInmetro,
    numeroVerificacao,
    seloAnterior,
    seloAtual,
    lacreAnterior,
    lacreAtual,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipamento';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipamentoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(
        _modeloMeta,
        modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta),
      );
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('numero_serie')) {
      context.handle(
        _numeroSerieMeta,
        numeroSerie.isAcceptableOrUnknown(
          data['numero_serie']!,
          _numeroSerieMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroSerieMeta);
    }
    if (data.containsKey('portaria')) {
      context.handle(
        _portariaMeta,
        portaria.isAcceptableOrUnknown(data['portaria']!, _portariaMeta),
      );
    } else if (isInserting) {
      context.missing(_portariaMeta);
    }
    if (data.containsKey('numero_inmetro')) {
      context.handle(
        _numeroInmetroMeta,
        numeroInmetro.isAcceptableOrUnknown(
          data['numero_inmetro']!,
          _numeroInmetroMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroInmetroMeta);
    }
    if (data.containsKey('numero_verificacao')) {
      context.handle(
        _numeroVerificacaoMeta,
        numeroVerificacao.isAcceptableOrUnknown(
          data['numero_verificacao']!,
          _numeroVerificacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroVerificacaoMeta);
    }
    if (data.containsKey('selo_anterior')) {
      context.handle(
        _seloAnteriorMeta,
        seloAnterior.isAcceptableOrUnknown(
          data['selo_anterior']!,
          _seloAnteriorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_seloAnteriorMeta);
    }
    if (data.containsKey('selo_atual')) {
      context.handle(
        _seloAtualMeta,
        seloAtual.isAcceptableOrUnknown(data['selo_atual']!, _seloAtualMeta),
      );
    } else if (isInserting) {
      context.missing(_seloAtualMeta);
    }
    if (data.containsKey('lacre_anterior')) {
      context.handle(
        _lacreAnteriorMeta,
        lacreAnterior.isAcceptableOrUnknown(
          data['lacre_anterior']!,
          _lacreAnteriorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lacreAnteriorMeta);
    }
    if (data.containsKey('lacre_atual')) {
      context.handle(
        _lacreAtualMeta,
        lacreAtual.isAcceptableOrUnknown(data['lacre_atual']!, _lacreAtualMeta),
      );
    } else if (isInserting) {
      context.missing(_lacreAtualMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipamentoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipamentoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      )!,
      modelo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modelo'],
      )!,
      numeroSerie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_serie'],
      )!,
      portaria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portaria'],
      )!,
      numeroInmetro: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_inmetro'],
      )!,
      numeroVerificacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_verificacao'],
      )!,
      seloAnterior: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selo_anterior'],
      )!,
      seloAtual: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selo_atual'],
      )!,
      lacreAnterior: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lacre_anterior'],
      )!,
      lacreAtual: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lacre_atual'],
      )!,
    );
  }

  @override
  $EquipamentoTable createAlias(String alias) {
    return $EquipamentoTable(attachedDatabase, alias);
  }
}

class EquipamentoData extends DataClass implements Insertable<EquipamentoData> {
  final int id;
  final String marca;
  final String modelo;
  final String numeroSerie;
  final String portaria;
  final String numeroInmetro;
  final String numeroVerificacao;
  final String seloAnterior;
  final String seloAtual;
  final String lacreAnterior;
  final String lacreAtual;
  const EquipamentoData({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    required this.portaria,
    required this.numeroInmetro,
    required this.numeroVerificacao,
    required this.seloAnterior,
    required this.seloAtual,
    required this.lacreAnterior,
    required this.lacreAtual,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['marca'] = Variable<String>(marca);
    map['modelo'] = Variable<String>(modelo);
    map['numero_serie'] = Variable<String>(numeroSerie);
    map['portaria'] = Variable<String>(portaria);
    map['numero_inmetro'] = Variable<String>(numeroInmetro);
    map['numero_verificacao'] = Variable<String>(numeroVerificacao);
    map['selo_anterior'] = Variable<String>(seloAnterior);
    map['selo_atual'] = Variable<String>(seloAtual);
    map['lacre_anterior'] = Variable<String>(lacreAnterior);
    map['lacre_atual'] = Variable<String>(lacreAtual);
    return map;
  }

  EquipamentoCompanion toCompanion(bool nullToAbsent) {
    return EquipamentoCompanion(
      id: Value(id),
      marca: Value(marca),
      modelo: Value(modelo),
      numeroSerie: Value(numeroSerie),
      portaria: Value(portaria),
      numeroInmetro: Value(numeroInmetro),
      numeroVerificacao: Value(numeroVerificacao),
      seloAnterior: Value(seloAnterior),
      seloAtual: Value(seloAtual),
      lacreAnterior: Value(lacreAnterior),
      lacreAtual: Value(lacreAtual),
    );
  }

  factory EquipamentoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipamentoData(
      id: serializer.fromJson<int>(json['id']),
      marca: serializer.fromJson<String>(json['marca']),
      modelo: serializer.fromJson<String>(json['modelo']),
      numeroSerie: serializer.fromJson<String>(json['numeroSerie']),
      portaria: serializer.fromJson<String>(json['portaria']),
      numeroInmetro: serializer.fromJson<String>(json['numeroInmetro']),
      numeroVerificacao: serializer.fromJson<String>(json['numeroVerificacao']),
      seloAnterior: serializer.fromJson<String>(json['seloAnterior']),
      seloAtual: serializer.fromJson<String>(json['seloAtual']),
      lacreAnterior: serializer.fromJson<String>(json['lacreAnterior']),
      lacreAtual: serializer.fromJson<String>(json['lacreAtual']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'marca': serializer.toJson<String>(marca),
      'modelo': serializer.toJson<String>(modelo),
      'numeroSerie': serializer.toJson<String>(numeroSerie),
      'portaria': serializer.toJson<String>(portaria),
      'numeroInmetro': serializer.toJson<String>(numeroInmetro),
      'numeroVerificacao': serializer.toJson<String>(numeroVerificacao),
      'seloAnterior': serializer.toJson<String>(seloAnterior),
      'seloAtual': serializer.toJson<String>(seloAtual),
      'lacreAnterior': serializer.toJson<String>(lacreAnterior),
      'lacreAtual': serializer.toJson<String>(lacreAtual),
    };
  }

  EquipamentoData copyWith({
    int? id,
    String? marca,
    String? modelo,
    String? numeroSerie,
    String? portaria,
    String? numeroInmetro,
    String? numeroVerificacao,
    String? seloAnterior,
    String? seloAtual,
    String? lacreAnterior,
    String? lacreAtual,
  }) => EquipamentoData(
    id: id ?? this.id,
    marca: marca ?? this.marca,
    modelo: modelo ?? this.modelo,
    numeroSerie: numeroSerie ?? this.numeroSerie,
    portaria: portaria ?? this.portaria,
    numeroInmetro: numeroInmetro ?? this.numeroInmetro,
    numeroVerificacao: numeroVerificacao ?? this.numeroVerificacao,
    seloAnterior: seloAnterior ?? this.seloAnterior,
    seloAtual: seloAtual ?? this.seloAtual,
    lacreAnterior: lacreAnterior ?? this.lacreAnterior,
    lacreAtual: lacreAtual ?? this.lacreAtual,
  );
  EquipamentoData copyWithCompanion(EquipamentoCompanion data) {
    return EquipamentoData(
      id: data.id.present ? data.id.value : this.id,
      marca: data.marca.present ? data.marca.value : this.marca,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      numeroSerie: data.numeroSerie.present
          ? data.numeroSerie.value
          : this.numeroSerie,
      portaria: data.portaria.present ? data.portaria.value : this.portaria,
      numeroInmetro: data.numeroInmetro.present
          ? data.numeroInmetro.value
          : this.numeroInmetro,
      numeroVerificacao: data.numeroVerificacao.present
          ? data.numeroVerificacao.value
          : this.numeroVerificacao,
      seloAnterior: data.seloAnterior.present
          ? data.seloAnterior.value
          : this.seloAnterior,
      seloAtual: data.seloAtual.present ? data.seloAtual.value : this.seloAtual,
      lacreAnterior: data.lacreAnterior.present
          ? data.lacreAnterior.value
          : this.lacreAnterior,
      lacreAtual: data.lacreAtual.present
          ? data.lacreAtual.value
          : this.lacreAtual,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipamentoData(')
          ..write('id: $id, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('numeroSerie: $numeroSerie, ')
          ..write('portaria: $portaria, ')
          ..write('numeroInmetro: $numeroInmetro, ')
          ..write('numeroVerificacao: $numeroVerificacao, ')
          ..write('seloAnterior: $seloAnterior, ')
          ..write('seloAtual: $seloAtual, ')
          ..write('lacreAnterior: $lacreAnterior, ')
          ..write('lacreAtual: $lacreAtual')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    marca,
    modelo,
    numeroSerie,
    portaria,
    numeroInmetro,
    numeroVerificacao,
    seloAnterior,
    seloAtual,
    lacreAnterior,
    lacreAtual,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipamentoData &&
          other.id == this.id &&
          other.marca == this.marca &&
          other.modelo == this.modelo &&
          other.numeroSerie == this.numeroSerie &&
          other.portaria == this.portaria &&
          other.numeroInmetro == this.numeroInmetro &&
          other.numeroVerificacao == this.numeroVerificacao &&
          other.seloAnterior == this.seloAnterior &&
          other.seloAtual == this.seloAtual &&
          other.lacreAnterior == this.lacreAnterior &&
          other.lacreAtual == this.lacreAtual);
}

class EquipamentoCompanion extends UpdateCompanion<EquipamentoData> {
  final Value<int> id;
  final Value<String> marca;
  final Value<String> modelo;
  final Value<String> numeroSerie;
  final Value<String> portaria;
  final Value<String> numeroInmetro;
  final Value<String> numeroVerificacao;
  final Value<String> seloAnterior;
  final Value<String> seloAtual;
  final Value<String> lacreAnterior;
  final Value<String> lacreAtual;
  const EquipamentoCompanion({
    this.id = const Value.absent(),
    this.marca = const Value.absent(),
    this.modelo = const Value.absent(),
    this.numeroSerie = const Value.absent(),
    this.portaria = const Value.absent(),
    this.numeroInmetro = const Value.absent(),
    this.numeroVerificacao = const Value.absent(),
    this.seloAnterior = const Value.absent(),
    this.seloAtual = const Value.absent(),
    this.lacreAnterior = const Value.absent(),
    this.lacreAtual = const Value.absent(),
  });
  EquipamentoCompanion.insert({
    this.id = const Value.absent(),
    required String marca,
    required String modelo,
    required String numeroSerie,
    required String portaria,
    required String numeroInmetro,
    required String numeroVerificacao,
    required String seloAnterior,
    required String seloAtual,
    required String lacreAnterior,
    required String lacreAtual,
  }) : marca = Value(marca),
       modelo = Value(modelo),
       numeroSerie = Value(numeroSerie),
       portaria = Value(portaria),
       numeroInmetro = Value(numeroInmetro),
       numeroVerificacao = Value(numeroVerificacao),
       seloAnterior = Value(seloAnterior),
       seloAtual = Value(seloAtual),
       lacreAnterior = Value(lacreAnterior),
       lacreAtual = Value(lacreAtual);
  static Insertable<EquipamentoData> custom({
    Expression<int>? id,
    Expression<String>? marca,
    Expression<String>? modelo,
    Expression<String>? numeroSerie,
    Expression<String>? portaria,
    Expression<String>? numeroInmetro,
    Expression<String>? numeroVerificacao,
    Expression<String>? seloAnterior,
    Expression<String>? seloAtual,
    Expression<String>? lacreAnterior,
    Expression<String>? lacreAtual,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (marca != null) 'marca': marca,
      if (modelo != null) 'modelo': modelo,
      if (numeroSerie != null) 'numero_serie': numeroSerie,
      if (portaria != null) 'portaria': portaria,
      if (numeroInmetro != null) 'numero_inmetro': numeroInmetro,
      if (numeroVerificacao != null) 'numero_verificacao': numeroVerificacao,
      if (seloAnterior != null) 'selo_anterior': seloAnterior,
      if (seloAtual != null) 'selo_atual': seloAtual,
      if (lacreAnterior != null) 'lacre_anterior': lacreAnterior,
      if (lacreAtual != null) 'lacre_atual': lacreAtual,
    });
  }

  EquipamentoCompanion copyWith({
    Value<int>? id,
    Value<String>? marca,
    Value<String>? modelo,
    Value<String>? numeroSerie,
    Value<String>? portaria,
    Value<String>? numeroInmetro,
    Value<String>? numeroVerificacao,
    Value<String>? seloAnterior,
    Value<String>? seloAtual,
    Value<String>? lacreAnterior,
    Value<String>? lacreAtual,
  }) {
    return EquipamentoCompanion(
      id: id ?? this.id,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      portaria: portaria ?? this.portaria,
      numeroInmetro: numeroInmetro ?? this.numeroInmetro,
      numeroVerificacao: numeroVerificacao ?? this.numeroVerificacao,
      seloAnterior: seloAnterior ?? this.seloAnterior,
      seloAtual: seloAtual ?? this.seloAtual,
      lacreAnterior: lacreAnterior ?? this.lacreAnterior,
      lacreAtual: lacreAtual ?? this.lacreAtual,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (numeroSerie.present) {
      map['numero_serie'] = Variable<String>(numeroSerie.value);
    }
    if (portaria.present) {
      map['portaria'] = Variable<String>(portaria.value);
    }
    if (numeroInmetro.present) {
      map['numero_inmetro'] = Variable<String>(numeroInmetro.value);
    }
    if (numeroVerificacao.present) {
      map['numero_verificacao'] = Variable<String>(numeroVerificacao.value);
    }
    if (seloAnterior.present) {
      map['selo_anterior'] = Variable<String>(seloAnterior.value);
    }
    if (seloAtual.present) {
      map['selo_atual'] = Variable<String>(seloAtual.value);
    }
    if (lacreAnterior.present) {
      map['lacre_anterior'] = Variable<String>(lacreAnterior.value);
    }
    if (lacreAtual.present) {
      map['lacre_atual'] = Variable<String>(lacreAtual.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipamentoCompanion(')
          ..write('id: $id, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('numeroSerie: $numeroSerie, ')
          ..write('portaria: $portaria, ')
          ..write('numeroInmetro: $numeroInmetro, ')
          ..write('numeroVerificacao: $numeroVerificacao, ')
          ..write('seloAnterior: $seloAnterior, ')
          ..write('seloAtual: $seloAtual, ')
          ..write('lacreAnterior: $lacreAnterior, ')
          ..write('lacreAtual: $lacreAtual')
          ..write(')'))
        .toString();
  }
}

class $OrdemServicosTable extends OrdemServicos
    with TableInfo<$OrdemServicosTable, OrdemServico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdemServicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatorioMeta = const VerificationMeta(
    'relatorio',
  );
  @override
  late final GeneratedColumn<String> relatorio = GeneratedColumn<String>(
    'relatorio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Statusordemservico, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Statusordemservico>($OrdemServicosTable.$converterstatus);
  static const VerificationMeta _responsavelIdMeta = const VerificationMeta(
    'responsavelId',
  );
  @override
  late final GeneratedColumn<int> responsavelId = GeneratedColumn<int>(
    'responsavel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES funcionario (pessoa_id)',
    ),
  );
  static const VerificationMeta _equipamentoIdMeta = const VerificationMeta(
    'equipamentoId',
  );
  @override
  late final GeneratedColumn<int> equipamentoId = GeneratedColumn<int>(
    'equipamento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipamento (id)',
    ),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cliente (pessoa_id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    data,
    relatorio,
    status,
    responsavelId,
    equipamentoId,
    clienteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ordem_servicos';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrdemServico> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('relatorio')) {
      context.handle(
        _relatorioMeta,
        relatorio.isAcceptableOrUnknown(data['relatorio']!, _relatorioMeta),
      );
    } else if (isInserting) {
      context.missing(_relatorioMeta);
    }
    if (data.containsKey('responsavel_id')) {
      context.handle(
        _responsavelIdMeta,
        responsavelId.isAcceptableOrUnknown(
          data['responsavel_id']!,
          _responsavelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responsavelIdMeta);
    }
    if (data.containsKey('equipamento_id')) {
      context.handle(
        _equipamentoIdMeta,
        equipamentoId.isAcceptableOrUnknown(
          data['equipamento_id']!,
          _equipamentoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipamentoIdMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdemServico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdemServico(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
      relatorio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relatorio'],
      )!,
      status: $OrdemServicosTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      responsavelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}responsavel_id'],
      )!,
      equipamentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipamento_id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
    );
  }

  @override
  $OrdemServicosTable createAlias(String alias) {
    return $OrdemServicosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Statusordemservico, String, String>
  $converterstatus = const EnumNameConverter<Statusordemservico>(
    Statusordemservico.values,
  );
}

class OrdemServico extends DataClass implements Insertable<OrdemServico> {
  final int id;
  final DateTime data;
  final String relatorio;
  final Statusordemservico status;
  final int responsavelId;
  final int equipamentoId;
  final int clienteId;
  const OrdemServico({
    required this.id,
    required this.data,
    required this.relatorio,
    required this.status,
    required this.responsavelId,
    required this.equipamentoId,
    required this.clienteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data'] = Variable<DateTime>(data);
    map['relatorio'] = Variable<String>(relatorio);
    {
      map['status'] = Variable<String>(
        $OrdemServicosTable.$converterstatus.toSql(status),
      );
    }
    map['responsavel_id'] = Variable<int>(responsavelId);
    map['equipamento_id'] = Variable<int>(equipamentoId);
    map['cliente_id'] = Variable<int>(clienteId);
    return map;
  }

  OrdemServicosCompanion toCompanion(bool nullToAbsent) {
    return OrdemServicosCompanion(
      id: Value(id),
      data: Value(data),
      relatorio: Value(relatorio),
      status: Value(status),
      responsavelId: Value(responsavelId),
      equipamentoId: Value(equipamentoId),
      clienteId: Value(clienteId),
    );
  }

  factory OrdemServico.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdemServico(
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<DateTime>(json['data']),
      relatorio: serializer.fromJson<String>(json['relatorio']),
      status: $OrdemServicosTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      responsavelId: serializer.fromJson<int>(json['responsavelId']),
      equipamentoId: serializer.fromJson<int>(json['equipamentoId']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<DateTime>(data),
      'relatorio': serializer.toJson<String>(relatorio),
      'status': serializer.toJson<String>(
        $OrdemServicosTable.$converterstatus.toJson(status),
      ),
      'responsavelId': serializer.toJson<int>(responsavelId),
      'equipamentoId': serializer.toJson<int>(equipamentoId),
      'clienteId': serializer.toJson<int>(clienteId),
    };
  }

  OrdemServico copyWith({
    int? id,
    DateTime? data,
    String? relatorio,
    Statusordemservico? status,
    int? responsavelId,
    int? equipamentoId,
    int? clienteId,
  }) => OrdemServico(
    id: id ?? this.id,
    data: data ?? this.data,
    relatorio: relatorio ?? this.relatorio,
    status: status ?? this.status,
    responsavelId: responsavelId ?? this.responsavelId,
    equipamentoId: equipamentoId ?? this.equipamentoId,
    clienteId: clienteId ?? this.clienteId,
  );
  OrdemServico copyWithCompanion(OrdemServicosCompanion data) {
    return OrdemServico(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
      relatorio: data.relatorio.present ? data.relatorio.value : this.relatorio,
      status: data.status.present ? data.status.value : this.status,
      responsavelId: data.responsavelId.present
          ? data.responsavelId.value
          : this.responsavelId,
      equipamentoId: data.equipamentoId.present
          ? data.equipamentoId.value
          : this.equipamentoId,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdemServico(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('relatorio: $relatorio, ')
          ..write('status: $status, ')
          ..write('responsavelId: $responsavelId, ')
          ..write('equipamentoId: $equipamentoId, ')
          ..write('clienteId: $clienteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    data,
    relatorio,
    status,
    responsavelId,
    equipamentoId,
    clienteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdemServico &&
          other.id == this.id &&
          other.data == this.data &&
          other.relatorio == this.relatorio &&
          other.status == this.status &&
          other.responsavelId == this.responsavelId &&
          other.equipamentoId == this.equipamentoId &&
          other.clienteId == this.clienteId);
}

class OrdemServicosCompanion extends UpdateCompanion<OrdemServico> {
  final Value<int> id;
  final Value<DateTime> data;
  final Value<String> relatorio;
  final Value<Statusordemservico> status;
  final Value<int> responsavelId;
  final Value<int> equipamentoId;
  final Value<int> clienteId;
  const OrdemServicosCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.relatorio = const Value.absent(),
    this.status = const Value.absent(),
    this.responsavelId = const Value.absent(),
    this.equipamentoId = const Value.absent(),
    this.clienteId = const Value.absent(),
  });
  OrdemServicosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime data,
    required String relatorio,
    required Statusordemservico status,
    required int responsavelId,
    required int equipamentoId,
    required int clienteId,
  }) : data = Value(data),
       relatorio = Value(relatorio),
       status = Value(status),
       responsavelId = Value(responsavelId),
       equipamentoId = Value(equipamentoId),
       clienteId = Value(clienteId);
  static Insertable<OrdemServico> custom({
    Expression<int>? id,
    Expression<DateTime>? data,
    Expression<String>? relatorio,
    Expression<String>? status,
    Expression<int>? responsavelId,
    Expression<int>? equipamentoId,
    Expression<int>? clienteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (relatorio != null) 'relatorio': relatorio,
      if (status != null) 'status': status,
      if (responsavelId != null) 'responsavel_id': responsavelId,
      if (equipamentoId != null) 'equipamento_id': equipamentoId,
      if (clienteId != null) 'cliente_id': clienteId,
    });
  }

  OrdemServicosCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? data,
    Value<String>? relatorio,
    Value<Statusordemservico>? status,
    Value<int>? responsavelId,
    Value<int>? equipamentoId,
    Value<int>? clienteId,
  }) {
    return OrdemServicosCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      relatorio: relatorio ?? this.relatorio,
      status: status ?? this.status,
      responsavelId: responsavelId ?? this.responsavelId,
      equipamentoId: equipamentoId ?? this.equipamentoId,
      clienteId: clienteId ?? this.clienteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (relatorio.present) {
      map['relatorio'] = Variable<String>(relatorio.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $OrdemServicosTable.$converterstatus.toSql(status.value),
      );
    }
    if (responsavelId.present) {
      map['responsavel_id'] = Variable<int>(responsavelId.value);
    }
    if (equipamentoId.present) {
      map['equipamento_id'] = Variable<int>(equipamentoId.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdemServicosCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('relatorio: $relatorio, ')
          ..write('status: $status, ')
          ..write('responsavelId: $responsavelId, ')
          ..write('equipamentoId: $equipamentoId, ')
          ..write('clienteId: $clienteId')
          ..write(')'))
        .toString();
  }
}

class $PecaTable extends Peca with TableInfo<$PecaTable, PecaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PecaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoProduto, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoProduto>($PecaTable.$convertertipo);
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ordemServicoIdMeta = const VerificationMeta(
    'ordemServicoId',
  );
  @override
  late final GeneratedColumn<int> ordemServicoId = GeneratedColumn<int>(
    'ordem_servico_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordem_servicos (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    descricao,
    tipo,
    valor,
    ordemServicoId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'peca';
  @override
  VerificationContext validateIntegrity(
    Insertable<PecaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('ordem_servico_id')) {
      context.handle(
        _ordemServicoIdMeta,
        ordemServicoId.isAcceptableOrUnknown(
          data['ordem_servico_id']!,
          _ordemServicoIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PecaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PecaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      tipo: $PecaTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      )!,
      ordemServicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem_servico_id'],
      ),
    );
  }

  @override
  $PecaTable createAlias(String alias) {
    return $PecaTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoProduto, String, String> $convertertipo =
      const EnumNameConverter<TipoProduto>(TipoProduto.values);
}

class PecaData extends DataClass implements Insertable<PecaData> {
  final int id;
  final String nome;
  final String descricao;
  final TipoProduto tipo;
  final double valor;
  final int? ordemServicoId;
  const PecaData({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.valor,
    this.ordemServicoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['descricao'] = Variable<String>(descricao);
    {
      map['tipo'] = Variable<String>($PecaTable.$convertertipo.toSql(tipo));
    }
    map['valor'] = Variable<double>(valor);
    if (!nullToAbsent || ordemServicoId != null) {
      map['ordem_servico_id'] = Variable<int>(ordemServicoId);
    }
    return map;
  }

  PecaCompanion toCompanion(bool nullToAbsent) {
    return PecaCompanion(
      id: Value(id),
      nome: Value(nome),
      descricao: Value(descricao),
      tipo: Value(tipo),
      valor: Value(valor),
      ordemServicoId: ordemServicoId == null && nullToAbsent
          ? const Value.absent()
          : Value(ordemServicoId),
    );
  }

  factory PecaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PecaData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      descricao: serializer.fromJson<String>(json['descricao']),
      tipo: $PecaTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      valor: serializer.fromJson<double>(json['valor']),
      ordemServicoId: serializer.fromJson<int?>(json['ordemServicoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'descricao': serializer.toJson<String>(descricao),
      'tipo': serializer.toJson<String>($PecaTable.$convertertipo.toJson(tipo)),
      'valor': serializer.toJson<double>(valor),
      'ordemServicoId': serializer.toJson<int?>(ordemServicoId),
    };
  }

  PecaData copyWith({
    int? id,
    String? nome,
    String? descricao,
    TipoProduto? tipo,
    double? valor,
    Value<int?> ordemServicoId = const Value.absent(),
  }) => PecaData(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    descricao: descricao ?? this.descricao,
    tipo: tipo ?? this.tipo,
    valor: valor ?? this.valor,
    ordemServicoId: ordemServicoId.present
        ? ordemServicoId.value
        : this.ordemServicoId,
  );
  PecaData copyWithCompanion(PecaCompanion data) {
    return PecaData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      valor: data.valor.present ? data.valor.value : this.valor,
      ordemServicoId: data.ordemServicoId.present
          ? data.ordemServicoId.value
          : this.ordemServicoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PecaData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('tipo: $tipo, ')
          ..write('valor: $valor, ')
          ..write('ordemServicoId: $ordemServicoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nome, descricao, tipo, valor, ordemServicoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PecaData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.descricao == this.descricao &&
          other.tipo == this.tipo &&
          other.valor == this.valor &&
          other.ordemServicoId == this.ordemServicoId);
}

class PecaCompanion extends UpdateCompanion<PecaData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> descricao;
  final Value<TipoProduto> tipo;
  final Value<double> valor;
  final Value<int?> ordemServicoId;
  const PecaCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.descricao = const Value.absent(),
    this.tipo = const Value.absent(),
    this.valor = const Value.absent(),
    this.ordemServicoId = const Value.absent(),
  });
  PecaCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String descricao,
    required TipoProduto tipo,
    required double valor,
    this.ordemServicoId = const Value.absent(),
  }) : nome = Value(nome),
       descricao = Value(descricao),
       tipo = Value(tipo),
       valor = Value(valor);
  static Insertable<PecaData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? descricao,
    Expression<String>? tipo,
    Expression<double>? valor,
    Expression<int>? ordemServicoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (descricao != null) 'descricao': descricao,
      if (tipo != null) 'tipo': tipo,
      if (valor != null) 'valor': valor,
      if (ordemServicoId != null) 'ordem_servico_id': ordemServicoId,
    });
  }

  PecaCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? descricao,
    Value<TipoProduto>? tipo,
    Value<double>? valor,
    Value<int?>? ordemServicoId,
  }) {
    return PecaCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tipo: tipo ?? this.tipo,
      valor: valor ?? this.valor,
      ordemServicoId: ordemServicoId ?? this.ordemServicoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $PecaTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (ordemServicoId.present) {
      map['ordem_servico_id'] = Variable<int>(ordemServicoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PecaCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('tipo: $tipo, ')
          ..write('valor: $valor, ')
          ..write('ordemServicoId: $ordemServicoId')
          ..write(')'))
        .toString();
  }
}

class $ServicoTable extends Servico with TableInfo<$ServicoTable, ServicoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, descricao, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servico';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServicoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServicoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServicoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      )!,
    );
  }

  @override
  $ServicoTable createAlias(String alias) {
    return $ServicoTable(attachedDatabase, alias);
  }
}

class ServicoData extends DataClass implements Insertable<ServicoData> {
  final int id;
  final String nome;
  final String descricao;
  final double valor;
  const ServicoData({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.valor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['descricao'] = Variable<String>(descricao);
    map['valor'] = Variable<double>(valor);
    return map;
  }

  ServicoCompanion toCompanion(bool nullToAbsent) {
    return ServicoCompanion(
      id: Value(id),
      nome: Value(nome),
      descricao: Value(descricao),
      valor: Value(valor),
    );
  }

  factory ServicoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServicoData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      descricao: serializer.fromJson<String>(json['descricao']),
      valor: serializer.fromJson<double>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'descricao': serializer.toJson<String>(descricao),
      'valor': serializer.toJson<double>(valor),
    };
  }

  ServicoData copyWith({
    int? id,
    String? nome,
    String? descricao,
    double? valor,
  }) => ServicoData(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    descricao: descricao ?? this.descricao,
    valor: valor ?? this.valor,
  );
  ServicoData copyWithCompanion(ServicoCompanion data) {
    return ServicoData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServicoData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, descricao, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServicoData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.descricao == this.descricao &&
          other.valor == this.valor);
}

class ServicoCompanion extends UpdateCompanion<ServicoData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> descricao;
  final Value<double> valor;
  const ServicoCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.descricao = const Value.absent(),
    this.valor = const Value.absent(),
  });
  ServicoCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String descricao,
    required double valor,
  }) : nome = Value(nome),
       descricao = Value(descricao),
       valor = Value(valor);
  static Insertable<ServicoData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? descricao,
    Expression<double>? valor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (descricao != null) 'descricao': descricao,
      if (valor != null) 'valor': valor,
    });
  }

  ServicoCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? descricao,
    Value<double>? valor,
  }) {
    return ServicoCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicoCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }
}

class $OrdemServicoServicoTable extends OrdemServicoServico
    with TableInfo<$OrdemServicoServicoTable, OrdemServicoServicoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdemServicoServicoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ordemServicoIdMeta = const VerificationMeta(
    'ordemServicoId',
  );
  @override
  late final GeneratedColumn<int> ordemServicoId = GeneratedColumn<int>(
    'ordem_servico_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ordem_servicos (id)',
    ),
  );
  static const VerificationMeta _servicoIdMeta = const VerificationMeta(
    'servicoId',
  );
  @override
  late final GeneratedColumn<int> servicoId = GeneratedColumn<int>(
    'servico_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES servico (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [ordemServicoId, servicoId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ordem_servico_servico';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrdemServicoServicoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ordem_servico_id')) {
      context.handle(
        _ordemServicoIdMeta,
        ordemServicoId.isAcceptableOrUnknown(
          data['ordem_servico_id']!,
          _ordemServicoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ordemServicoIdMeta);
    }
    if (data.containsKey('servico_id')) {
      context.handle(
        _servicoIdMeta,
        servicoId.isAcceptableOrUnknown(data['servico_id']!, _servicoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_servicoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ordemServicoId, servicoId};
  @override
  OrdemServicoServicoData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdemServicoServicoData(
      ordemServicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem_servico_id'],
      )!,
      servicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servico_id'],
      )!,
    );
  }

  @override
  $OrdemServicoServicoTable createAlias(String alias) {
    return $OrdemServicoServicoTable(attachedDatabase, alias);
  }
}

class OrdemServicoServicoData extends DataClass
    implements Insertable<OrdemServicoServicoData> {
  final int ordemServicoId;
  final int servicoId;
  const OrdemServicoServicoData({
    required this.ordemServicoId,
    required this.servicoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ordem_servico_id'] = Variable<int>(ordemServicoId);
    map['servico_id'] = Variable<int>(servicoId);
    return map;
  }

  OrdemServicoServicoCompanion toCompanion(bool nullToAbsent) {
    return OrdemServicoServicoCompanion(
      ordemServicoId: Value(ordemServicoId),
      servicoId: Value(servicoId),
    );
  }

  factory OrdemServicoServicoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdemServicoServicoData(
      ordemServicoId: serializer.fromJson<int>(json['ordemServicoId']),
      servicoId: serializer.fromJson<int>(json['servicoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ordemServicoId': serializer.toJson<int>(ordemServicoId),
      'servicoId': serializer.toJson<int>(servicoId),
    };
  }

  OrdemServicoServicoData copyWith({int? ordemServicoId, int? servicoId}) =>
      OrdemServicoServicoData(
        ordemServicoId: ordemServicoId ?? this.ordemServicoId,
        servicoId: servicoId ?? this.servicoId,
      );
  OrdemServicoServicoData copyWithCompanion(OrdemServicoServicoCompanion data) {
    return OrdemServicoServicoData(
      ordemServicoId: data.ordemServicoId.present
          ? data.ordemServicoId.value
          : this.ordemServicoId,
      servicoId: data.servicoId.present ? data.servicoId.value : this.servicoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdemServicoServicoData(')
          ..write('ordemServicoId: $ordemServicoId, ')
          ..write('servicoId: $servicoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ordemServicoId, servicoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdemServicoServicoData &&
          other.ordemServicoId == this.ordemServicoId &&
          other.servicoId == this.servicoId);
}

class OrdemServicoServicoCompanion
    extends UpdateCompanion<OrdemServicoServicoData> {
  final Value<int> ordemServicoId;
  final Value<int> servicoId;
  final Value<int> rowid;
  const OrdemServicoServicoCompanion({
    this.ordemServicoId = const Value.absent(),
    this.servicoId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdemServicoServicoCompanion.insert({
    required int ordemServicoId,
    required int servicoId,
    this.rowid = const Value.absent(),
  }) : ordemServicoId = Value(ordemServicoId),
       servicoId = Value(servicoId);
  static Insertable<OrdemServicoServicoData> custom({
    Expression<int>? ordemServicoId,
    Expression<int>? servicoId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ordemServicoId != null) 'ordem_servico_id': ordemServicoId,
      if (servicoId != null) 'servico_id': servicoId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdemServicoServicoCompanion copyWith({
    Value<int>? ordemServicoId,
    Value<int>? servicoId,
    Value<int>? rowid,
  }) {
    return OrdemServicoServicoCompanion(
      ordemServicoId: ordemServicoId ?? this.ordemServicoId,
      servicoId: servicoId ?? this.servicoId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ordemServicoId.present) {
      map['ordem_servico_id'] = Variable<int>(ordemServicoId.value);
    }
    if (servicoId.present) {
      map['servico_id'] = Variable<int>(servicoId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdemServicoServicoCompanion(')
          ..write('ordemServicoId: $ordemServicoId, ')
          ..write('servicoId: $servicoId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EnderecoTable endereco = $EnderecoTable(this);
  late final $PessoaTable pessoa = $PessoaTable(this);
  late final $CargoTable cargo = $CargoTable(this);
  late final $FuncionarioTable funcionario = $FuncionarioTable(this);
  late final $ClienteTable cliente = $ClienteTable(this);
  late final $PessoaJuridicaTable pessoaJuridica = $PessoaJuridicaTable(this);
  late final $PessoaFisicaTable pessoaFisica = $PessoaFisicaTable(this);
  late final $EquipamentoTable equipamento = $EquipamentoTable(this);
  late final $OrdemServicosTable ordemServicos = $OrdemServicosTable(this);
  late final $PecaTable peca = $PecaTable(this);
  late final $ServicoTable servico = $ServicoTable(this);
  late final $OrdemServicoServicoTable ordemServicoServico =
      $OrdemServicoServicoTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    endereco,
    pessoa,
    cargo,
    funcionario,
    cliente,
    pessoaJuridica,
    pessoaFisica,
    equipamento,
    ordemServicos,
    peca,
    servico,
    ordemServicoServico,
  ];
}

typedef $$EnderecoTableCreateCompanionBuilder =
    EnderecoCompanion Function({
      Value<int> id,
      required String cep,
      required String rua,
      required String complemento,
      required String cidade,
      required String numero,
      required String uf,
    });
typedef $$EnderecoTableUpdateCompanionBuilder =
    EnderecoCompanion Function({
      Value<int> id,
      Value<String> cep,
      Value<String> rua,
      Value<String> complemento,
      Value<String> cidade,
      Value<String> numero,
      Value<String> uf,
    });

final class $$EnderecoTableReferences
    extends BaseReferences<_$AppDatabase, $EnderecoTable, EnderecoData> {
  $$EnderecoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PessoaTable, List<PessoaData>> _pessoaRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pessoa,
    aliasName: 'endereco__id__pessoa__endereco_id',
  );

  $$PessoaTableProcessedTableManager get pessoaRefs {
    final manager = $$PessoaTableTableManager(
      $_db,
      $_db.pessoa,
    ).filter((f) => f.enderecoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pessoaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EnderecoTableFilterComposer
    extends Composer<_$AppDatabase, $EnderecoTable> {
  $$EnderecoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cep => $composableBuilder(
    column: $table.cep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rua => $composableBuilder(
    column: $table.rua,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get complemento => $composableBuilder(
    column: $table.complemento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cidade => $composableBuilder(
    column: $table.cidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uf => $composableBuilder(
    column: $table.uf,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> pessoaRefs(
    Expression<bool> Function($$PessoaTableFilterComposer f) f,
  ) {
    final $$PessoaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pessoa,
      getReferencedColumn: (t) => t.enderecoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PessoaTableFilterComposer(
            $db: $db,
            $table: $db.pessoa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EnderecoTableOrderingComposer
    extends Composer<_$AppDatabase, $EnderecoTable> {
  $$EnderecoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cep => $composableBuilder(
    column: $table.cep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rua => $composableBuilder(
    column: $table.rua,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get complemento => $composableBuilder(
    column: $table.complemento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cidade => $composableBuilder(
    column: $table.cidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uf => $composableBuilder(
    column: $table.uf,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnderecoTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnderecoTable> {
  $$EnderecoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cep =>
      $composableBuilder(column: $table.cep, builder: (column) => column);

  GeneratedColumn<String> get rua =>
      $composableBuilder(column: $table.rua, builder: (column) => column);

  GeneratedColumn<String> get complemento => $composableBuilder(
    column: $table.complemento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cidade =>
      $composableBuilder(column: $table.cidade, builder: (column) => column);

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get uf =>
      $composableBuilder(column: $table.uf, builder: (column) => column);

  Expression<T> pessoaRefs<T extends Object>(
    Expression<T> Function($$PessoaTableAnnotationComposer a) f,
  ) {
    final $$PessoaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pessoa,
      getReferencedColumn: (t) => t.enderecoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PessoaTableAnnotationComposer(
            $db: $db,
            $table: $db.pessoa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EnderecoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnderecoTable,
          EnderecoData,
          $$EnderecoTableFilterComposer,
          $$EnderecoTableOrderingComposer,
          $$EnderecoTableAnnotationComposer,
          $$EnderecoTableCreateCompanionBuilder,
          $$EnderecoTableUpdateCompanionBuilder,
          (EnderecoData, $$EnderecoTableReferences),
          EnderecoData,
          PrefetchHooks Function({bool pessoaRefs})
        > {
  $$EnderecoTableTableManager(_$AppDatabase db, $EnderecoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnderecoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnderecoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnderecoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cep = const Value.absent(),
                Value<String> rua = const Value.absent(),
                Value<String> complemento = const Value.absent(),
                Value<String> cidade = const Value.absent(),
                Value<String> numero = const Value.absent(),
                Value<String> uf = const Value.absent(),
              }) => EnderecoCompanion(
                id: id,
                cep: cep,
                rua: rua,
                complemento: complemento,
                cidade: cidade,
                numero: numero,
                uf: uf,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cep,
                required String rua,
                required String complemento,
                required String cidade,
                required String numero,
                required String uf,
              }) => EnderecoCompanion.insert(
                id: id,
                cep: cep,
                rua: rua,
                complemento: complemento,
                cidade: cidade,
                numero: numero,
                uf: uf,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnderecoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pessoaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pessoaRefs) db.pessoa],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pessoaRefs)
                    await $_getPrefetchedData<
                      EnderecoData,
                      $EnderecoTable,
                      PessoaData
                    >(
                      currentTable: table,
                      referencedTable: $$EnderecoTableReferences
                          ._pessoaRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EnderecoTableReferences(db, table, p0).pessoaRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.enderecoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EnderecoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnderecoTable,
      EnderecoData,
      $$EnderecoTableFilterComposer,
      $$EnderecoTableOrderingComposer,
      $$EnderecoTableAnnotationComposer,
      $$EnderecoTableCreateCompanionBuilder,
      $$EnderecoTableUpdateCompanionBuilder,
      (EnderecoData, $$EnderecoTableReferences),
      EnderecoData,
      PrefetchHooks Function({bool pessoaRefs})
    >;
typedef $$PessoaTableCreateCompanionBuilder =
    PessoaCompanion Function({
      Value<int> id,
      required String nome,
      required String telefone,
      required int enderecoId,
    });
typedef $$PessoaTableUpdateCompanionBuilder =
    PessoaCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> telefone,
      Value<int> enderecoId,
    });

final class $$PessoaTableReferences
    extends BaseReferences<_$AppDatabase, $PessoaTable, PessoaData> {
  $$PessoaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EnderecoTable _enderecoIdTable(_$AppDatabase db) =>
      db.endereco.createAlias('pessoa__endereco_id__endereco__id');

  $$EnderecoTableProcessedTableManager get enderecoId {
    final $_column = $_itemColumn<int>('endereco_id')!;

    final manager = $$EnderecoTableTableManager(
      $_db,
      $_db.endereco,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enderecoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FuncionarioTable, List<FuncionarioData>>
  _funcionarioRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.funcionario,
    aliasName: 'pessoa__id__funcionario__pessoa_id',
  );

  $$FuncionarioTableProcessedTableManager get funcionarioRefs {
    final manager = $$FuncionarioTableTableManager(
      $_db,
      $_db.funcionario,
    ).filter((f) => f.pessoaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_funcionarioRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ClienteTable, List<ClienteData>>
  _clienteRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cliente,
    aliasName: 'pessoa__id__cliente__pessoa_id',
  );

  $$ClienteTableProcessedTableManager get clienteRefs {
    final manager = $$ClienteTableTableManager(
      $_db,
      $_db.cliente,
    ).filter((f) => f.pessoaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_clienteRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PessoaTableFilterComposer
    extends Composer<_$AppDatabase, $PessoaTable> {
  $$PessoaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefone => $composableBuilder(
    column: $table.telefone,
    builder: (column) => ColumnFilters(column),
  );

  $$EnderecoTableFilterComposer get enderecoId {
    final $$EnderecoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enderecoId,
      referencedTable: $db.endereco,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnderecoTableFilterComposer(
            $db: $db,
            $table: $db.endereco,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> funcionarioRefs(
    Expression<bool> Function($$FuncionarioTableFilterComposer f) f,
  ) {
    final $$FuncionarioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.funcionario,
      getReferencedColumn: (t) => t.pessoaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuncionarioTableFilterComposer(
            $db: $db,
            $table: $db.funcionario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> clienteRefs(
    Expression<bool> Function($$ClienteTableFilterComposer f) f,
  ) {
    final $$ClienteTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.pessoaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteTableFilterComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PessoaTableOrderingComposer
    extends Composer<_$AppDatabase, $PessoaTable> {
  $$PessoaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefone => $composableBuilder(
    column: $table.telefone,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnderecoTableOrderingComposer get enderecoId {
    final $$EnderecoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enderecoId,
      referencedTable: $db.endereco,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnderecoTableOrderingComposer(
            $db: $db,
            $table: $db.endereco,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PessoaTableAnnotationComposer
    extends Composer<_$AppDatabase, $PessoaTable> {
  $$PessoaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get telefone =>
      $composableBuilder(column: $table.telefone, builder: (column) => column);

  $$EnderecoTableAnnotationComposer get enderecoId {
    final $$EnderecoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enderecoId,
      referencedTable: $db.endereco,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnderecoTableAnnotationComposer(
            $db: $db,
            $table: $db.endereco,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> funcionarioRefs<T extends Object>(
    Expression<T> Function($$FuncionarioTableAnnotationComposer a) f,
  ) {
    final $$FuncionarioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.funcionario,
      getReferencedColumn: (t) => t.pessoaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuncionarioTableAnnotationComposer(
            $db: $db,
            $table: $db.funcionario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> clienteRefs<T extends Object>(
    Expression<T> Function($$ClienteTableAnnotationComposer a) f,
  ) {
    final $$ClienteTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.pessoaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClienteTableAnnotationComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PessoaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PessoaTable,
          PessoaData,
          $$PessoaTableFilterComposer,
          $$PessoaTableOrderingComposer,
          $$PessoaTableAnnotationComposer,
          $$PessoaTableCreateCompanionBuilder,
          $$PessoaTableUpdateCompanionBuilder,
          (PessoaData, $$PessoaTableReferences),
          PessoaData,
          PrefetchHooks Function({
            bool enderecoId,
            bool funcionarioRefs,
            bool clienteRefs,
          })
        > {
  $$PessoaTableTableManager(_$AppDatabase db, $PessoaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PessoaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PessoaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PessoaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> telefone = const Value.absent(),
                Value<int> enderecoId = const Value.absent(),
              }) => PessoaCompanion(
                id: id,
                nome: nome,
                telefone: telefone,
                enderecoId: enderecoId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String telefone,
                required int enderecoId,
              }) => PessoaCompanion.insert(
                id: id,
                nome: nome,
                telefone: telefone,
                enderecoId: enderecoId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PessoaTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                enderecoId = false,
                funcionarioRefs = false,
                clienteRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (funcionarioRefs) db.funcionario,
                    if (clienteRefs) db.cliente,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (enderecoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.enderecoId,
                                    referencedTable: $$PessoaTableReferences
                                        ._enderecoIdTable(db),
                                    referencedColumn: $$PessoaTableReferences
                                        ._enderecoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (funcionarioRefs)
                        await $_getPrefetchedData<
                          PessoaData,
                          $PessoaTable,
                          FuncionarioData
                        >(
                          currentTable: table,
                          referencedTable: $$PessoaTableReferences
                              ._funcionarioRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PessoaTableReferences(
                                db,
                                table,
                                p0,
                              ).funcionarioRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pessoaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (clienteRefs)
                        await $_getPrefetchedData<
                          PessoaData,
                          $PessoaTable,
                          ClienteData
                        >(
                          currentTable: table,
                          referencedTable: $$PessoaTableReferences
                              ._clienteRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PessoaTableReferences(
                                db,
                                table,
                                p0,
                              ).clienteRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.pessoaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PessoaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PessoaTable,
      PessoaData,
      $$PessoaTableFilterComposer,
      $$PessoaTableOrderingComposer,
      $$PessoaTableAnnotationComposer,
      $$PessoaTableCreateCompanionBuilder,
      $$PessoaTableUpdateCompanionBuilder,
      (PessoaData, $$PessoaTableReferences),
      PessoaData,
      PrefetchHooks Function({
        bool enderecoId,
        bool funcionarioRefs,
        bool clienteRefs,
      })
    >;
typedef $$CargoTableCreateCompanionBuilder =
    CargoCompanion Function({
      Value<int> id,
      required String nome,
      required double salario,
    });
typedef $$CargoTableUpdateCompanionBuilder =
    CargoCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<double> salario,
    });

final class $$CargoTableReferences
    extends BaseReferences<_$AppDatabase, $CargoTable, CargoData> {
  $$CargoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FuncionarioTable, List<FuncionarioData>>
  _funcionarioRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.funcionario,
    aliasName: 'cargo__id__funcionario__cargo_id',
  );

  $$FuncionarioTableProcessedTableManager get funcionarioRefs {
    final manager = $$FuncionarioTableTableManager(
      $_db,
      $_db.funcionario,
    ).filter((f) => f.cargoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_funcionarioRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CargoTableFilterComposer extends Composer<_$AppDatabase, $CargoTable> {
  $$CargoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salario => $composableBuilder(
    column: $table.salario,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> funcionarioRefs(
    Expression<bool> Function($$FuncionarioTableFilterComposer f) f,
  ) {
    final $$FuncionarioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.funcionario,
      getReferencedColumn: (t) => t.cargoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuncionarioTableFilterComposer(
            $db: $db,
            $table: $db.funcionario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CargoTableOrderingComposer
    extends Composer<_$AppDatabase, $CargoTable> {
  $$CargoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salario => $composableBuilder(
    column: $table.salario,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CargoTableAnnotationComposer
    extends Composer<_$AppDatabase, $CargoTable> {
  $$CargoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<double> get salario =>
      $composableBuilder(column: $table.salario, builder: (column) => column);

  Expression<T> funcionarioRefs<T extends Object>(
    Expression<T> Function($$FuncionarioTableAnnotationComposer a) f,
  ) {
    final $$FuncionarioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.funcionario,
      getReferencedColumn: (t) => t.cargoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuncionarioTableAnnotationComposer(
            $db: $db,
            $table: $db.funcionario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CargoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CargoTable,
          CargoData,
          $$CargoTableFilterComposer,
          $$CargoTableOrderingComposer,
          $$CargoTableAnnotationComposer,
          $$CargoTableCreateCompanionBuilder,
          $$CargoTableUpdateCompanionBuilder,
          (CargoData, $$CargoTableReferences),
          CargoData,
          PrefetchHooks Function({bool funcionarioRefs})
        > {
  $$CargoTableTableManager(_$AppDatabase db, $CargoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CargoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CargoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CargoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<double> salario = const Value.absent(),
              }) => CargoCompanion(id: id, nome: nome, salario: salario),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required double salario,
              }) => CargoCompanion.insert(id: id, nome: nome, salario: salario),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CargoTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({funcionarioRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (funcionarioRefs) db.funcionario],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (funcionarioRefs)
                    await $_getPrefetchedData<
                      CargoData,
                      $CargoTable,
                      FuncionarioData
                    >(
                      currentTable: table,
                      referencedTable: $$CargoTableReferences
                          ._funcionarioRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CargoTableReferences(db, table, p0).funcionarioRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cargoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CargoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CargoTable,
      CargoData,
      $$CargoTableFilterComposer,
      $$CargoTableOrderingComposer,
      $$CargoTableAnnotationComposer,
      $$CargoTableCreateCompanionBuilder,
      $$CargoTableUpdateCompanionBuilder,
      (CargoData, $$CargoTableReferences),
      CargoData,
      PrefetchHooks Function({bool funcionarioRefs})
    >;
typedef $$FuncionarioTableCreateCompanionBuilder =
    FuncionarioCompanion Function({
      Value<int> pessoaId,
      required String cpf,
      required Turno turno,
      required int cargoId,
    });
typedef $$FuncionarioTableUpdateCompanionBuilder =
    FuncionarioCompanion Function({
      Value<int> pessoaId,
      Value<String> cpf,
      Value<Turno> turno,
      Value<int> cargoId,
    });

final class $$FuncionarioTableReferences
    extends BaseReferences<_$AppDatabase, $FuncionarioTable, FuncionarioData> {
  $$FuncionarioTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PessoaTable _pessoaIdTable(_$AppDatabase db) =>
      db.pessoa.createAlias('funcionario__pessoa_id__pessoa__id');

  $$PessoaTableProcessedTableManager get pessoaId {
    final $_column = $_itemColumn<int>('pessoa_id')!;

    final manager = $$PessoaTableTableManager(
      $_db,
      $_db.pessoa,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pessoaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CargoTable _cargoIdTable(_$AppDatabase db) =>
      db.cargo.createAlias('funcionario__cargo_id__cargo__id');

  $$CargoTableProcessedTableManager get cargoId {
    final $_column = $_itemColumn<int>('cargo_id')!;

    final manager = $$CargoTableTableManager(
      $_db,
      $_db.cargo,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cargoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FuncionarioTableFilterComposer
    extends Composer<_$AppDatabase, $FuncionarioTable> {
  $$FuncionarioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cpf => $composableBuilder(
    column: $table.cpf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Turno, Turno, String> get turno =>
      $composableBuilder(
        column: $table.turno,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$PessoaTableFilterComposer get pessoaId {
    final $$PessoaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pessoaId,
      referencedTable: $db.pessoa,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PessoaTableFilterComposer(
            $db: $db,
            $table: $db.pessoa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CargoTableFilterComposer get cargoId {
    final $$CargoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cargoId,
      referencedTable: $db.cargo,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CargoTableFilterComposer(
            $db: $db,
            $table: $db.cargo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuncionarioTableOrderingComposer
    extends Composer<_$AppDatabase, $FuncionarioTable> {
  $$FuncionarioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cpf => $composableBuilder(
    column: $table.cpf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get turno => $composableBuilder(
    column: $table.turno,
    builder: (column) => ColumnOrderings(column),
  );

  $$PessoaTableOrderingComposer get pessoaId {
    final $$PessoaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pessoaId,
      referencedTable: $db.pessoa,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PessoaTableOrderingComposer(
            $db: $db,
            $table: $db.pessoa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CargoTableOrderingComposer get cargoId {
    final $$CargoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cargoId,
      referencedTable: $db.cargo,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CargoTableOrderingComposer(
            $db: $db,
            $table: $db.cargo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuncionarioTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuncionarioTable> {
  $$FuncionarioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cpf =>
      $composableBuilder(column: $table.cpf, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Turno, String> get turno =>
      $composableBuilder(column: $table.turno, builder: (column) => column);

  $$PessoaTableAnnotationComposer get pessoaId {
    final $$PessoaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pessoaId,
      referencedTable: $db.pessoa,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PessoaTableAnnotationComposer(
            $db: $db,
            $table: $db.pessoa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CargoTableAnnotationComposer get cargoId {
    final $$CargoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cargoId,
      referencedTable: $db.cargo,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CargoTableAnnotationComposer(
            $db: $db,
            $table: $db.cargo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuncionarioTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuncionarioTable,
          FuncionarioData,
          $$FuncionarioTableFilterComposer,
          $$FuncionarioTableOrderingComposer,
          $$FuncionarioTableAnnotationComposer,
          $$FuncionarioTableCreateCompanionBuilder,
          $$FuncionarioTableUpdateCompanionBuilder,
          (FuncionarioData, $$FuncionarioTableReferences),
          FuncionarioData,
          PrefetchHooks Function({bool pessoaId, bool cargoId})
        > {
  $$FuncionarioTableTableManager(_$AppDatabase db, $FuncionarioTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuncionarioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuncionarioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuncionarioTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> pessoaId = const Value.absent(),
                Value<String> cpf = const Value.absent(),
                Value<Turno> turno = const Value.absent(),
                Value<int> cargoId = const Value.absent(),
              }) => FuncionarioCompanion(
                pessoaId: pessoaId,
                cpf: cpf,
                turno: turno,
                cargoId: cargoId,
              ),
          createCompanionCallback:
              ({
                Value<int> pessoaId = const Value.absent(),
                required String cpf,
                required Turno turno,
                required int cargoId,
              }) => FuncionarioCompanion.insert(
                pessoaId: pessoaId,
                cpf: cpf,
                turno: turno,
                cargoId: cargoId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FuncionarioTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pessoaId = false, cargoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pessoaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pessoaId,
                                referencedTable: $$FuncionarioTableReferences
                                    ._pessoaIdTable(db),
                                referencedColumn: $$FuncionarioTableReferences
                                    ._pessoaIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (cargoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cargoId,
                                referencedTable: $$FuncionarioTableReferences
                                    ._cargoIdTable(db),
                                referencedColumn: $$FuncionarioTableReferences
                                    ._cargoIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FuncionarioTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuncionarioTable,
      FuncionarioData,
      $$FuncionarioTableFilterComposer,
      $$FuncionarioTableOrderingComposer,
      $$FuncionarioTableAnnotationComposer,
      $$FuncionarioTableCreateCompanionBuilder,
      $$FuncionarioTableUpdateCompanionBuilder,
      (FuncionarioData, $$FuncionarioTableReferences),
      FuncionarioData,
      PrefetchHooks Function({bool pessoaId, bool cargoId})
    >;
typedef $$ClienteTableCreateCompanionBuilder =
    ClienteCompanion Function({
      Value<int> pessoaId,
      required String email,
      required String obs,
    });
typedef $$ClienteTableUpdateCompanionBuilder =
    ClienteCompanion Function({
      Value<int> pessoaId,
      Value<String> email,
      Value<String> obs,
    });

final class $$ClienteTableReferences
    extends BaseReferences<_$AppDatabase, $ClienteTable, ClienteData> {
  $$ClienteTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PessoaTable _pessoaIdTable(_$AppDatabase db) =>
      db.pessoa.createAlias('cliente__pessoa_id__pessoa__id');

  $$PessoaTableProcessedTableManager get pessoaId {
    final $_column = $_itemColumn<int>('pessoa_id')!;

    final manager = $$PessoaTableTableManager(
      $_db,
      $_db.pessoa,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pessoaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClienteTableFilterComposer
    extends Composer<_$AppDatabase, $ClienteTable> {
  $$ClienteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get obs => $composableBuilder(
    column: $table.obs,
    builder: (column) => ColumnFilters(column),
  );

  $$PessoaTableFilterComposer get pessoaId {
    final $$PessoaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pessoaId,
      referencedTable: $db.pessoa,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PessoaTableFilterComposer(
            $db: $db,
            $table: $db.pessoa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteTableOrderingComposer
    extends Composer<_$AppDatabase, $ClienteTable> {
  $$ClienteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get obs => $composableBuilder(
    column: $table.obs,
    builder: (column) => ColumnOrderings(column),
  );

  $$PessoaTableOrderingComposer get pessoaId {
    final $$PessoaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pessoaId,
      referencedTable: $db.pessoa,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PessoaTableOrderingComposer(
            $db: $db,
            $table: $db.pessoa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClienteTable> {
  $$ClienteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get obs =>
      $composableBuilder(column: $table.obs, builder: (column) => column);

  $$PessoaTableAnnotationComposer get pessoaId {
    final $$PessoaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pessoaId,
      referencedTable: $db.pessoa,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PessoaTableAnnotationComposer(
            $db: $db,
            $table: $db.pessoa,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClienteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClienteTable,
          ClienteData,
          $$ClienteTableFilterComposer,
          $$ClienteTableOrderingComposer,
          $$ClienteTableAnnotationComposer,
          $$ClienteTableCreateCompanionBuilder,
          $$ClienteTableUpdateCompanionBuilder,
          (ClienteData, $$ClienteTableReferences),
          ClienteData,
          PrefetchHooks Function({bool pessoaId})
        > {
  $$ClienteTableTableManager(_$AppDatabase db, $ClienteTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClienteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClienteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClienteTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> pessoaId = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> obs = const Value.absent(),
              }) =>
                  ClienteCompanion(pessoaId: pessoaId, email: email, obs: obs),
          createCompanionCallback:
              ({
                Value<int> pessoaId = const Value.absent(),
                required String email,
                required String obs,
              }) => ClienteCompanion.insert(
                pessoaId: pessoaId,
                email: email,
                obs: obs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClienteTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pessoaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pessoaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.pessoaId,
                                referencedTable: $$ClienteTableReferences
                                    ._pessoaIdTable(db),
                                referencedColumn: $$ClienteTableReferences
                                    ._pessoaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClienteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClienteTable,
      ClienteData,
      $$ClienteTableFilterComposer,
      $$ClienteTableOrderingComposer,
      $$ClienteTableAnnotationComposer,
      $$ClienteTableCreateCompanionBuilder,
      $$ClienteTableUpdateCompanionBuilder,
      (ClienteData, $$ClienteTableReferences),
      ClienteData,
      PrefetchHooks Function({bool pessoaId})
    >;
typedef $$PessoaJuridicaTableCreateCompanionBuilder =
    PessoaJuridicaCompanion Function({
      Value<int> clienteId,
      required String cnpj,
      required String setor,
    });
typedef $$PessoaJuridicaTableUpdateCompanionBuilder =
    PessoaJuridicaCompanion Function({
      Value<int> clienteId,
      Value<String> cnpj,
      Value<String> setor,
    });

class $$PessoaJuridicaTableFilterComposer
    extends Composer<_$AppDatabase, $PessoaJuridicaTable> {
  $$PessoaJuridicaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cnpj => $composableBuilder(
    column: $table.cnpj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setor => $composableBuilder(
    column: $table.setor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PessoaJuridicaTableOrderingComposer
    extends Composer<_$AppDatabase, $PessoaJuridicaTable> {
  $$PessoaJuridicaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cnpj => $composableBuilder(
    column: $table.cnpj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setor => $composableBuilder(
    column: $table.setor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PessoaJuridicaTableAnnotationComposer
    extends Composer<_$AppDatabase, $PessoaJuridicaTable> {
  $$PessoaJuridicaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cnpj =>
      $composableBuilder(column: $table.cnpj, builder: (column) => column);

  GeneratedColumn<String> get setor =>
      $composableBuilder(column: $table.setor, builder: (column) => column);
}

class $$PessoaJuridicaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PessoaJuridicaTable,
          PessoaJuridicaData,
          $$PessoaJuridicaTableFilterComposer,
          $$PessoaJuridicaTableOrderingComposer,
          $$PessoaJuridicaTableAnnotationComposer,
          $$PessoaJuridicaTableCreateCompanionBuilder,
          $$PessoaJuridicaTableUpdateCompanionBuilder,
          (
            PessoaJuridicaData,
            BaseReferences<
              _$AppDatabase,
              $PessoaJuridicaTable,
              PessoaJuridicaData
            >,
          ),
          PessoaJuridicaData,
          PrefetchHooks Function()
        > {
  $$PessoaJuridicaTableTableManager(
    _$AppDatabase db,
    $PessoaJuridicaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PessoaJuridicaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PessoaJuridicaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PessoaJuridicaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> clienteId = const Value.absent(),
                Value<String> cnpj = const Value.absent(),
                Value<String> setor = const Value.absent(),
              }) => PessoaJuridicaCompanion(
                clienteId: clienteId,
                cnpj: cnpj,
                setor: setor,
              ),
          createCompanionCallback:
              ({
                Value<int> clienteId = const Value.absent(),
                required String cnpj,
                required String setor,
              }) => PessoaJuridicaCompanion.insert(
                clienteId: clienteId,
                cnpj: cnpj,
                setor: setor,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PessoaJuridicaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PessoaJuridicaTable,
      PessoaJuridicaData,
      $$PessoaJuridicaTableFilterComposer,
      $$PessoaJuridicaTableOrderingComposer,
      $$PessoaJuridicaTableAnnotationComposer,
      $$PessoaJuridicaTableCreateCompanionBuilder,
      $$PessoaJuridicaTableUpdateCompanionBuilder,
      (
        PessoaJuridicaData,
        BaseReferences<_$AppDatabase, $PessoaJuridicaTable, PessoaJuridicaData>,
      ),
      PessoaJuridicaData,
      PrefetchHooks Function()
    >;
typedef $$PessoaFisicaTableCreateCompanionBuilder =
    PessoaFisicaCompanion Function({Value<int> clienteId, required String cpf});
typedef $$PessoaFisicaTableUpdateCompanionBuilder =
    PessoaFisicaCompanion Function({Value<int> clienteId, Value<String> cpf});

class $$PessoaFisicaTableFilterComposer
    extends Composer<_$AppDatabase, $PessoaFisicaTable> {
  $$PessoaFisicaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cpf => $composableBuilder(
    column: $table.cpf,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PessoaFisicaTableOrderingComposer
    extends Composer<_$AppDatabase, $PessoaFisicaTable> {
  $$PessoaFisicaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cpf => $composableBuilder(
    column: $table.cpf,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PessoaFisicaTableAnnotationComposer
    extends Composer<_$AppDatabase, $PessoaFisicaTable> {
  $$PessoaFisicaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cpf =>
      $composableBuilder(column: $table.cpf, builder: (column) => column);
}

class $$PessoaFisicaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PessoaFisicaTable,
          PessoaFisicaData,
          $$PessoaFisicaTableFilterComposer,
          $$PessoaFisicaTableOrderingComposer,
          $$PessoaFisicaTableAnnotationComposer,
          $$PessoaFisicaTableCreateCompanionBuilder,
          $$PessoaFisicaTableUpdateCompanionBuilder,
          (
            PessoaFisicaData,
            BaseReferences<_$AppDatabase, $PessoaFisicaTable, PessoaFisicaData>,
          ),
          PessoaFisicaData,
          PrefetchHooks Function()
        > {
  $$PessoaFisicaTableTableManager(_$AppDatabase db, $PessoaFisicaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PessoaFisicaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PessoaFisicaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PessoaFisicaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> clienteId = const Value.absent(),
                Value<String> cpf = const Value.absent(),
              }) => PessoaFisicaCompanion(clienteId: clienteId, cpf: cpf),
          createCompanionCallback:
              ({
                Value<int> clienteId = const Value.absent(),
                required String cpf,
              }) =>
                  PessoaFisicaCompanion.insert(clienteId: clienteId, cpf: cpf),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PessoaFisicaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PessoaFisicaTable,
      PessoaFisicaData,
      $$PessoaFisicaTableFilterComposer,
      $$PessoaFisicaTableOrderingComposer,
      $$PessoaFisicaTableAnnotationComposer,
      $$PessoaFisicaTableCreateCompanionBuilder,
      $$PessoaFisicaTableUpdateCompanionBuilder,
      (
        PessoaFisicaData,
        BaseReferences<_$AppDatabase, $PessoaFisicaTable, PessoaFisicaData>,
      ),
      PessoaFisicaData,
      PrefetchHooks Function()
    >;
typedef $$EquipamentoTableCreateCompanionBuilder =
    EquipamentoCompanion Function({
      Value<int> id,
      required String marca,
      required String modelo,
      required String numeroSerie,
      required String portaria,
      required String numeroInmetro,
      required String numeroVerificacao,
      required String seloAnterior,
      required String seloAtual,
      required String lacreAnterior,
      required String lacreAtual,
    });
typedef $$EquipamentoTableUpdateCompanionBuilder =
    EquipamentoCompanion Function({
      Value<int> id,
      Value<String> marca,
      Value<String> modelo,
      Value<String> numeroSerie,
      Value<String> portaria,
      Value<String> numeroInmetro,
      Value<String> numeroVerificacao,
      Value<String> seloAnterior,
      Value<String> seloAtual,
      Value<String> lacreAnterior,
      Value<String> lacreAtual,
    });

final class $$EquipamentoTableReferences
    extends BaseReferences<_$AppDatabase, $EquipamentoTable, EquipamentoData> {
  $$EquipamentoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdemServicosTable, List<OrdemServico>>
  _ordemServicosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ordemServicos,
    aliasName: 'equipamento__id__ordem_servicos__equipamento_id',
  );

  $$OrdemServicosTableProcessedTableManager get ordemServicosRefs {
    final manager = $$OrdemServicosTableTableManager(
      $_db,
      $_db.ordemServicos,
    ).filter((f) => f.equipamentoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordemServicosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquipamentoTableFilterComposer
    extends Composer<_$AppDatabase, $EquipamentoTable> {
  $$EquipamentoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroSerie => $composableBuilder(
    column: $table.numeroSerie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portaria => $composableBuilder(
    column: $table.portaria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroInmetro => $composableBuilder(
    column: $table.numeroInmetro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroVerificacao => $composableBuilder(
    column: $table.numeroVerificacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seloAnterior => $composableBuilder(
    column: $table.seloAnterior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seloAtual => $composableBuilder(
    column: $table.seloAtual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lacreAnterior => $composableBuilder(
    column: $table.lacreAnterior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lacreAtual => $composableBuilder(
    column: $table.lacreAtual,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ordemServicosRefs(
    Expression<bool> Function($$OrdemServicosTableFilterComposer f) f,
  ) {
    final $$OrdemServicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordemServicos,
      getReferencedColumn: (t) => t.equipamentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicosTableFilterComposer(
            $db: $db,
            $table: $db.ordemServicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipamentoTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipamentoTable> {
  $$EquipamentoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelo => $composableBuilder(
    column: $table.modelo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroSerie => $composableBuilder(
    column: $table.numeroSerie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portaria => $composableBuilder(
    column: $table.portaria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroInmetro => $composableBuilder(
    column: $table.numeroInmetro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroVerificacao => $composableBuilder(
    column: $table.numeroVerificacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seloAnterior => $composableBuilder(
    column: $table.seloAnterior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seloAtual => $composableBuilder(
    column: $table.seloAtual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lacreAnterior => $composableBuilder(
    column: $table.lacreAnterior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lacreAtual => $composableBuilder(
    column: $table.lacreAtual,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipamentoTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipamentoTable> {
  $$EquipamentoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<String> get numeroSerie => $composableBuilder(
    column: $table.numeroSerie,
    builder: (column) => column,
  );

  GeneratedColumn<String> get portaria =>
      $composableBuilder(column: $table.portaria, builder: (column) => column);

  GeneratedColumn<String> get numeroInmetro => $composableBuilder(
    column: $table.numeroInmetro,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numeroVerificacao => $composableBuilder(
    column: $table.numeroVerificacao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seloAnterior => $composableBuilder(
    column: $table.seloAnterior,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seloAtual =>
      $composableBuilder(column: $table.seloAtual, builder: (column) => column);

  GeneratedColumn<String> get lacreAnterior => $composableBuilder(
    column: $table.lacreAnterior,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lacreAtual => $composableBuilder(
    column: $table.lacreAtual,
    builder: (column) => column,
  );

  Expression<T> ordemServicosRefs<T extends Object>(
    Expression<T> Function($$OrdemServicosTableAnnotationComposer a) f,
  ) {
    final $$OrdemServicosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordemServicos,
      getReferencedColumn: (t) => t.equipamentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicosTableAnnotationComposer(
            $db: $db,
            $table: $db.ordemServicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipamentoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipamentoTable,
          EquipamentoData,
          $$EquipamentoTableFilterComposer,
          $$EquipamentoTableOrderingComposer,
          $$EquipamentoTableAnnotationComposer,
          $$EquipamentoTableCreateCompanionBuilder,
          $$EquipamentoTableUpdateCompanionBuilder,
          (EquipamentoData, $$EquipamentoTableReferences),
          EquipamentoData,
          PrefetchHooks Function({bool ordemServicosRefs})
        > {
  $$EquipamentoTableTableManager(_$AppDatabase db, $EquipamentoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipamentoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipamentoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipamentoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> marca = const Value.absent(),
                Value<String> modelo = const Value.absent(),
                Value<String> numeroSerie = const Value.absent(),
                Value<String> portaria = const Value.absent(),
                Value<String> numeroInmetro = const Value.absent(),
                Value<String> numeroVerificacao = const Value.absent(),
                Value<String> seloAnterior = const Value.absent(),
                Value<String> seloAtual = const Value.absent(),
                Value<String> lacreAnterior = const Value.absent(),
                Value<String> lacreAtual = const Value.absent(),
              }) => EquipamentoCompanion(
                id: id,
                marca: marca,
                modelo: modelo,
                numeroSerie: numeroSerie,
                portaria: portaria,
                numeroInmetro: numeroInmetro,
                numeroVerificacao: numeroVerificacao,
                seloAnterior: seloAnterior,
                seloAtual: seloAtual,
                lacreAnterior: lacreAnterior,
                lacreAtual: lacreAtual,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String marca,
                required String modelo,
                required String numeroSerie,
                required String portaria,
                required String numeroInmetro,
                required String numeroVerificacao,
                required String seloAnterior,
                required String seloAtual,
                required String lacreAnterior,
                required String lacreAtual,
              }) => EquipamentoCompanion.insert(
                id: id,
                marca: marca,
                modelo: modelo,
                numeroSerie: numeroSerie,
                portaria: portaria,
                numeroInmetro: numeroInmetro,
                numeroVerificacao: numeroVerificacao,
                seloAnterior: seloAnterior,
                seloAtual: seloAtual,
                lacreAnterior: lacreAnterior,
                lacreAtual: lacreAtual,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EquipamentoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordemServicosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ordemServicosRefs) db.ordemServicos,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordemServicosRefs)
                    await $_getPrefetchedData<
                      EquipamentoData,
                      $EquipamentoTable,
                      OrdemServico
                    >(
                      currentTable: table,
                      referencedTable: $$EquipamentoTableReferences
                          ._ordemServicosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EquipamentoTableReferences(
                            db,
                            table,
                            p0,
                          ).ordemServicosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.equipamentoId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EquipamentoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipamentoTable,
      EquipamentoData,
      $$EquipamentoTableFilterComposer,
      $$EquipamentoTableOrderingComposer,
      $$EquipamentoTableAnnotationComposer,
      $$EquipamentoTableCreateCompanionBuilder,
      $$EquipamentoTableUpdateCompanionBuilder,
      (EquipamentoData, $$EquipamentoTableReferences),
      EquipamentoData,
      PrefetchHooks Function({bool ordemServicosRefs})
    >;
typedef $$OrdemServicosTableCreateCompanionBuilder =
    OrdemServicosCompanion Function({
      Value<int> id,
      required DateTime data,
      required String relatorio,
      required Statusordemservico status,
      required int responsavelId,
      required int equipamentoId,
      required int clienteId,
    });
typedef $$OrdemServicosTableUpdateCompanionBuilder =
    OrdemServicosCompanion Function({
      Value<int> id,
      Value<DateTime> data,
      Value<String> relatorio,
      Value<Statusordemservico> status,
      Value<int> responsavelId,
      Value<int> equipamentoId,
      Value<int> clienteId,
    });

final class $$OrdemServicosTableReferences
    extends BaseReferences<_$AppDatabase, $OrdemServicosTable, OrdemServico> {
  $$OrdemServicosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EquipamentoTable _equipamentoIdTable(_$AppDatabase db) => db
      .equipamento
      .createAlias('ordem_servicos__equipamento_id__equipamento__id');

  $$EquipamentoTableProcessedTableManager get equipamentoId {
    final $_column = $_itemColumn<int>('equipamento_id')!;

    final manager = $$EquipamentoTableTableManager(
      $_db,
      $_db.equipamento,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipamentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PecaTable, List<PecaData>> _pecaRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.peca,
    aliasName: 'ordem_servicos__id__peca__ordem_servico_id',
  );

  $$PecaTableProcessedTableManager get pecaRefs {
    final manager = $$PecaTableTableManager(
      $_db,
      $_db.peca,
    ).filter((f) => f.ordemServicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pecaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $OrdemServicoServicoTable,
    List<OrdemServicoServicoData>
  >
  _ordemServicoServicoRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ordemServicoServico,
        aliasName:
            'ordem_servicos__id__ordem_servico_servico__ordem_servico_id',
      );

  $$OrdemServicoServicoTableProcessedTableManager get ordemServicoServicoRefs {
    final manager = $$OrdemServicoServicoTableTableManager(
      $_db,
      $_db.ordemServicoServico,
    ).filter((f) => f.ordemServicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ordemServicoServicoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdemServicosTableFilterComposer
    extends Composer<_$AppDatabase, $OrdemServicosTable> {
  $$OrdemServicosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatorio => $composableBuilder(
    column: $table.relatorio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Statusordemservico, Statusordemservico, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$EquipamentoTableFilterComposer get equipamentoId {
    final $$EquipamentoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipamentoId,
      referencedTable: $db.equipamento,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipamentoTableFilterComposer(
            $db: $db,
            $table: $db.equipamento,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> pecaRefs(
    Expression<bool> Function($$PecaTableFilterComposer f) f,
  ) {
    final $$PecaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.peca,
      getReferencedColumn: (t) => t.ordemServicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PecaTableFilterComposer(
            $db: $db,
            $table: $db.peca,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ordemServicoServicoRefs(
    Expression<bool> Function($$OrdemServicoServicoTableFilterComposer f) f,
  ) {
    final $$OrdemServicoServicoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordemServicoServico,
      getReferencedColumn: (t) => t.ordemServicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicoServicoTableFilterComposer(
            $db: $db,
            $table: $db.ordemServicoServico,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdemServicosTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdemServicosTable> {
  $$OrdemServicosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatorio => $composableBuilder(
    column: $table.relatorio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$EquipamentoTableOrderingComposer get equipamentoId {
    final $$EquipamentoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipamentoId,
      referencedTable: $db.equipamento,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipamentoTableOrderingComposer(
            $db: $db,
            $table: $db.equipamento,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdemServicosTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdemServicosTable> {
  $$OrdemServicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get relatorio =>
      $composableBuilder(column: $table.relatorio, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Statusordemservico, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$EquipamentoTableAnnotationComposer get equipamentoId {
    final $$EquipamentoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipamentoId,
      referencedTable: $db.equipamento,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipamentoTableAnnotationComposer(
            $db: $db,
            $table: $db.equipamento,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> pecaRefs<T extends Object>(
    Expression<T> Function($$PecaTableAnnotationComposer a) f,
  ) {
    final $$PecaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.peca,
      getReferencedColumn: (t) => t.ordemServicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PecaTableAnnotationComposer(
            $db: $db,
            $table: $db.peca,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ordemServicoServicoRefs<T extends Object>(
    Expression<T> Function($$OrdemServicoServicoTableAnnotationComposer a) f,
  ) {
    final $$OrdemServicoServicoTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ordemServicoServico,
          getReferencedColumn: (t) => t.ordemServicoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrdemServicoServicoTableAnnotationComposer(
                $db: $db,
                $table: $db.ordemServicoServico,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrdemServicosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdemServicosTable,
          OrdemServico,
          $$OrdemServicosTableFilterComposer,
          $$OrdemServicosTableOrderingComposer,
          $$OrdemServicosTableAnnotationComposer,
          $$OrdemServicosTableCreateCompanionBuilder,
          $$OrdemServicosTableUpdateCompanionBuilder,
          (OrdemServico, $$OrdemServicosTableReferences),
          OrdemServico,
          PrefetchHooks Function({
            bool equipamentoId,
            bool pecaRefs,
            bool ordemServicoServicoRefs,
          })
        > {
  $$OrdemServicosTableTableManager(_$AppDatabase db, $OrdemServicosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdemServicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdemServicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdemServicosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
                Value<String> relatorio = const Value.absent(),
                Value<Statusordemservico> status = const Value.absent(),
                Value<int> responsavelId = const Value.absent(),
                Value<int> equipamentoId = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
              }) => OrdemServicosCompanion(
                id: id,
                data: data,
                relatorio: relatorio,
                status: status,
                responsavelId: responsavelId,
                equipamentoId: equipamentoId,
                clienteId: clienteId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime data,
                required String relatorio,
                required Statusordemservico status,
                required int responsavelId,
                required int equipamentoId,
                required int clienteId,
              }) => OrdemServicosCompanion.insert(
                id: id,
                data: data,
                relatorio: relatorio,
                status: status,
                responsavelId: responsavelId,
                equipamentoId: equipamentoId,
                clienteId: clienteId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrdemServicosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                equipamentoId = false,
                pecaRefs = false,
                ordemServicoServicoRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pecaRefs) db.peca,
                    if (ordemServicoServicoRefs) db.ordemServicoServico,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (equipamentoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.equipamentoId,
                                    referencedTable:
                                        $$OrdemServicosTableReferences
                                            ._equipamentoIdTable(db),
                                    referencedColumn:
                                        $$OrdemServicosTableReferences
                                            ._equipamentoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (pecaRefs)
                        await $_getPrefetchedData<
                          OrdemServico,
                          $OrdemServicosTable,
                          PecaData
                        >(
                          currentTable: table,
                          referencedTable: $$OrdemServicosTableReferences
                              ._pecaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdemServicosTableReferences(
                                db,
                                table,
                                p0,
                              ).pecaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ordemServicoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ordemServicoServicoRefs)
                        await $_getPrefetchedData<
                          OrdemServico,
                          $OrdemServicosTable,
                          OrdemServicoServicoData
                        >(
                          currentTable: table,
                          referencedTable: $$OrdemServicosTableReferences
                              ._ordemServicoServicoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdemServicosTableReferences(
                                db,
                                table,
                                p0,
                              ).ordemServicoServicoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ordemServicoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdemServicosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdemServicosTable,
      OrdemServico,
      $$OrdemServicosTableFilterComposer,
      $$OrdemServicosTableOrderingComposer,
      $$OrdemServicosTableAnnotationComposer,
      $$OrdemServicosTableCreateCompanionBuilder,
      $$OrdemServicosTableUpdateCompanionBuilder,
      (OrdemServico, $$OrdemServicosTableReferences),
      OrdemServico,
      PrefetchHooks Function({
        bool equipamentoId,
        bool pecaRefs,
        bool ordemServicoServicoRefs,
      })
    >;
typedef $$PecaTableCreateCompanionBuilder =
    PecaCompanion Function({
      Value<int> id,
      required String nome,
      required String descricao,
      required TipoProduto tipo,
      required double valor,
      Value<int?> ordemServicoId,
    });
typedef $$PecaTableUpdateCompanionBuilder =
    PecaCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> descricao,
      Value<TipoProduto> tipo,
      Value<double> valor,
      Value<int?> ordemServicoId,
    });

final class $$PecaTableReferences
    extends BaseReferences<_$AppDatabase, $PecaTable, PecaData> {
  $$PecaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdemServicosTable _ordemServicoIdTable(_$AppDatabase db) => db
      .ordemServicos
      .createAlias('peca__ordem_servico_id__ordem_servicos__id');

  $$OrdemServicosTableProcessedTableManager? get ordemServicoId {
    final $_column = $_itemColumn<int>('ordem_servico_id');
    if ($_column == null) return null;
    final manager = $$OrdemServicosTableTableManager(
      $_db,
      $_db.ordemServicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordemServicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PecaTableFilterComposer extends Composer<_$AppDatabase, $PecaTable> {
  $$PecaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoProduto, TipoProduto, String> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdemServicosTableFilterComposer get ordemServicoId {
    final $$OrdemServicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordemServicoId,
      referencedTable: $db.ordemServicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicosTableFilterComposer(
            $db: $db,
            $table: $db.ordemServicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PecaTableOrderingComposer extends Composer<_$AppDatabase, $PecaTable> {
  $$PecaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdemServicosTableOrderingComposer get ordemServicoId {
    final $$OrdemServicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordemServicoId,
      referencedTable: $db.ordemServicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicosTableOrderingComposer(
            $db: $db,
            $table: $db.ordemServicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PecaTableAnnotationComposer
    extends Composer<_$AppDatabase, $PecaTable> {
  $$PecaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoProduto, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  $$OrdemServicosTableAnnotationComposer get ordemServicoId {
    final $$OrdemServicosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordemServicoId,
      referencedTable: $db.ordemServicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicosTableAnnotationComposer(
            $db: $db,
            $table: $db.ordemServicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PecaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PecaTable,
          PecaData,
          $$PecaTableFilterComposer,
          $$PecaTableOrderingComposer,
          $$PecaTableAnnotationComposer,
          $$PecaTableCreateCompanionBuilder,
          $$PecaTableUpdateCompanionBuilder,
          (PecaData, $$PecaTableReferences),
          PecaData,
          PrefetchHooks Function({bool ordemServicoId})
        > {
  $$PecaTableTableManager(_$AppDatabase db, $PecaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PecaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PecaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PecaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<TipoProduto> tipo = const Value.absent(),
                Value<double> valor = const Value.absent(),
                Value<int?> ordemServicoId = const Value.absent(),
              }) => PecaCompanion(
                id: id,
                nome: nome,
                descricao: descricao,
                tipo: tipo,
                valor: valor,
                ordemServicoId: ordemServicoId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String descricao,
                required TipoProduto tipo,
                required double valor,
                Value<int?> ordemServicoId = const Value.absent(),
              }) => PecaCompanion.insert(
                id: id,
                nome: nome,
                descricao: descricao,
                tipo: tipo,
                valor: valor,
                ordemServicoId: ordemServicoId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PecaTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({ordemServicoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordemServicoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ordemServicoId,
                                referencedTable: $$PecaTableReferences
                                    ._ordemServicoIdTable(db),
                                referencedColumn: $$PecaTableReferences
                                    ._ordemServicoIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PecaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PecaTable,
      PecaData,
      $$PecaTableFilterComposer,
      $$PecaTableOrderingComposer,
      $$PecaTableAnnotationComposer,
      $$PecaTableCreateCompanionBuilder,
      $$PecaTableUpdateCompanionBuilder,
      (PecaData, $$PecaTableReferences),
      PecaData,
      PrefetchHooks Function({bool ordemServicoId})
    >;
typedef $$ServicoTableCreateCompanionBuilder =
    ServicoCompanion Function({
      Value<int> id,
      required String nome,
      required String descricao,
      required double valor,
    });
typedef $$ServicoTableUpdateCompanionBuilder =
    ServicoCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> descricao,
      Value<double> valor,
    });

final class $$ServicoTableReferences
    extends BaseReferences<_$AppDatabase, $ServicoTable, ServicoData> {
  $$ServicoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $OrdemServicoServicoTable,
    List<OrdemServicoServicoData>
  >
  _ordemServicoServicoRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ordemServicoServico,
        aliasName: 'servico__id__ordem_servico_servico__servico_id',
      );

  $$OrdemServicoServicoTableProcessedTableManager get ordemServicoServicoRefs {
    final manager = $$OrdemServicoServicoTableTableManager(
      $_db,
      $_db.ordemServicoServico,
    ).filter((f) => f.servicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ordemServicoServicoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServicoTableFilterComposer
    extends Composer<_$AppDatabase, $ServicoTable> {
  $$ServicoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ordemServicoServicoRefs(
    Expression<bool> Function($$OrdemServicoServicoTableFilterComposer f) f,
  ) {
    final $$OrdemServicoServicoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ordemServicoServico,
      getReferencedColumn: (t) => t.servicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicoServicoTableFilterComposer(
            $db: $db,
            $table: $db.ordemServicoServico,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServicoTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicoTable> {
  $$ServicoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicoTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicoTable> {
  $$ServicoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  Expression<T> ordemServicoServicoRefs<T extends Object>(
    Expression<T> Function($$OrdemServicoServicoTableAnnotationComposer a) f,
  ) {
    final $$OrdemServicoServicoTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ordemServicoServico,
          getReferencedColumn: (t) => t.servicoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrdemServicoServicoTableAnnotationComposer(
                $db: $db,
                $table: $db.ordemServicoServico,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ServicoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicoTable,
          ServicoData,
          $$ServicoTableFilterComposer,
          $$ServicoTableOrderingComposer,
          $$ServicoTableAnnotationComposer,
          $$ServicoTableCreateCompanionBuilder,
          $$ServicoTableUpdateCompanionBuilder,
          (ServicoData, $$ServicoTableReferences),
          ServicoData,
          PrefetchHooks Function({bool ordemServicoServicoRefs})
        > {
  $$ServicoTableTableManager(_$AppDatabase db, $ServicoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<double> valor = const Value.absent(),
              }) => ServicoCompanion(
                id: id,
                nome: nome,
                descricao: descricao,
                valor: valor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String descricao,
                required double valor,
              }) => ServicoCompanion.insert(
                id: id,
                nome: nome,
                descricao: descricao,
                valor: valor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServicoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordemServicoServicoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ordemServicoServicoRefs) db.ordemServicoServico,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordemServicoServicoRefs)
                    await $_getPrefetchedData<
                      ServicoData,
                      $ServicoTable,
                      OrdemServicoServicoData
                    >(
                      currentTable: table,
                      referencedTable: $$ServicoTableReferences
                          ._ordemServicoServicoRefsTable(db),
                      managerFromTypedResult: (p0) => $$ServicoTableReferences(
                        db,
                        table,
                        p0,
                      ).ordemServicoServicoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.servicoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ServicoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicoTable,
      ServicoData,
      $$ServicoTableFilterComposer,
      $$ServicoTableOrderingComposer,
      $$ServicoTableAnnotationComposer,
      $$ServicoTableCreateCompanionBuilder,
      $$ServicoTableUpdateCompanionBuilder,
      (ServicoData, $$ServicoTableReferences),
      ServicoData,
      PrefetchHooks Function({bool ordemServicoServicoRefs})
    >;
typedef $$OrdemServicoServicoTableCreateCompanionBuilder =
    OrdemServicoServicoCompanion Function({
      required int ordemServicoId,
      required int servicoId,
      Value<int> rowid,
    });
typedef $$OrdemServicoServicoTableUpdateCompanionBuilder =
    OrdemServicoServicoCompanion Function({
      Value<int> ordemServicoId,
      Value<int> servicoId,
      Value<int> rowid,
    });

final class $$OrdemServicoServicoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OrdemServicoServicoTable,
          OrdemServicoServicoData
        > {
  $$OrdemServicoServicoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdemServicosTable _ordemServicoIdTable(_$AppDatabase db) =>
      db.ordemServicos.createAlias(
        'ordem_servico_servico__ordem_servico_id__ordem_servicos__id',
      );

  $$OrdemServicosTableProcessedTableManager get ordemServicoId {
    final $_column = $_itemColumn<int>('ordem_servico_id')!;

    final manager = $$OrdemServicosTableTableManager(
      $_db,
      $_db.ordemServicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordemServicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServicoTable _servicoIdTable(_$AppDatabase db) =>
      db.servico.createAlias('ordem_servico_servico__servico_id__servico__id');

  $$ServicoTableProcessedTableManager get servicoId {
    final $_column = $_itemColumn<int>('servico_id')!;

    final manager = $$ServicoTableTableManager(
      $_db,
      $_db.servico,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_servicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrdemServicoServicoTableFilterComposer
    extends Composer<_$AppDatabase, $OrdemServicoServicoTable> {
  $$OrdemServicoServicoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$OrdemServicosTableFilterComposer get ordemServicoId {
    final $$OrdemServicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordemServicoId,
      referencedTable: $db.ordemServicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicosTableFilterComposer(
            $db: $db,
            $table: $db.ordemServicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicoTableFilterComposer get servicoId {
    final $$ServicoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.servicoId,
      referencedTable: $db.servico,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicoTableFilterComposer(
            $db: $db,
            $table: $db.servico,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdemServicoServicoTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdemServicoServicoTable> {
  $$OrdemServicoServicoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$OrdemServicosTableOrderingComposer get ordemServicoId {
    final $$OrdemServicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordemServicoId,
      referencedTable: $db.ordemServicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicosTableOrderingComposer(
            $db: $db,
            $table: $db.ordemServicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicoTableOrderingComposer get servicoId {
    final $$ServicoTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.servicoId,
      referencedTable: $db.servico,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicoTableOrderingComposer(
            $db: $db,
            $table: $db.servico,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdemServicoServicoTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdemServicoServicoTable> {
  $$OrdemServicoServicoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$OrdemServicosTableAnnotationComposer get ordemServicoId {
    final $$OrdemServicosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ordemServicoId,
      referencedTable: $db.ordemServicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdemServicosTableAnnotationComposer(
            $db: $db,
            $table: $db.ordemServicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicoTableAnnotationComposer get servicoId {
    final $$ServicoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.servicoId,
      referencedTable: $db.servico,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicoTableAnnotationComposer(
            $db: $db,
            $table: $db.servico,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdemServicoServicoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdemServicoServicoTable,
          OrdemServicoServicoData,
          $$OrdemServicoServicoTableFilterComposer,
          $$OrdemServicoServicoTableOrderingComposer,
          $$OrdemServicoServicoTableAnnotationComposer,
          $$OrdemServicoServicoTableCreateCompanionBuilder,
          $$OrdemServicoServicoTableUpdateCompanionBuilder,
          (OrdemServicoServicoData, $$OrdemServicoServicoTableReferences),
          OrdemServicoServicoData,
          PrefetchHooks Function({bool ordemServicoId, bool servicoId})
        > {
  $$OrdemServicoServicoTableTableManager(
    _$AppDatabase db,
    $OrdemServicoServicoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdemServicoServicoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdemServicoServicoTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OrdemServicoServicoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> ordemServicoId = const Value.absent(),
                Value<int> servicoId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdemServicoServicoCompanion(
                ordemServicoId: ordemServicoId,
                servicoId: servicoId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int ordemServicoId,
                required int servicoId,
                Value<int> rowid = const Value.absent(),
              }) => OrdemServicoServicoCompanion.insert(
                ordemServicoId: ordemServicoId,
                servicoId: servicoId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrdemServicoServicoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordemServicoId = false, servicoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ordemServicoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ordemServicoId,
                                referencedTable:
                                    $$OrdemServicoServicoTableReferences
                                        ._ordemServicoIdTable(db),
                                referencedColumn:
                                    $$OrdemServicoServicoTableReferences
                                        ._ordemServicoIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (servicoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.servicoId,
                                referencedTable:
                                    $$OrdemServicoServicoTableReferences
                                        ._servicoIdTable(db),
                                referencedColumn:
                                    $$OrdemServicoServicoTableReferences
                                        ._servicoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrdemServicoServicoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdemServicoServicoTable,
      OrdemServicoServicoData,
      $$OrdemServicoServicoTableFilterComposer,
      $$OrdemServicoServicoTableOrderingComposer,
      $$OrdemServicoServicoTableAnnotationComposer,
      $$OrdemServicoServicoTableCreateCompanionBuilder,
      $$OrdemServicoServicoTableUpdateCompanionBuilder,
      (OrdemServicoServicoData, $$OrdemServicoServicoTableReferences),
      OrdemServicoServicoData,
      PrefetchHooks Function({bool ordemServicoId, bool servicoId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EnderecoTableTableManager get endereco =>
      $$EnderecoTableTableManager(_db, _db.endereco);
  $$PessoaTableTableManager get pessoa =>
      $$PessoaTableTableManager(_db, _db.pessoa);
  $$CargoTableTableManager get cargo =>
      $$CargoTableTableManager(_db, _db.cargo);
  $$FuncionarioTableTableManager get funcionario =>
      $$FuncionarioTableTableManager(_db, _db.funcionario);
  $$ClienteTableTableManager get cliente =>
      $$ClienteTableTableManager(_db, _db.cliente);
  $$PessoaJuridicaTableTableManager get pessoaJuridica =>
      $$PessoaJuridicaTableTableManager(_db, _db.pessoaJuridica);
  $$PessoaFisicaTableTableManager get pessoaFisica =>
      $$PessoaFisicaTableTableManager(_db, _db.pessoaFisica);
  $$EquipamentoTableTableManager get equipamento =>
      $$EquipamentoTableTableManager(_db, _db.equipamento);
  $$OrdemServicosTableTableManager get ordemServicos =>
      $$OrdemServicosTableTableManager(_db, _db.ordemServicos);
  $$PecaTableTableManager get peca => $$PecaTableTableManager(_db, _db.peca);
  $$ServicoTableTableManager get servico =>
      $$ServicoTableTableManager(_db, _db.servico);
  $$OrdemServicoServicoTableTableManager get ordemServicoServico =>
      $$OrdemServicoServicoTableTableManager(_db, _db.ordemServicoServico);
}
