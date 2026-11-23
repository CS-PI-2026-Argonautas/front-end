class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
  });

  final String uid;
  final String name;
  final String surname;
  final String email;

  Map<String, dynamic> toMap() {
    return {'name': name, 'surname': surname, 'email': email};
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      uid: id,
      name: map['name'] as String,
      surname: map['surname'] as String,
      email: map['email'] as String,
    );
  }
}
