import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/fire_base/exceptions/login_exception.dart';

class AuthenticationService {
  final _auth = FirebaseAuth.instance;

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'INVALID_LOGIN_CREDENTIALS':
          throw AuthException('Email ou senha incorretos');
        default:
          throw AuthException('Erro ao entrar');
      }
    }
  }
}
