import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/auth/data/models/user_model.dart';
import 'package:flux/features/auth/domain/repository/auth_repository.dart';
import 'package:flux/service_locator.dart';

final class GetCurrentUserUseCase implements UseCase<DataState<UserModel>, void> {

  @override
  Future<DataState<UserModel>> execute({void params}) {
    return serviceLocator<AuthRepository>().getProfile();
  }

}