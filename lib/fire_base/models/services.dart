import 'package:cloud_firestore/cloud_firestore.dart';

class Services {
  final String id;

  final String name;
  final String part;
  final String equipment;
  final String client;
  final String assignee;
  final DateTime date;
  final String status;
  final String report;
  final DateTime? createdAt;
  final String city;

  bool isDeleted;

  Services({
    required this.id,
    required this.name,
    required this.part,
    required this.equipment,
    required this.client,
    required this.assignee,
    required this.date,
    required this.status,
    required this.report,
    required this.city,
    this.createdAt,
    this.isDeleted = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'part': part,
      'equipment': equipment,
      'client': client,
      'assignee': assignee,
      'date': Timestamp.fromDate(date),
      'status': status,
      'report': report,
      'created_at': FieldValue.serverTimestamp(),
      'city': city,
      'deleted_at': isDeleted ? FieldValue.serverTimestamp() : null,
    };
  }

  factory Services.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return Services(
      id: document.id,
      name: data['name'] as String,
      part: data['part'] as String,
      equipment: data['equipment'] as String,
      client: data['client'] as String,
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