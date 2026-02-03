import 'package:flux/features/auth/data/models/user_model.dart';

sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}
final class SettingsLoading extends SettingsState {}
final class SettingsOperationSuccess extends SettingsState {}

final class SettingsProfileLoaded extends SettingsState {
  final UserModel user;
  SettingsProfileLoaded(this.user);
}

final class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
}

final class SignedOut extends SettingsState {}