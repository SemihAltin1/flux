import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/auth/data/models/user_model.dart';
import 'package:flux/features/settings/data/models/update_profile_request.dart';
import 'package:flux/features/settings/domain/repository/settings_repository.dart';
import 'package:flux/service_locator.dart';

final class UpdateProfileUseCase implements UseCase<DataState<UserModel>, UpdateProfileRequest> {

  @override
  Future<DataState<UserModel>> execute({UpdateProfileRequest? params}) {
    return serviceLocator<SettingsRepository>().updateProfile(params!);
  }

}