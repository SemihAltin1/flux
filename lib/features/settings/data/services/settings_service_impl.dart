import 'package:dio/dio.dart';
import 'package:flux/core/constants/constants.dart';
import 'package:flux/core/helpers/dio_helper.dart';
import 'package:flux/features/settings/data/services/settings_service.dart';
import '../models/update_password_request.dart';
import '../models/update_profile_request.dart';

final class SettingsServiceImpl implements SettingsService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseApiURL));

  @override
  Future<Response> deleteAccount() async {
    final header = await DioHelper.getHeader();
    final res = await _dio.delete(
      "/api/profile/deleteAccount",
      options: Options(headers: header)
    );
    return res;
  }

  @override
  Future<Response> updatePassword(UpdatePasswordRequest req) async {
    final header = await DioHelper.getHeader();
    final data = {
      "current_password": req.currentPassword,
      "new_password": req.newPassword,
      "new_password_confirmation": req.newPasswordConfirmation,
    };
    final res = await _dio.put(
      "/api/profile/updatePassword",
      data: data,
      options: Options(headers: header),
    );
    return res;
  }

  @override
  Future<Response> updateProfile(UpdateProfileRequest req) async {
    final header = await DioHelper.getHeader();
    final data = {
      "first_name": req.firstName,
      "last_name": req.lastName,
    };
    final res = await _dio.put(
      "/api/profile/updateProfile",
      data: data,
      options: Options(headers: header),
    );
    return res;
  }

}