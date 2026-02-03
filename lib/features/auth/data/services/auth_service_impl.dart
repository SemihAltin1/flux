import 'package:dio/dio.dart';
import 'package:flux/core/constants/constants.dart';
import 'package:flux/core/helpers/dio_helper.dart';
import 'package:flux/features/auth/data/models/login_request.dart';
import 'package:flux/features/auth/data/models/register_request.dart';
import 'auth_service.dart';

final class AuthServiceImpl implements AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseApiURL));

  @override
  Future<Response> login(LoginRequest req) async {
    final data = {
      "email": req.email,
      "password": req.password,
    };
    final res = await _dio.post(
      "/api/auth/login",
      data: data,
      options: Options(headers: DioHelper.defaultHeader()),
    );
    return res;
  }

  @override
  Future<Response> register(RegisterRequest req) async {
    final data = {
      "first_name": req.firstName,
      "last_name": req.lastName,
      "email": req.email,
      "password": req.password,
      "password_confirmation": req.password,
    };
    final res = await _dio.post(
      "/api/auth/register",
      data: data,
      options: Options(headers: DioHelper.defaultHeader()),
    );
    return res;
  }

  @override
  Future<Response> sendResetPasswordLink(String email) async {
    final data = {"email": email};
    final res = await _dio.post(
      "/api/auth/sendPasswordResetLink",
      data: data,
      options: Options(headers: DioHelper.defaultHeader()),
    );
    return res;
  }

  @override
  Future<Response> getProfile() async {
    final header = await DioHelper.getHeader();
    final res = await _dio.get(
      "/api/auth/getProfile",
      options: Options(headers: header),
    );
    return res;
  }

  @override
  Future<Response> signOut() async {
    final header = await DioHelper.getHeader();
    final res = await _dio.post(
      "/api/auth/logout",
      options: Options(headers: header),
    );
    return res;
  }

  
}