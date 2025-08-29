import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubits/notes_cubit/notes_cubit.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/widgets/custom_app_bar.dart';
import 'package:notes_app/views/widgets/custom_text_field.dart';

class EditNoteViewBody extends StatefulWidget {
  const EditNoteViewBody({Key? key, required this.note}) : super(key: key);

  final NoteModel note;

  @override
  State<EditNoteViewBody> createState() => _EditNoteViewBodyState();
}

class _EditNoteViewBodyState extends State<EditNoteViewBody> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  late String oldTitle;
  late String oldContent;

  @override
  void initState() {
    super.initState();
    oldTitle = widget.note.title;
    oldContent = widget.note.subTitle;
    titleController = TextEditingController(text: oldTitle);
    contentController = TextEditingController(text: oldContent);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  bool get isEdited {
    return titleController.text != oldTitle ||
        contentController.text != oldContent;
  }

  Future<bool> _onWillPop() async {
    if (isEdited) {
      final action = await showModalBottomSheet<String>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "You have unsaved changes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text("Discard"),
                      onPressed: () {
                        Navigator.pop(context, "discard");
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Save"),
                      onPressed: () {
                        Navigator.pop(context, "save");
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

      if (action == "save") {
        _saveNote();
        return true; // بعد الحفظ يخرج
      } else if (action == "discard") {
        return true; // يخرج من غير حفظ
      } else {
        return false; // لو Cancel ما يعملش خروج
      }
    } else {
      return true; // مفيش تعديل → يخرج عادي
    }
  }

  void _saveNote() {
    widget.note.title = titleController.text;
    widget.note.subTitle = contentController.text;
    widget.note.save(); // Hive save
    BlocProvider.of<NotesCubit>(context).fetchAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 50),
            CustomAppBar(
              onPressed: () {
                _saveNote();
                Navigator.pop(context);
              },
              title: 'Edit Note',
              icon: Icons.check,
            ),
            const SizedBox(height: 50),
            CustomTextField(
              controller: titleController,
              hint: 'Title',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: contentController,
              hint: 'Content',
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
