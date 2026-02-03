import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/notes/domain/repository/notes_repository.dart';
import 'package:flux/service_locator.dart';

final class DeleteAllNotesUseCase implements UseCase<DataState<bool>, void> {
  @override
  Future<DataState<bool>> execute({void params}) {
    return serviceLocator<NotesRepository>().deleteAllNotes();
  }
}