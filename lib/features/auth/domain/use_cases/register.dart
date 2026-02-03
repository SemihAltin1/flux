import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/auth/data/models/login_request.dart';
import 'package:flux/features/auth/data/models/register_request.dart';
import 'package:flux/features/auth/domain/repository/auth_repository.dart';
import 'package:flux/service_locator.dart';

final class RegisterUseCase implements UseCase<DataState<LoginResponse>, RegisterRequest> {

  @override
  Future<DataState<LoginResponse>> execute({RegisterRequest? params}) {
    return serviceLocator<AuthRepository>().register(params!);
  }

}