import 'package:flux/features/auth/data/models/user_model.dart';

final class LoginRequest {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});
}

final class LoginResponse {
  final String? token;
  final UserModel? user;

  const LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String,dynamic> json) => LoginResponse(
    token: json["token"],
    user: UserModel.fromJson(json["user"]),
  );
}