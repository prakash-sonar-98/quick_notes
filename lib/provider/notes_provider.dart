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

  // trash list
  List<NotesModel> trashList = [];

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
  getNotesData({required bool isActive}) async {
    final list = await dbHelper.getNotes(isActive);
    if (isActive) {
      notesList = list;
      searchNotesList = notesList;
    } else {
      trashList = list;
    }
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

  // move to trash
  moveToTrash(BuildContext context, NotesModel note) {
    dbHelper.updateNote(note).then(
      (value) {
        notesList.removeWhere((element) => element.id == note.id);
        searchNotesList.removeWhere((element) => element.id == note.id);
        notifyListeners();
        showSnackBar(context, Constants.noteMovedToTrashMsg);
      },
    );
  }

  // delete note
  deleteNote(int id, BuildContext context) {
    dbHelper.deleteNote(id).then(
      (value) {
        // notesList.removeWhere((element) => element.id == id);
        trashList.removeWhere((element) => element.id == id);
        notifyListeners();
        showSnackBar(context, Constants.noteDeletedMsg);
      },
    );
  }

  // delete all trash data
  emptyTrashData() {
    for (var element in trashList) {
      dbHelper.deleteNote(element.id!);
    }
    trashList = [];
    notifyListeners();
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
        String oldLabel = lableList[index].lable!;
        lableList[index] = lable;
        _updateLabelNameInNote(oldLabel, lable.lable!);
      },
    );
  }

  // delete lable
  deleteLable(LableModel lable) {
    dbHelper.deleteLable(lable.id!).then(
      (value) {
        lableList.removeWhere((element) => element.id == lable.id);
        _deleteLabelInNotes(lable.lable!);
      },
    );
  }

  // update label name in notes list if user updates label name
  _updateLabelNameInNote(String oldLabel, String newLabel) {
    for (var element in notesList) {
      if (element.lable == oldLabel) {
        element.lable = newLabel;
        dbHelper.updateNote(element);
      }
    }
    getNotesData(isActive: true);
  }

  // delete label name in notes list if user delete label
  _deleteLabelInNotes(String label) {
    for (var element in notesList) {
      if (element.lable == label) {
        element.lable = null;
        dbHelper.updateNote(element);
      }
    }
    getNotesData(isActive: true);
  }
}
