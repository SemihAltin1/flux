import 'package:flux/features/auth/data/repository/auth_repository_impl.dart';
import 'package:flux/features/auth/data/services/auth_service.dart';
import 'package:flux/features/auth/data/services/auth_service_impl.dart';
import 'package:flux/features/auth/domain/repository/auth_repository.dart';
import 'package:flux/features/auth/domain/use_cases/get_current_user.dart';
import 'package:flux/features/auth/domain/use_cases/login.dart';
import 'package:flux/features/auth/domain/use_cases/register.dart';
import 'package:flux/features/auth/domain/use_cases/send_reset_password_link.dart';
import 'package:flux/features/auth/domain/use_cases/sign_out.dart';
import 'package:flux/features/notes/data/repository/notes_repository_impl.dart';
import 'package:flux/features/notes/data/services/notes_local_service.dart';
import 'package:flux/features/notes/data/services/notes_local_service_impl.dart';
import 'package:flux/features/notes/data/services/notes_remote_service.dart';
import 'package:flux/features/notes/data/services/notes_remote_service_impl.dart';
import 'package:flux/features/notes/domain/repository/notes_repository.dart';
import 'package:flux/features/notes/domain/use_cases/delete_all_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/delete_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/get_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/delete_notes_from_remote.dart';
import 'package:flux/features/notes/domain/use_cases/get_deleted_notes.dart';
import 'package:flux/features/notes/domain/use_cases/get_notes_from_remote.dart';
import 'package:flux/features/notes/domain/use_cases/get_unsynced_notes.dart';
import 'package:flux/features/notes/domain/use_cases/hard_delete_notes_from_local.dart';
import 'package:flux/features/notes/domain/use_cases/restore_note.dart';
import 'package:flux/features/notes/domain/use_cases/save_notes_to_local.dart';
import 'package:flux/features/notes/domain/use_cases/save_notes_to_remote.dart';
import 'package:flux/features/notes/domain/use_cases/update_notes_to_local.dart';
import 'package:flux/features/notes/domain/use_cases/update_notes_to_remote.dart';
import 'package:flux/features/settings/data/repository/settings_repository_impl.dart';
import 'package:flux/features/settings/data/services/settings_service.dart';
import 'package:flux/features/settings/data/services/settings_service_impl.dart';
import 'package:flux/features/settings/domain/repository/settings_repository.dart';
import 'package:flux/features/settings/domain/use_cases/delete_account.dart';
import 'package:flux/features/settings/domain/use_cases/update_password.dart';
import 'package:flux/features/settings/domain/use_cases/update_profile.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {

  // SERVICES
  serviceLocator.registerSingleton<AuthService>(AuthServiceImpl());
  serviceLocator.registerSingleton<SettingsService>(SettingsServiceImpl());
  serviceLocator.registerSingleton<NotesLocalService>(NotesLocalServiceImpl());
  serviceLocator.registerSingleton<NotesRemoteService>(NotesRemoteServiceImpl());

  // REPOSITORIES
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  serviceLocator.registerSingleton<SettingsRepository>(SettingsRepositoryImpl());
  serviceLocator.registerSingleton<NotesRepository>(NotesRepositoryImpl());

  //USE CASES
  /// Auth
  serviceLocator.registerSingleton<GetCurrentUserUseCase>(GetCurrentUserUseCase());
  serviceLocator.registerSingleton<LoginUseCase>(LoginUseCase());
  serviceLocator.registerSingleton<RegisterUseCase>(RegisterUseCase());
  serviceLocator.registerSingleton<SignOutUseCase>(SignOutUseCase());
  serviceLocator.registerSingleton<SendResetPasswordLinkUseCase>(SendResetPasswordLinkUseCase());

  /// Settings
  serviceLocator.registerSingleton<UpdateProfileUseCase>(UpdateProfileUseCase());
  serviceLocator.registerSingleton<UpdatePasswordUseCase>(UpdatePasswordUseCase());
  serviceLocator.registerSingleton<DeleteAccountUseCase>(DeleteAccountUseCase());

  /// Notes
  serviceLocator.registerSingleton<GetNotesFromLocalUseCase>(GetNotesFromLocalUseCase());
  serviceLocator.registerSingleton<SaveNotesToLocalUseCase>(SaveNotesToLocalUseCase());
  serviceLocator.registerSingleton<UpdateNotesToLocalUseCase>(UpdateNotesToLocalUseCase());
  serviceLocator.registerSingleton<DeleteNotesFromLocalUseCase>(DeleteNotesFromLocalUseCase());
  serviceLocator.registerSingleton<DeleteAllNotesFromLocalUseCase>(DeleteAllNotesFromLocalUseCase());
  serviceLocator.registerSingleton<GetDeletedNotesUseCase>(GetDeletedNotesUseCase());
  serviceLocator.registerSingleton<GetUnsyncedNotesUseCase>(GetUnsyncedNotesUseCase());
  serviceLocator.registerSingleton<HardDeleteNotesFromLocalUseCase>(HardDeleteNotesFromLocalUseCase());
  serviceLocator.registerSingleton<RestoreNoteUseCase>(RestoreNoteUseCase());

  serviceLocator.registerSingleton<DeleteNotesFromRemoteUseCase>(DeleteNotesFromRemoteUseCase());
  serviceLocator.registerSingleton<GetNotesFromRemoteUseCase>(GetNotesFromRemoteUseCase());
  serviceLocator.registerSingleton<SaveNotesToRemoteUseCase>(SaveNotesToRemoteUseCase());
  serviceLocator.registerSingleton<UpdateNotesToRemoteUseCase>(UpdateNotesToRemoteUseCase());
}