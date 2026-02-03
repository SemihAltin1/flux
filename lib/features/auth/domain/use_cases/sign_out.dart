import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/auth/domain/repository/auth_repository.dart';
import 'package:flux/service_locator.dart';

final class SignOutUseCase implements UseCase<DataState<bool>, void> {
  @override
  Future<DataState<bool>> execute({void params}) {
    return serviceLocator<AuthRepository>().signOut();
  }
}