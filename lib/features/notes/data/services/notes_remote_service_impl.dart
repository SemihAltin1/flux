import 'package:dio/dio.dart';
import 'package:flux/core/constants/constants.dart';
import 'package:flux/core/helpers/dio_helper.dart';
import 'package:flux/features/notes/data/models/note_model.dart';
import 'package:flux/features/notes/data/services/notes_remote_service.dart';

final class NotesRemoteServiceImpl implements NotesRemoteService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseApiURL));

  @override
  Future<Response> deleteNotes(List<int> noteIds) async {
    final header = await DioHelper.getHeader();
    final data = {
      "note_ids": noteIds
    };
    final res = await _dio.delete(
      "/api/notes/bulk",
      data: data,
      options: Options(headers: header),
    );
    return res;
  }

  @override
  Future<Response> getNotes() async {
    final header = await DioHelper.getHeader();
    final res = await _dio.get(
      "/api/notes/",
      options: Options(headers: header),
    );
    return res;
  }

  @override
  Future<Response> saveNotes(List<NoteModel> notes) async {
    final header = await DioHelper.getHeader();
    final data = {
      "notes": notes.map((note) => note.toMap()).toList(),
    };
    final res = await _dio.post(
      "/api/notes/bulk",
      data: data,
      options: Options(headers: header),
    );
    return res;
  }

  @override
  Future<Response> updateNotes(List<NoteModel> notes) async {
    final header = await DioHelper.getHeader();
    final data = {
      "notes": notes.map((note) => note.toMap()).toList(),
    };
    final res = await _dio.put(
      "/api/notes/bulk",
      data: data,
      options: Options(headers: header),
    );
    return res;
  }

}