import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flux/features/notes/presentation/pages/create_note_page.dart';
import 'package:flux/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:intl/intl.dart';
import '../../../../config/assets/app_icons.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../data/models/category_model.dart';
import '../../data/models/note_model.dart';
import '../cubit/ai_cubit.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

final class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatButton(context),
      body: BlocListener<NotesCubit, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 20),
          children: [
            _header(context),
            const SizedBox(height: 20),
            _searchBar(context),
            const SizedBox(height: 20),
            _categories(context),
            _buildNotesContent(),
          ],
        ),
      ),
    );
  }

  //region - UI COMPONENTS
  Widget _buildNotesContent() {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NotesLoaded) {
          if (state.notes.isEmpty) {
            return _emptyView();
          }
          return _notesList(state.notes);
        }
        return const SizedBox();
      },
    );
  }

  Widget _searchBar(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 14),
      onChanged: (value) => context.read<NotesCubit>().fetchNotesFromLocal(search: value),
      decoration: const InputDecoration(
        hintText: "Search your notes",
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _categories(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        String selectedId = (state is NotesLoaded) ? state.selectedCategoryId : "0";

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: ListView.builder(
            scrollDirection: .horizontal,
            itemCount: CategoryModel.categories.length + 1,
            itemBuilder: (context, index) {
              final String categoryId = index == 0 ? "0" : CategoryModel.categories[index - 1].id!;
              final String name = index == 0 ? "All" : CategoryModel.categories[index - 1].name ?? "";
              final bool isSelected = selectedId == categoryId;

              return GestureDetector(
                onTap: () => context.read<NotesCubit>().changeCategory(categoryId),
                child: Container(
                  height: 40,
                  margin: const .only(right: 12),
                  padding: const .symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: .all(
                      width: 1,
                      color: isSelected ? AppColors.primary : theme.dividerColor,
                    ),
                  ),
                  alignment: .center,
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _notesList(List<NoteModel> notes) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const .only(top: 20),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: notes.length,
      itemBuilder: (listContext, index) {
        return _noteCard(listContext, notes[index]);
      },
    );
  }

  Widget _noteCard(BuildContext context, NoteModel note) {
    final theme = Theme.of(context);

    String plainTextContent;
    try {
      final json = jsonDecode(note.content ?? "");
      plainTextContent = quill.Document.fromJson(json).toPlainText().trim();
    } catch (e) {
      plainTextContent = note.content ?? "";
    }

    final DateTime updatedAt = DateTime.parse(note.updatedAt ?? "");
    final String formattedDate = DateFormat.yMMMd().format(updatedAt);

    return GestureDetector(
      onLongPress: () => _showNoteOptions(context, note),
      onTap: () => _navigateToCreatePage(context, note: note),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: .circular(16),
          border: .all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              plainTextContent,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.watch_later_outlined, size: 12, color: theme.textTheme.bodyMedium?.color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (note.isPinned == 1)
                  ImageIcon(
                    AssetImage(AppIcons.pin),
                    size: 16,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Flux",
            style: TextStyle(
              fontSize: 24,
              fontWeight: .bold,
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SettingsCubit(),
                  child: const SettingsPage(),
                ),
              ),
            );
          },
          child: Container(
            width: 30,
            height: 30,
            padding: const .all(6),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: .circle,
            ),
            alignment: .center,
            child: ImageIcon(
              AssetImage(AppIcons.settings),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  FloatingActionButton _floatButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToCreatePage(context),
      backgroundColor: AppColors.primary,
      child: ImageIcon(
        AssetImage(AppIcons.add),
        color: Colors.white,
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Padding(
        padding: const .only(top: 100, right: 30, left: 30),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                shape: .circle,
              ),
              alignment: .center,
              child: const Icon(
                Icons.note_alt_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "No notes found",
              style: TextStyle(fontSize: 16, fontWeight: .w500),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap the plus button below to start your journey with Flux.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  //endregion

  //region - DIALOGS
  void _showNoteOptions(BuildContext context, NoteModel note) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  note.isPinned == 1 ? Icons.push_pin : Icons.push_pin_outlined,
                  color: note.isPinned == 1 ? AppColors.primary : null,
                ),
                title: Text(note.isPinned == 1 ? "Unpin Note" : "Pin Note"),
                onTap: () {
                  final updatedNote = note.copyWith(isPinned: note.isPinned == 1 ? 0 : 1, isSynced: 2);
                  context.read<NotesCubit>().updateNoteToLocal(updatedNote);
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text("Edit Note"),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _navigateToCreatePage(context, note: note);
                },
              ),
              ListTile(
                leading: const Icon(Icons.category_outlined),
                title: const Text("Change Category"),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showCategorySelection(context, note);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text("Delete", style: TextStyle(color: Colors.red)),
                onTap: () {
                  context.read<NotesCubit>().deleteNoteToLocal(note.id!);
                  Navigator.pop(bottomSheetContext);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showCategorySelection(BuildContext context, NoteModel note) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20)),
      ),
      builder: (dialogContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              const SizedBox(height: 8),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: .circular(2))),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Select Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),

              ...CategoryModel.categories.map((category) {
                final bool isSelected = note.categoryId == category.id;

                return ListTile(
                  leading: Icon(
                    Icons.label_outline,
                    color: isSelected ? AppColors.primary : null,
                  ),
                  title: Text(
                    category.name ?? "",
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    final updatedNote = note.copyWith(categoryId: category.id, isSynced: 2);
                    context.read<NotesCubit>().updateNoteToLocal(updatedNote);
                    Navigator.pop(dialogContext);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
  //endregion

  //region - FUNCTIONS
  void _navigateToCreatePage(BuildContext context, {NoteModel? note}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<NotesCubit>()),
            BlocProvider(create: (context) => AICubit()),
          ],
          child: CreateNotePage(noteModel: note),
        ),
      ),
    );
  }
  //endregion

}
