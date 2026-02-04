import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/notes/data/models/note_model.dart';
import 'package:flux/features/notes/domain/repository/notes_repository.dart';
import 'package:flux/service_locator.dart';

final class UpdateNotesToRemoteUseCase implements UseCase<DataState<bool>, List<NoteModel>> {
  @override
  Future<DataState<bool>> execute({List<NoteModel>? params}) {
    return serviceLocator<NotesRepository>().updateNotesToRemote(params!);
  }
}