import 'package:flux/core/resources/data_state.dart';
import 'package:flux/core/use_case/use_case.dart';
import 'package:flux/features/notes/data/models/get_notes_request.dart';
import 'package:flux/features/notes/data/models/note_model.dart';
import 'package:flux/features/notes/domain/repository/notes_repository.dart';
import 'package:flux/service_locator.dart';

final class GetNotesFromLocalUseCase implements UseCase<DataState<List<NoteModel>>, GetNotesRequest> {
  @override
  Future<DataState<List<NoteModel>>> execute({GetNotesRequest? params}) {
    return serviceLocator<NotesRepository>().getNotes(params!);
  }
}