import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/Enums/StatusOrderService.dart';
import 'package:frontend/fire_base/models/address.dart';
import 'package:frontend/fire_base/models/client.dart';
import 'package:frontend/fire_base/models/os_exeption.dart';
import 'package:uuid/uuid.dart';

String _text(Object? value) => (value ?? '').toString().trim();

String? _textOrNull(Object? value) {
  final text = value?.toString().trim();
  return (text == null || text.isEmpty) ? null : text;
}

Timestamp? _timestamp(Object? value) => value is Timestamp ? value : null;

int _integer(Object? value) => value is num ? value.toInt() : 0;

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

List<Map<String, dynamic>> _list(Object? value) {
  if (value is! List) return <Map<String, dynamic>>[];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

class ServiceOrder {
  static const int reportLimit = 256;

  final String id;

  ServiceOrderStatus status;

  ServiceOrderStatus? statusBeforeCancellation;

  bool equipmentBlocked;

  DateTime entryDate;
  DateTime? exitDate;
  String report;

  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;

  final ServiceOrderExecutor executor;
  final ServiceProvider serviceProvider;

  ServiceOrderEquipment? equipment;

  ServiceOrderClient? client;
  ServiceAddress? serviceAddress;

  List<ServiceOrderPart> parts;
  List<ServiceOrderService> services;

  int globalFeeCents;
  int globalDiscountCents;

  bool persisted;

  String? _savedState;

  ServiceOrder({
    String? id,
    this.status = ServiceOrderStatus.EM_ORCAMENTO,
    this.statusBeforeCancellation,
    this.equipmentBlocked = false,
    DateTime? entryDate,
    this.exitDate,
    this.report = '',
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    ServiceOrderExecutor? executor,
    ServiceProvider? serviceProvider,
    this.equipment,
    this.client,
    this.serviceAddress,
    List<ServiceOrderPart>? parts,
    List<ServiceOrderService>? services,
    this.globalFeeCents = 0,
    this.globalDiscountCents = 0,
    this.persisted = false,
  }) : id = id ?? const Uuid().v4(),
       entryDate = entryDate ?? DateTime.now(),
       executor = executor ?? ServiceOrderExecutor(),
       serviceProvider = serviceProvider ?? ServiceProvider(),
       parts = parts ?? [],
       services = services ?? [];

  factory ServiceOrder.createNew() {
    final serviceOrder = ServiceOrder();
    serviceOrder._registerState();
    return serviceOrder;
  }

  bool get active => deletedAt == null;

  ServiceOrderValues get values => ServiceOrderValues.calculate(
    parts: parts,
    services: services,
    globalFeeCents: globalFeeCents,
    globalDiscountCents: globalDiscountCents,
  );

  void changeStatus(ServiceOrderStatus newStatus) {
    if (newStatus == status) return;

    if (newStatus == ServiceOrderStatus.CANCELADA) {
      statusBeforeCancellation = status;
    }

    if (newStatus.leavesWorkshop) {
      equipmentBlocked = true;
      exitDate ??= DateTime.now();
    }

    status = newStatus;
  }

  void setClient(Client newStatus) {
    if (client?.id != newStatus.id) {
      serviceAddress = null;
    }
    client = ServiceOrderClient.fromClient(newStatus);
  }

  void setServiceAddress( Address address) {
    if (client == null) {
      throw const InvalidAddressException(
        'Selecione um cliente antes de escolher o endereço de serviço.',
      );
    }
    serviceAddress = ServiceAddress.fromAddress(address);
  }

  String _signature() => toFirestore().toString();

  void _registerState() => _savedState = _signature();

  void markAsSaved() {
    persisted = true;
    _registerState();
  }

  bool get hasUnsavedChanges =>
      _savedState == null || _savedState != _signature();

  Map<String, dynamic> toFirestore() {
    final equipmentData = equipment;

    return {
      'status': status.value,
      'status_antes_cancelamento': statusBeforeCancellation?.value,
      'equipamento_bloqueado': equipmentBlocked,
      'data_entrada': Timestamp.fromDate(entryDate),
      'data_saida': exitDate == null ? null : Timestamp.fromDate(exitDate!),
      'relatorio': report.trim(),
      'executor': executor.toFirestore(),
      'permissionaria': serviceProvider.toFirestore(),
      'equipamento': (equipmentData == null || equipmentData.isEmpty) ? null : equipmentData.toFirestore(),
      'cliente': client?.toFirestore(),
      'endereco_servico': serviceAddress?.toFirestore(),
      'pecas': parts.map((part) => part.toFirestore()).toList(),
      'servicos': services.map((service) => service.toFirestore()).toList(),
      'valores': values.toFirestore(),
      'deleted_at': deletedAt,
    };
  }

  factory ServiceOrder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final values = _map(data['valores']);
    final clientMap = _map(data['cliente']);
    final addressMap = _map(data['endereco_servico']);
    final equipmentMap = _map(data['equipamento']);
    final previousStatus = _textOrNull(data['status_antes_cancelamento']);

    final serviceOrder = ServiceOrder(
  id: doc.id,
  status: ServiceOrderStatusX.from(_textOrNull(data['status'])),
  statusBeforeCancellation: previousStatus == null
      ? null
      : ServiceOrderStatusX.from(previousStatus),
  equipmentBlocked: data['equipamento_bloqueado'] == true,
  entryDate: _timestamp(data['data_entrada'])?.toDate(),
  exitDate: _timestamp(data['data_saida'])?.toDate(),
  report: _text(data['relatorio']),
  createdAt: _timestamp(data['created_at']),
  updatedAt: _timestamp(data['updated_at']),
  deletedAt: _timestamp(data['deleted_at']),
  executor: ServiceOrderExecutor.fromMap(_map(data['executor'])),
  serviceProvider: ServiceProvider.fromMap(
    _map(data['permissionaria']),
  ),
  equipment: equipmentMap.isEmpty
      ? null
      : ServiceOrderEquipment.fromMap(equipmentMap),
  client: clientMap.isEmpty
      ? null
      : ServiceOrderClient.fromMap(clientMap),
  serviceAddress: addressMap.isEmpty
      ? null
      : ServiceAddress.fromMap(addressMap),
  parts: _list(data['pecas']).map(ServiceOrderPart.fromMap).toList(),
  services: _list(data['servicos'])
      .map(ServiceOrderService.fromMap)
      .toList(),
  globalFeeCents: _integer(values['taxa_global_centavos']),
  globalDiscountCents: _integer(values['desconto_global_centavos']),
);

serviceOrder.markAsSaved();
return serviceOrder;}

  static String? optionalText(Object? value) => _textOrNull(value);
}

class ServiceOrderExecutor {
  final String id;
  final String name;
  final String identityDocument;

  ServiceOrderExecutor({
    this.id = '00000000-0000-4000-8000-000000000001',
    this.name = 'Rodrigo Bernadelli',
    this.identityDocument = '1234567890',
  });

  factory ServiceOrderExecutor.fromMap(Map<String, dynamic> data) {
    final defaultValue = ServiceOrderExecutor();

    return ServiceOrderExecutor(
      id: _textOrNull(data['id']) ?? defaultValue.id,
      name: _textOrNull(data['nome']) ?? defaultValue.name,
      identityDocument:
          _textOrNull(data['documento_identidade']) ??
          defaultValue.identityDocument,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'nome': name,
    'documento_identidade': identityDocument,
  };
}

class ServiceProvider {
  final String id;
  final String businessName;
  final String cnpj;
  final String phone;
  final String email;

  final Map<String, dynamic> address;

  ServiceProvider({
    this.id = '00000000-0000-4000-8000-000000000002',
    this.businessName = 'Bernadelli Exemplo LTDA',
    this.cnpj = '1234567890',
    this.phone = '(44) 987654-3210',
    this.email = 'teste@example.com',
    Map<String, dynamic>? address,
  }) : address = address ?? defaultAddress;

  static const Map<String, dynamic> defaultAddress = {
    'logradouro': 'Rua Paraná',
    'numero': '100',
    'cidade': 'Paranavaí',
    'uf': 'PR',
    'cep': '87701-000',
  };

  factory ServiceProvider.fromMap(Map<String, dynamic> data) {
    final defaultValue = ServiceProvider();
    final savedAddress = _map(data['endereco']);

    return ServiceProvider(
      id: _textOrNull(data['id']) ?? defaultValue.id,
      businessName:
          _textOrNull(data['nome_empresarial']) ?? defaultValue.businessName,
      cnpj: _textOrNull(data['cnpj']) ?? defaultValue.cnpj,
      phone: _textOrNull(data['telefone']) ?? defaultValue.phone,
      email: _textOrNull(data['email']) ?? defaultValue.email,
      address: savedAddress.isEmpty ? null : savedAddress,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'nome_empresarial': businessName,
    'cnpj': cnpj,
    'telefone': phone,
    'email': email,
    'endereco': Map<String, dynamic>.from(address),
  };
}

class ServiceOrderEquipment {
  final String? brand;
  final String? model;
  final String? serialNumber;
  final String? inmetroNumber;
  final String? ordinance;
  final String? verificationNumber;
  final String? previousSeal;
  final String? currentSeal;
  final String? previousLock;
  final String? currentLock;

  ServiceOrderEquipment({
    this.brand,
    this.model,
    this.serialNumber,
    this.inmetroNumber,
    this.ordinance,
    this.verificationNumber,
    this.previousSeal,
    this.currentSeal,
    this.previousLock,
    this.currentLock,
  });

  factory ServiceOrderEquipment.fromMap(Map<String, dynamic> data) {
    return ServiceOrderEquipment(
      brand: _textOrNull(data['marca']),
      model: _textOrNull(data['modelo']),
      serialNumber: _textOrNull(data['numero_serie']),
      inmetroNumber: _textOrNull(data['numero_inmetro']),
      ordinance: _textOrNull(data['portaria']),
      verificationNumber: _textOrNull(data['numero_verificacao']),
      previousSeal: _textOrNull(data['selo_anterior']),
      currentSeal: _textOrNull(data['selo_atual']),
      previousLock: _textOrNull(data['lacre_anterior']),
      currentLock: _textOrNull(data['lacre_atual']),
    );
  }

  bool get isEmpty => toFirestore().values.every((value) => value == null);

  Map<String, dynamic> toFirestore() => {
    'marca': _textOrNull(brand),
    'modelo': _textOrNull(model),
    'numero_serie': _textOrNull(serialNumber),
    'numero_inmetro': _textOrNull(inmetroNumber),
    'portaria': _textOrNull(ordinance),
    'numero_verificacao': _textOrNull(verificationNumber),
    'selo_anterior': _textOrNull(previousSeal),
    'selo_atual': _textOrNull(currentSeal),
    'lacre_anterior': _textOrNull(previousLock),
    'lacre_atual': _textOrNull(currentLock),
  };
}

class ServiceOrderClient {
  final String id;
  final String name;
  final String personType;
  final String document;
  final String phone;
  final String? email;

  ServiceOrderClient({
    required this.id,
    required this.name,
    required this.personType,
    required this.document,
    required this.phone,
    this.email,
  });

  factory ServiceOrderClient.fromClient(Client client) {
    return ServiceOrderClient(
      id: client.id,
      name: client.name,
      personType: client.personType.value,
      document: client.document,
      phone: client.contact.phone,
      email: _textOrNull(client.contact.email),
    );
  }

  factory ServiceOrderClient.fromMap(Map<String, dynamic> data) {
    return ServiceOrderClient(
      id: _text(data['id']),
      name: _text(data['nome']),
      personType: _text(data['tipo_pessoa']),
      document: _text(data['documento']),
      phone: _text(data['telefone']),
      email: _textOrNull(data['email']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'nome': name,
    'tipo_pessoa': personType,
    'documento': document,
    'telefone': phone,
    'email': email,
  };
}

class ServiceAddress {
  final String id;
  final String street;
  final String? number;
  final String? complement;
  final String city;
  final String state;
  final String? postalCode;

  ServiceAddress({
    required this.id,
    required this.street,
    this.number,
    this.complement,
    required this.city,
    required this.state,
    this.postalCode,
  });

factory ServiceAddress.fromAddress(Address address) {
  return ServiceAddress(
    id: address.id,
    street: address.publicPlace,
    number: _textOrNull(address.number),
    complement: _textOrNull(address.complement),
    city: address.city,
    state: address.uf.name,
    postalCode: _textOrNull(address.zipCode),
  );
}

  factory ServiceAddress.fromMap(Map<String, dynamic> data) {
    return ServiceAddress(
      id: _text(data['id']),
      street: _text(data['logradouro']),
      number: _textOrNull(data['numero']),
      complement: _textOrNull(data['complemento']),
      city: _text(data['cidade']),
      state: _text(data['uf']),
      postalCode: _textOrNull(data['cep']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'logradouro': street,
    'numero': number,
    'complemento': complement,
    'cidade': city,
    'uf': state,
    'cep': postalCode,
  };
}

class ServiceOrderPart {
  final String partId;
  final String name;
  final int quantity;
  final int unitPriceCents;

  final int discountCents;

  ServiceOrderPart({
    required this.partId,
    required this.name,
    required this.quantity,
    required this.unitPriceCents,
    this.discountCents = 0,
  }) {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantidade', 'Mínimo 1.');
    }
    if (unitPriceCents < 0) {
      throw ArgumentError.value(
        unitPriceCents,
        'valorUnitarioCentavos',
        'Não pode ser negativo.',
      );
    }
    if (discountCents < 0) {
      throw ArgumentError.value(
        discountCents,
        'descontoCentavos',
        'Não pode ser negativo.',
      );
    }
  }

  factory ServiceOrderPart.fromMap(Map<String, dynamic> data) {
    final quantity = _integer(data['quantidade']);

    return ServiceOrderPart(
      partId: _text(data['peca_id']),
      name: _text(data['nome']),
      quantity: quantity < 1 ? 1 : quantity,
      unitPriceCents: _integer(data['valor_unitario_centavos']),
      discountCents: _integer(data['desconto_centavos']),
    );
  }

  int get grossSubtotalCents => quantity * unitPriceCents;

  int get subtotalCents => grossSubtotalCents - discountCents;

  ServiceOrderPart withQuantity(int novaQuantidade) {
    return ServiceOrderPart(
      partId: partId,
      name: name,
      quantity: novaQuantidade,
      unitPriceCents: unitPriceCents,
      discountCents: discountCents,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'peca_id': partId,
    'nome': name,
    'quantidade': quantity,
    'valor_unitario_centavos': unitPriceCents,
    'desconto_centavos': discountCents,
  };
}

class ServiceOrderService {
  final String serviceId;
  final String description;
  final int valueCents;

  final int discountCents;

  ServiceOrderService({
    required this.serviceId,
    required this.description,
    required this.valueCents,
    this.discountCents = 0,
  }) {
    if (valueCents < 0) {
      throw ArgumentError.value(
        valueCents,
        'valorCentavos',
        'Não pode ser negativo.',
      );
    }
    if (discountCents < 0) {
      throw ArgumentError.value(
        discountCents,
        'descontoCentavos',
        'Não pode ser negativo.',
      );
    }
  }

  factory ServiceOrderService.fromMap(Map<String, dynamic> data) {
    return ServiceOrderService(
      serviceId: _text(data['servico_id']),
      description: _text(data['descricao']),
      valueCents: _integer(data['valor_centavos']),
      discountCents: _integer(data['desconto_centavos']),
    );
  }

  int get subtotalCents => valueCents - discountCents;

  Map<String, dynamic> toFirestore() => {
    'servico_id': serviceId,
    'descricao': description,
    'valor_centavos': valueCents,
    'desconto_centavos': discountCents,
  };
}

class ServiceOrderValues {
  final int partsSubtotalCents;
  final int servicesSubtotalCents;
  final int globalFeeCents;
  final int globalDiscountCents;
  final int totalCents;

  const ServiceOrderValues({
    required this.partsSubtotalCents,
    required this.servicesSubtotalCents,
    required this.globalFeeCents,
    required this.globalDiscountCents,
    required this.totalCents,
  });

  factory ServiceOrderValues.calculate({
    required List<ServiceOrderPart> parts,
    required List<ServiceOrderService> services,
    required int globalFeeCents,
    required int globalDiscountCents,
  }) {
    final partsSubtotal = parts.fold<int>(
      0,
      (total, part) => total + part.subtotalCents,
    );

    final servicesSubtotal = services.fold<int>(
      0,
      (total, service) => total + service.subtotalCents,
    );

    final total =
        partsSubtotal +
        servicesSubtotal +
        globalFeeCents -
        globalDiscountCents;

    return ServiceOrderValues(
      partsSubtotalCents: partsSubtotal,
      servicesSubtotalCents: servicesSubtotal,
      globalFeeCents: globalFeeCents,
      globalDiscountCents: globalDiscountCents,
      totalCents: total,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'subtotal_pecas_centavos': partsSubtotalCents,
    'subtotal_servicos_centavos': servicesSubtotalCents,
    'taxa_global_centavos': globalFeeCents,
    'desconto_global_centavos': globalDiscountCents,
    'total_centavos': totalCents,
  };
}
