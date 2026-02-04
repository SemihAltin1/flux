import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/notes/data/models/note_model.dart';
import 'package:flux/features/notes/domain/repository/notes_repository.dart';
import 'package:flux/service_locator.dart';

final class SaveNotesToRemoteUseCase implements UseCase<DataState<List<NoteModel>>, List<NoteModel>> {
  @override
  Future<DataState<List<NoteModel>>> execute({List<NoteModel>? params}) {
    return serviceLocator<NotesRepository>().saveNotesToRemote(params!);
  }
}