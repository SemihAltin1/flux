sealed class AIState {}

final class AIInitial extends AIState {}
final class AILoading extends AIState {}
final class AISuccess extends AIState {
  final String result;
  AISuccess(this.result);
}
final class AIError extends AIState {
  final String message;
  AIError(this.message);
}