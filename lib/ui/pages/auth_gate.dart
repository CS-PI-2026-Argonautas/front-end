import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/fire_base/services/authentication_service.dart';
import 'package:frontend/ui/pages/authentication.dart';
import 'package:frontend/ui/pages/dashboard.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AuthenticationService();

    return StreamBuilder<User?>(
      stream: service.authStateChanges(),
      initialData: service.currentUser,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Authentication();
        }

        return const Dashboard();
      },
    );
  }
}
