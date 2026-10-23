class LoginException implements Exception {
  final String message;
  final int? statusCode;

  const LoginException(this.message, {this.statusCode});

  @override
  String toString() => 'LoginException: [$statusCode] $message';
}
