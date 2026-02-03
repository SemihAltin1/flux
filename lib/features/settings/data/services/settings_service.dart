import 'package:dio/dio.dart';
import 'package:flux/features/settings/data/models/update_profile_request.dart';
import '../models/update_password_request.dart';

abstract class SettingsService {
  Future<Response> updateProfile(UpdateProfileRequest req);
  Future<Response> updatePassword(UpdatePasswordRequest req);
  Future<Response> deleteAccount();
}