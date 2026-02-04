import 'package:dio/dio.dart';
import 'package:flux/features/notes/data/models/note_model.dart';

abstract class NotesRemoteService {
  Future<Response> saveNotes(List<NoteModel> notes);
  Future<Response> deleteNotes(List<int> noteIds);
  Future<Response> updateNotes(List<NoteModel> notes);
  Future<Response> getNotes();
}