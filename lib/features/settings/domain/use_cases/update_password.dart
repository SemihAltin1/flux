import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/settings/data/models/update_password_request.dart';
import 'package:flux/features/settings/domain/repository/settings_repository.dart';
import 'package:flux/service_locator.dart';

final class UpdatePasswordUseCase implements UseCase<DataState<bool>, UpdatePasswordRequest> {

  @override
  Future<DataState<bool>> execute({UpdatePasswordRequest? params}) {
    return serviceLocator<SettingsRepository>().updatePassword(params!);
  }

}