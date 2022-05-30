import 'package:flutter/material.dart';

import '../helper/database_helper.dart';
import '../models/label_model.dart';
import '../models/notes_model.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class NotesProvider with ChangeNotifier {
  // database instance
  final dbHelper = DatabaseHelper.instance;

  // notes lists
  List<NotesModel> notesList = [];
  List<NotesModel> searchNotesList = [];

  //label list
  List<LabelModel> labelList = [];

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
      searchNotesList = notesList.reversed.toList();
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
        searchNotesList = notesList.reversed.toList();
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

  //restore notes
  restoreNote(NotesModel note) {
    dbHelper.updateNote(note).then(
      (value) {
        trashList.removeWhere((element) => element.id == note.id);
        getNotesData(isActive: true);
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
    labelList = await dbHelper.getLabels();
    notifyListeners();
  }

  // insert label
  insertLable(BuildContext context, LabelModel label) {
    int index = labelList.indexWhere((element) =>
        element.label!.toLowerCase() == label.label!.toLowerCase());
    if (index == -1) {
      // new label
      dbHelper.insertLabel(label).then(
        (value) {
          label.id = value;
          labelList.add(label);
          notifyListeners();
        },
      );
    } else {
      // already exists
      showSnackBar(context, Constants.alreadyExistsMsg);
    }
  }

  // update label
  updateLable(LabelModel label) {
    dbHelper.updateLabel(label).then(
      (value) {
        int index = labelList.indexWhere((element) => element.id == label.id);
        String oldLabel = labelList[index].label!;
        labelList[index] = label;
        _updateLabelNameInNote(oldLabel, label.label!);
      },
    );
  }

  // delete label
  deleteLable(LabelModel label) {
    dbHelper.deleteLabel(label.id!).then(
      (value) {
        labelList.removeWhere((element) => element.id == label.id);
        _deleteLabelInNotes(label.label!);
      },
    );
  }

  // update label name in notes list if user updates label name
  _updateLabelNameInNote(String oldLabel, String newLabel) async {
    final list = await dbHelper.getNotes(null);
    for (var element in list) {
      if (element.label == oldLabel) {
        element.label = newLabel;
        dbHelper.updateNote(element);
      }
    }
    getNotesData(isActive: true);
  }

  // delete label name in notes list if user delete label
  _deleteLabelInNotes(String label) async {
    final list = await dbHelper.getNotes(null);
    for (var element in list) {
      if (element.label == label) {
        element.label = null;
        dbHelper.updateNote(element);
      }
    }
    getNotesData(isActive: true);
  }
}
