import '../../data/models/note_model.dart';

sealed class NotesState {}

final class NotesInitial extends NotesState {}
final class NotesLoading extends NotesState {}

final class NotesLoaded extends NotesState {
  final List<NoteModel> notes;
  final String selectedCategoryId;

  NotesLoaded(this.notes, {this.selectedCategoryId = "0"});
}

final class NotesError extends NotesState {
  final String message;
  NotesError(this.message);
}