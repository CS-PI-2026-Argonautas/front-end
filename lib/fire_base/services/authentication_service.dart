import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/fire_base/exceptions/login_exception.dart';
import 'package:frontend/fire_base/models/app_user.dart';
import 'package:frontend/fire_base/repositories/app_user_repository.dart';
import 'package:frontend/firebase_options.dart';

class AuthenticationService {
  static const _accountCreationAppName = 'criacao-de-conta';

  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> logout() => _auth.signOut();

  Future<void> signin({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    final app = await _accountCreationApp();
    final auth = FirebaseAuth.instanceFor(app: app);

    try {
      final UserCredential userCredential;

      try {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'weak-password':
            throw AuthException('Senha fraca');
          case 'invalid-email':
            throw AuthException('Email inválido');
          case 'email-already-in-use':
            throw AuthException('Email já cadastrado');
          case 'network-request-failed':
            throw AuthException('Sem conexão com a internet');
          default:
            throw AuthException('Erro ao criar a conta');
        }
      }

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException('Erro ao criar a conta');
      }

      final user = AppUser(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        surname: surname,
      );

      final userRepository = AppUserRepository();

      try {
        await userRepository.save(user);
      } on FirebaseException {
        try {
          await firebaseUser.delete();
        } on FirebaseAuthException {
          // Se o delete falhar, a conta fica no Auth sem documento; o erro abaixo ainda avisa o usuário.
        }
        throw AuthException('Erro ao salvar os dados do usuário');
      }
    } finally {
      await auth.signOut();
    }
  }

  Future<FirebaseApp> _accountCreationApp() async {
    for (final app in Firebase.apps) {
      if (app.name == _accountCreationAppName) return app;
    }

    return Firebase.initializeApp(
      name: _accountCreationAppName,
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          throw AuthException('Email ou senha incorretos');
        case 'invalid-email':
          throw AuthException('Email inválido');
        case 'user-disabled':
          throw AuthException('Conta desativada');
        case 'too-many-requests':
          throw AuthException('Muitas tentativas. Tente novamente mais tarde');
        case 'network-request-failed':
          throw AuthException('Sem conexão com a internet');
        default:
          throw AuthException('Erro ao entrar');
      }
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.setLanguageCode('pt');
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthException('Email inválido');
        case 'too-many-requests':
          throw AuthException('Muitas tentativas. Tente novamente mais tarde');
        case 'network-request-failed':
          throw AuthException('Sem conexão com a internet');
        default:
          throw AuthException('Erro ao enviar o e-mail');
      }
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw AuthException('Sessão expirada. Entre novamente');
    }

    try {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        ),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
          throw AuthException('Senha atual incorreta');
        case 'too-many-requests':
          throw AuthException('Muitas tentativas. Tente novamente mais tarde');
        case 'network-request-failed':
          throw AuthException('Sem conexão com a internet');
        default:
          throw AuthException('Erro ao alterar a senha');
      }
    }

    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw AuthException('Senha fraca');
        case 'requires-recent-login':
          throw AuthException('Entre novamente para alterar a senha');
        case 'network-request-failed':
          throw AuthException('Sem conexão com a internet');
        default:
          throw AuthException('Erro ao alterar a senha');
      }
    }
  }
}
