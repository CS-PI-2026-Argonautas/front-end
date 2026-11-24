import 'package:cloud_firestore/cloud_firestore.dart';

class WorkOrder {
  final String id;

  final String name;
  final String part;
  final String equipment;
  final String client;
  final String address;
  final String assignee;
  final DateTime date;
  final String status;
  final String report;
  final DateTime? createdAt;
  final String city;
  final bool equipamentoBloqueado;
  final DateTime? dataSaida;

  bool isDeleted;

  WorkOrder({
    required this.id,
    required this.name,
    required this.part,
    required this.equipment,
    required this.client,
    required this.address,
    required this.assignee,
    required this.date,
    required this.status,
    required this.report,
    required this.city,
    this.createdAt,
    this.isDeleted = false,
    this.dataSaida,
    bool equipamentoBloqueado = false,
  }) : equipamentoBloqueado = equipamentoBloqueado || statusBloqueia(status);

  static bool statusBloqueia(String status) {
    return status == 'ENTREGUE' || status == 'PAGA';
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (equipamentoBloqueado) 'equipamento_bloqueado': true,

      if (dataSaida != null) 'data_saida': Timestamp.fromDate(dataSaida!),
      'name': name,
      'part': part,
      'equipment': equipment,
      'client': client,
      'address': address,
      'assignee': assignee,
      'date': Timestamp.fromDate(date),
      'status': status,
      'report': report,
      'created_at': FieldValue.serverTimestamp(),
      'city': city,
      'deleted_at': isDeleted ? FieldValue.serverTimestamp() : null,
    };
  }

  factory WorkOrder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return WorkOrder(
      equipamentoBloqueado: data['equipamento_bloqueado'] == true,
      dataSaida: (data['data_saida'] as Timestamp?)?.toDate(),
      id: document.id,
      name: data['name'] as String,
      part: data['part'] as String,
      equipment: data['equipment'] as String,
      client: data['client'] as String,
      address: data['address'] as String,
      assignee: data['assignee'] as String,
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] as String,
      report: data['report'] as String,
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      city: data['city'] as String,
      isDeleted: data['deleted_at'] != null,
    );
  }
}
