final class UpdatePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const UpdatePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });
}