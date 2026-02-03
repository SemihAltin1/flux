import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/auth/data/models/user_model.dart';

import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';

abstract class AuthRepository {

  Future<DataState<LoginResponse>> login(LoginRequest req);
  Future<DataState<LoginResponse>> register(RegisterRequest req);
  Future<DataState<bool>> sendResetPasswordLink(String email);
  Future<DataState<UserModel>> getProfile();
  Future<DataState<bool>> signOut();

}