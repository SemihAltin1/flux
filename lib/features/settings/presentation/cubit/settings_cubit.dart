import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/resources/data_state.dart';
import 'package:flux/features/auth/domain/use_cases/get_current_user.dart';
import 'package:flux/features/auth/domain/use_cases/sign_out.dart';
import 'package:flux/features/notes/domain/use_cases/delete_all_notes_from_local.dart';
import 'package:flux/features/settings/data/models/update_password_request.dart';
import 'package:flux/features/settings/data/models/update_profile_request.dart';
import 'package:flux/features/settings/domain/use_cases/update_password.dart';
import 'package:flux/features/settings/domain/use_cases/update_profile.dart';
import 'package:flux/features/settings/presentation/cubit/settings_state.dart';
import 'package:flux/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  Future<void> updateProfile(UpdateProfileRequest request) async {
    emit(SettingsLoading());

    final connection = await _checkInternetConnection();
    if(connection == false) {
      emit(SettingsError("Please check your internet connection"));
      return;
    }

    final result = await serviceLocator<UpdateProfileUseCase>().execute(params: request);
    if(result is DataSuccess) {
      final user = result.data;
      if(user == null) {
        emit(SettingsError("User not found"));
      } else {
        emit(SettingsOperationSuccess());
        getProfile();
      }
    } else if(result is DataFailed) {
      emit(SettingsError(result.errorMessage ?? "Profile couldn't be updated"));
    }
  }

  Future<void> updatePassword(UpdatePasswordRequest request) async {
    emit(SettingsLoading());

    final connection = await _checkInternetConnection();
    if(connection == false) {
      emit(SettingsError("Please check your internet connection"));
      return;
    }

    final result = await serviceLocator<UpdatePasswordUseCase>().execute(params: request);
    if(result is DataSuccess) {
      final user = result.data;
      if(user == null) {
        emit(SettingsError("User not found"));
      } else {
        emit(SettingsOperationSuccess());
        getProfile();
      }
    } else if(result is DataFailed) {
      emit(SettingsError(result.errorMessage ?? "Password couldn't be updated"));
    }
  }

  Future<void> deleteAccount() async {

  }

  Future<void> getProfile() async {
    emit(SettingsLoading());

    final result = await serviceLocator<GetCurrentUserUseCase>().execute();
    if(result is DataSuccess) {
      final user = result.data;
      if(user == null) {
        emit(SettingsError("User not found"));
      } else {
        emit(SettingsProfileLoaded(user));
      }
    } else if(result is DataFailed) {
      emit(SettingsError(result.errorMessage ?? "User not found"));
    }

  }

  Future<void> signOut() async {
    emit(SettingsLoading());
    final result = await serviceLocator<SignOutUseCase>().execute();
    if(result is DataSuccess) {
      SharedPreferences shared = await SharedPreferences.getInstance();
      shared.remove("token");
      await serviceLocator<DeleteAllNotesFromLocalUseCase>().execute();
      emit(SignedOut());
    }
  }

  Future<bool> _checkInternetConnection() async {
    final Connectivity connectivity = Connectivity();
    final List<ConnectivityResult> results = await connectivity.checkConnectivity();
    if (results.any((result) => result != ConnectivityResult.none)) {
      return true;
    }
    return false;
  }

}