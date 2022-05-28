import 'package:flutter/material.dart';

import '../helper/database_helper.dart';
import '../models/lable_model.dart';
import '../models/notes_model.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class NotesProvider with ChangeNotifier {
  // database instance
  final dbHelper = DatabaseHelper.instance;

  // notes lists
  List<NotesModel> notesList = [];
  List<NotesModel> searchNotesList = [];

  //lable list
  List<LableModel> lableList = [];

  // search notes
  searchNotes(String value) {
    searchNotesList = notesList
        .where(
          (element) =>
              element.title!.toLowerCase().contains(
                    value.toLowerCase(),
                  ) ||
              element.notes!.toLowerCase().contains(
                    value.toLowerCase(),
                  ),
        )
        .toList();
    notifyListeners();
  }

  // get notes
  getNotesData() async {
    notesList = await dbHelper.getNotes();
    searchNotesList = notesList;
    notifyListeners();
  }

  // insert note
  insertNote(BuildContext context, NotesModel note) async {
    dbHelper.insertNote(note).then(
      (value) {
        note.id = value;
        notesList.add(note);
        searchNotesList = notesList;
        notifyListeners();
        Navigator.pop(context);
        showSnackBar(context, Constants.noteAddedMsg);
      },
    );
  }

  // update note
  updateNote(BuildContext context, NotesModel note) {
    dbHelper.updateNote(note).then(
      (value) {
        int index = notesList.indexWhere((element) => element.id == note.id);
        notesList[index] = note;
        searchNotesList = notesList;
        notifyListeners();
        Navigator.pop(context);
        showSnackBar(context, Constants.noteUpdatedMsg);
      },
    );
  }

  // delete note
  deleteNote(int id, BuildContext context) {
    dbHelper.deleteNote(id).then(
      (value) {
        notesList.removeWhere((element) => element.id == id);
        searchNotesList.removeWhere((element) => element.id == id);
        showSnackBar(context, Constants.noteDeletedMsg);
      },
    );
  }

  // get lables
  getLableData() async {
    lableList = await dbHelper.getLables();
    notifyListeners();
  }

  // insert lable
  insertLable(LableModel lable) {
    dbHelper.insertLable(lable).then(
      (value) {
        lable.id = value;
        lableList.add(lable);
        notifyListeners();
      },
    );
  }

  // update lable
  updateLable(LableModel lable) {
    dbHelper.updateLable(lable).then(
      (value) {
        int index = lableList.indexWhere((element) => element.id == lable.id);
        lableList[index] = lable;
        notifyListeners();
      },
    );
  }

  // delete lable
  deleteLable(LableModel lable) {
    dbHelper.deleteLable(lable.id!).then(
      (value) {
        lableList.removeWhere((element) => element.id == lable.id);
        notifyListeners();
      },
    );
  }
}
