import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/app_user.dart';

class AppUserRepository {
  final _db = FirebaseFirestore.instance
      .collection('users')
      .withConverter(
        fromFirestore: (snapshot, _) =>
            AppUser.fromMap(snapshot.data()!, snapshot.id),
        toFirestore: (appUser, _) => appUser.toMap(),
      );

  Future<void> save(AppUser user) async {
    await _db.doc(user.uid).set(user);
  }
}
