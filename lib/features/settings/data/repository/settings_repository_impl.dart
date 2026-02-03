import 'package:dio/dio.dart';
import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/auth/data/models/user_model.dart';
import 'package:flux/features/settings/data/models/update_password_request.dart';
import 'package:flux/features/settings/data/models/update_profile_request.dart';
import 'package:flux/features/settings/data/services/settings_service.dart';
import 'package:flux/features/settings/domain/repository/settings_repository.dart';
import 'package:flux/service_locator.dart';

final class SettingsRepositoryImpl extends SettingsRepository {
  final _service = serviceLocator<SettingsService>();
  
  @override
  Future<DataState<bool>> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<DataState<bool>> updatePassword(UpdatePasswordRequest req) async {
    try {
      await _service.updatePassword(req);
      return const DataSuccess(true);
    } on DioException catch(e) {
      final message = e.response?.data["message"] ?? "Password couldn't be updated";
      return DataFailed(message);
    } catch(_) {
      return const DataFailed("Password couldn't be updated");
    }
  }

  @override
  Future<DataState<UserModel>> updateProfile(UpdateProfileRequest req) async {
    try {
      final res = await _service.updateProfile(req);
      final decodedData = UserModel.fromJson(res.data["data"]);
      return DataSuccess(decodedData);
    } on DioException catch(e) {
      final message = e.response?.data["message"] ?? "Profile couldn't be updated";
      return DataFailed(message);
    } catch(_) {
      return const DataFailed("Profile couldn't be updated");
    }
  }
  
}