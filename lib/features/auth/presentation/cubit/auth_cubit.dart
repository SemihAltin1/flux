import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flux/core/helpers/dio_helper.dart';
import 'package:flux/features/auth/data/models/login_request.dart';
import 'package:flux/features/auth/data/models/register_request.dart';
import 'package:flux/features/auth/domain/use_cases/login.dart';
import 'package:flux/features/auth/domain/use_cases/send_reset_password_link.dart';
import 'package:flux/features/auth/presentation/cubit/auth_state.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../service_locator.dart';
import '../../domain/use_cases/register.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signIn(LoginRequest request) async {
    emit(AuthLoading());

    final isConnected = await _checkInternetConnection();
    if(isConnected == false) {
      emit(AuthError("Please check your internet connection before sign up."));
      return;
    }

    final result = await serviceLocator<LoginUseCase>().execute(params: request);

    if (result is DataSuccess) {
      final token = result.data!.token;
      if(token == null) {
        emit(AuthError("Registration failed"));
      } else {
        DioHelper.saveToken(token);
        emit(Authenticated());
      }
    } else if (result is DataFailed) {
      emit(AuthError(result.errorMessage ?? "Sign in failed"));
    }
  }

  Future<void> signUp(RegisterRequest request) async {
    emit(AuthLoading());
    final isConnected = await _checkInternetConnection();
    if(isConnected == false) {
      emit(AuthError("Please check your internet connection before sign up."));
      return;
    }

    final result = await serviceLocator<RegisterUseCase>().execute(params: request);

    if (result is DataSuccess) {
      final token = result.data!.token;
      if(token == null) {
        emit(AuthError("Registration failed"));
      } else {
        DioHelper.saveToken(token);
        emit(Authenticated());
      }
    } else if (result is DataFailed) {
      emit(AuthError(result.errorMessage ?? "Registration failed"));
    }
  }

  Future<void> sendResetPasswordLink(String email) async {
    emit(AuthLoading());

    final result = await serviceLocator<SendResetPasswordLinkUseCase>().execute(params: email);

    if (result is DataSuccess) {
      emit(PasswordResetEmailSent());
    } else if (result is DataFailed) {
      emit(AuthError(result.errorMessage ?? "Link couldn't be sent"));
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