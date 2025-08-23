import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/models/note_model.dart';

part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial());

  addNote(NoteModel note){

  }
  // void addNote(String note) async {
  //   emit(AddNoteLoading());
  //   try {
  //     // simulate saving note
  //     await Future.delayed(const Duration(seconds: 1));
  //     emit(AddNoteSuccess());
  //   } catch (e) {
  //     emit(AddNoteFailure(e.toString()));
  //   }
  // }
}
