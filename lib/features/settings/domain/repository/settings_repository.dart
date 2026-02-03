import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/auth/data/models/user_model.dart';
import '../../data/models/update_password_request.dart';
import '../../data/models/update_profile_request.dart';

abstract class SettingsRepository {
  Future<DataState<UserModel>> updateProfile(UpdateProfileRequest req);
  Future<DataState<bool>> updatePassword(UpdatePasswordRequest req);
  Future<DataState<bool>> deleteAccount();
}