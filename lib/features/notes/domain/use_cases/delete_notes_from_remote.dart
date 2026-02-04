import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/notes/domain/repository/notes_repository.dart';
import 'package:flux/service_locator.dart';

final class DeleteNotesFromRemoteUseCase implements UseCase<DataState<bool>, List<int>> {
  @override
  Future<DataState<bool>> execute({List<int>? params}) {
    return serviceLocator<NotesRepository>().deleteNotesFromRemote(params!);
  }
}