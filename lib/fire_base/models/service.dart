class Service {
  String? id;
  String name;
  String description;
  int valueInCents;

  Service({
    this.id,
    required this.name,
    required this.description,
    required this.valueInCents,
  });

  factory Service.fromMap(Map<String, dynamic> map, {String? idDocumento}) {
    return Service(
      id: idDocumento ?? map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      valueInCents: map['value_in_cents']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'description': description, 'value_in_cents': valueInCents};
  }
}
