abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class AuthenticationException extends AppException {
  const AuthenticationException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}
