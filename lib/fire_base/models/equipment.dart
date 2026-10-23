import 'package:cloud_firestore/cloud_firestore.dart';

class Equipment {
  String? id;
  final String brand;
  final String model;
  final String serialNumber;
  final String administrativeOrder;
  final String inmetroNumber;
  final String verificationNumber;
  final String previousStamp;
  final String currentStamp;
  final String previousSeal;
  final String currentSeal;
  final DateTime createdAt;

  Equipment({
    this.id,
    required this.brand,
    required this.model,
    required this.serialNumber,
    required this.administrativeOrder,
    required this.inmetroNumber,
    required this.verificationNumber,
    required this.previousStamp,
    required this.currentStamp,
    required this.previousSeal,
    required this.currentSeal,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toFirestore() {
    return {
      'brand': brand,
      'model': model,
      'serial_number': serialNumber,
      'administrative_order': administrativeOrder,
      'inmetro_number': inmetroNumber,
      'verification_number': verificationNumber,
      'previous_stamp': previousStamp,
      'current_stamp': currentStamp,
      'previous_seal': previousSeal,
      'current_seal': currentSeal,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory Equipment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return Equipment(
      id: doc.id,
      brand: (data['brand'] ?? '').toString(),
      model: (data['model'] ?? '').toString(),
      serialNumber: (data['serial_number'] ?? '').toString(),
      administrativeOrder: (data['administrative_order'] ?? '').toString(),
      inmetroNumber: (data['inmetro_number'] ?? '').toString(),
      verificationNumber: (data['verification_number'] ?? '').toString(),
      previousStamp: (data['previous_stamp'] ?? '').toString(),
      currentStamp: (data['current_stamp'] ?? '').toString(),
      previousSeal: (data['previous_seal'] ?? '').toString(),
      currentSeal: (data['current_seal'] ?? '').toString(),
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
