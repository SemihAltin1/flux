sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {}
final class Unauthenticated extends AuthState {}
final class PasswordResetEmailSent extends AuthState {}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}