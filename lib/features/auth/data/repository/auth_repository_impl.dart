import 'package:dio/dio.dart';
import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/auth/data/models/login_request.dart';
import 'package:flux/features/auth/data/models/register_request.dart';
import 'package:flux/features/auth/data/models/user_model.dart';
import 'package:flux/features/auth/data/services/auth_service.dart';
import 'package:flux/features/auth/domain/repository/auth_repository.dart';
import 'package:flux/service_locator.dart';

final class AuthRepositoryImpl extends AuthRepository {
  final _service = serviceLocator<AuthService>();

  @override
  Future<DataState<UserModel>> getProfile() async {
    try {
      final res = await _service.getProfile();
      final decodedData = UserModel.fromJson(res.data["data"]["user"]);
      return DataSuccess(decodedData);
    } catch(_) {
      return const DataFailed("User not found");
    }
  }

  @override
  Future<DataState<LoginResponse>> login(LoginRequest req) async {
    try {
      final res = await _service.login(req);
      final decodedData = LoginResponse.fromJson(res.data["data"]);
      return DataSuccess(decodedData);
    } on DioException catch(e) {
      final message = e.response?.data["message"] ?? "The operation couldn't be completed";
      return DataFailed(message);
    } catch(_) {
      return const DataFailed("Check your email address and password");
    }
  }

  @override
  Future<DataState<LoginResponse>> register(RegisterRequest req) async {
    try {
      final res = await _service.register(req);
      final decodedData = LoginResponse.fromJson(res.data["data"]);
      return DataSuccess(decodedData);
    } on DioException catch(e) {
      final message = e.response?.data["message"] ?? "The operation couldn't be completed";
      return DataFailed(message);
    } catch(_) {
      return const DataFailed("The operation couldn't be completed");
    }
  }

  @override
  Future<DataState<bool>> sendResetPasswordLink(String email) async {
    try {
      await _service.sendResetPasswordLink(email);
      return const DataSuccess(true);
    } catch(_) {
      return const DataFailed("The link couldn't be sent");
    }
  }

  @override
  Future<DataState<bool>> signOut() async {
    try {
      await _service.signOut();
      return const DataSuccess(true);
    } on DioException catch(e) {
      final message = e.response?.data["message"] ?? "The operation couldn't be completed";
      return DataFailed(message);
    } catch(_) {
      return const DataFailed("The operation couldn't be completed");
    }
  }

}