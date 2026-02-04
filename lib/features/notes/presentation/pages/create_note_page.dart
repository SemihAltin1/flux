import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flux/common/widgets/custom_dialogs.dart';
import 'package:flux/common/widgets/default_app_bar.dart';
import 'package:flux/config/assets/app_icons.dart';
import 'package:flux/config/theme/app_colors.dart';
import 'package:flux/features/notes/presentation/cubit/ai_cubit.dart';
import 'package:flux/features/notes/presentation/cubit/ai_state.dart';
import 'package:lottie/lottie.dart';
import '../../data/models/category_model.dart';
import '../../data/models/note_model.dart';
import '../cubit/notes_cubit.dart';

final class CreateNotePage extends StatefulWidget {
  final NoteModel? noteModel;
  const CreateNotePage({super.key, this.noteModel});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

final class _CreateNotePageState extends State<CreateNotePage> {
  late final QuillController _controller;
  late String _selectedCategoryId;
  late int _isPinned;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _selectedCategoryId = widget.noteModel?.categoryId ?? "0";
    _isPinned = widget.noteModel?.isPinned ?? 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _saveNote();
        }
      },
      child: BlocListener<AICubit, AIState>(
        listener: (context, state) {
          if (state is AISuccess) {
            _controller.document.insert(
                _controller.document.length - 1,
                "\n\n--- AI Suggestion ---\n${state.result}");
          } else if (state is AIError) {
            CustomDialogs.showErrorDialog(context, "New Note", state.message);
          }
        },
        child: BlocBuilder<AICubit, AIState>(
          builder: (context, state) {
            final bool isLoading = state is AILoading;

            return Stack(
              children: [
                Scaffold(
                  appBar: _appBar(),
                  floatingActionButton: isLoading ? null : _floatButton(),
                  body: SafeArea(
                    child: Column(
                      children: [
                        _notePad(),
                        _toolBar(),
                      ],
                    ),
                  ),
                ),

                if (isLoading)
                  _loadingAnimation(),
              ],
            );
          },
        ),
      ),
    );
  }

  //region - UI COMPONENTS
  AppBar _appBar() {
    return defaultAppBar(
      title: "New Note",
      actions: [
        IconButton(
          onPressed: () => _showNoteOptions(),
          icon: const Icon(
            Icons.info_outline,
            color: AppColors.primary,
          ),
        ),
      ]
    );
  }

  Widget _notePad() {
    return Expanded(
      child: QuillEditor.basic(
        controller: _controller,
        config: const QuillEditorConfig(
          placeholder: 'Write your note here...',
          padding: EdgeInsets.all(16),
          scrollable: true,
        ),
      ),
    );
  }

  Widget _toolBar() {
    final theme = Theme.of(context);

    return QuillSimpleToolbar(
      controller: _controller,
      config: QuillSimpleToolbarConfig(
        color: theme.scaffoldBackgroundColor,
        multiRowsDisplay: false,
        showFontFamily: false,
        showFontSize: false,
        showColorButton: false,
        showBackgroundColorButton: false,
        showAlignmentButtons: false,
        showSmallButton: false,
        showInlineCode: false,
        showSubscript: false,
        showSuperscript: false,
        showDirection: false,
        showUndo: true,
        showRedo: true,
      ),
    );
  }

  Widget _floatButton() {
    return Padding(
      padding: const .only(bottom: 50),
      child: FloatingActionButton(
        onPressed: () => _showAIActionMenu(),
        backgroundColor: AppColors.primary,
        child: ImageIcon(
          AssetImage(AppIcons.ai),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _loadingAnimation() {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      alignment: .center,
      child: Container(
        width: 200,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(20),
        ),
        alignment: .center,
        child: Column(
          mainAxisAlignment: .center,
          spacing: 5,
          children: [
            Lottie.asset(
              "assets/animation/clock_animation.json",
              width: 90,
              height: 90,
            ),
            const Material(
              child: Text(
                "Generating with AI",
                textAlign: .center,
              ),
            ),
          ],
        ),
      ),
    );
  }
  //endregion

  //region - DIALOGS
  void _showNoteOptions() {
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


              if (widget.noteModel != null)
                ListTile(
                  leading: Icon(
                    _isPinned == 1 ? Icons.push_pin : Icons.push_pin_outlined,
                    color: _isPinned == 1 ? AppColors.primary : null,
                  ),
                  title: Text(_isPinned == 1 ? "Unpin Note" : "Pin Note"),
                  onTap: () {
                    _isPinned = _isPinned == 0 ? 1 : 0;
                    Navigator.pop(bottomSheetContext);
                  },
                ),

              ListTile(
                leading: const Icon(Icons.category_outlined),
                title: const Text("Change Category"),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showCategorySelection();
                },
              ),

              if (widget.noteModel != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text("Delete", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    if(widget.noteModel?.id != null) context.read<NotesCubit>().deleteNoteToLocal(widget.noteModel!.id!);
                    Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showCategorySelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              const SizedBox(height: 8),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Select Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),

              ...CategoryModel.categories.map((category) {
                final bool isSelected = _selectedCategoryId == category.id;

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
                    _selectedCategoryId = category.id ?? "0";
                    Navigator.pop(context);
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

  void _showAIActionMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Generate With AI", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.summarize_outlined),
              title: const Text("Summarize with AI"),
              onTap: () => _handleAIAction("Summarize this note in 3 bullet points"),
            ),
            ListTile(
              leading: const Icon(Icons.auto_fix_high),
              title: const Text("Fix Grammar & Style"),
              onTap: () => _handleAIAction("Fix the grammar and make this note sound more professional"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAIAction(String prompt) async {
    Navigator.pop(context);
    final currentContent = _controller.document.toPlainText();
    context.read<AICubit>().processContent(prompt, currentContent);
  }
  //endregion

  //region - FUNCTIONS
  void _saveNote() {
    final String plainText = _controller.document.toPlainText().trim();

    if (plainText.isEmpty) return;

    final String content = jsonEncode(_controller.document.toDelta().toJson());
    final String title = plainText.split('\n').first;
    final String now = DateTime.now().toIso8601String();

    if (widget.noteModel != null) {
      if (widget.noteModel!.content == content && widget.noteModel!.categoryId == _selectedCategoryId && widget.noteModel!.isPinned == _isPinned) return;
      final updatedNote = NoteModel(
        id: widget.noteModel!.id,
        remoteId: widget.noteModel!.remoteId,
        title: title.length > 30 ? "${title.substring(0, 30)}..." : title,
        content: content,
        createdAt: widget.noteModel!.createdAt,
        updatedAt: now,
        isPinned: _isPinned,
        categoryId: _selectedCategoryId,
        isSynced: 2,
      );
      context.read<NotesCubit>().updateNoteToLocal(updatedNote);
    } else {
      final note = NoteModel(
        title: title.length > 30 ? "${title.substring(0, 30)}..." : title,
        content: content,
        createdAt: now,
        updatedAt: now,
        categoryId: _selectedCategoryId,
        isSynced: 1,
      );
      context.read<NotesCubit>().addNoteToLocal(note);
    }
  }

  void _initializeController() {
    if (widget.noteModel != null) {
      try {
        final content = jsonDecode(widget.noteModel!.content ?? "");
        _controller = QuillController(
          document: Document.fromJson(content),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _controller = QuillController.basic();
      }
    } else {
      _controller = QuillController.basic();
    }
  }
  //endregion
}