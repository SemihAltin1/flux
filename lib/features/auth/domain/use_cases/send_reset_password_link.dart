import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/auth/domain/repository/auth_repository.dart';
import 'package:flux/service_locator.dart';

final class SendResetPasswordLinkUseCase implements UseCase<DataState<bool>, String> {

  @override
  Future<DataState<bool>> execute({String? params}) {
    return serviceLocator<AuthRepository>().sendResetPasswordLink(params!);
  }

}