import 'package:dio/dio.dart';
import 'package:flux/features/auth/data/models/login_request.dart';
import 'package:flux/features/auth/data/models/register_request.dart';

abstract class AuthService {

  Future<Response> login(LoginRequest req);
  Future<Response> register(RegisterRequest req);
  Future<Response> sendResetPasswordLink(String email);
  Future<Response> getProfile();
  Future<Response> signOut();

}