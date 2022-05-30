import 'package:sqflite/sqflite.dart';

import '../models/notes_model.dart';
import '../models/label_model.dart';

// database version
int _databaseVersion = 1;
// table names
String _tableName = "notes";
String _labelsTable = "labels";
// column names
String _id = "id";
String _title = "title";
String _note = "note";
String _isActive = "isActive";
String _label = "label";

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // initialize database
  Future<Database> _initDatabase() async {
    var dir = await getDatabasesPath();
    var path = '${dir}quick_notes.db';
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // create table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $_tableName (
            $_id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_title TEXT NOT NULL,
            $_note TEXT NOT NULL,
            $_label TEXT NULL,
            $_isActive TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $_labelsTable (
            $_id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_label TEXT NOT NULL
          )
          ''');
  }

  // get all notes from db
  Future<List<NotesModel>> getNotes(bool? isActive) async {
    Database db = await instance.database;
    List<NotesModel> notesList = [];
    List<Map<String, Object?>> result;
    if (isActive != null) {
      result = await db
          .query(_tableName, where: '$_isActive = ?', whereArgs: ['$isActive']);
    } else {
      result = await db.query(_tableName);
    }
    for (var element in result) {
      var note = NotesModel.fromJson(element);
      notesList.add(note);
    }
    return notesList;
  }

  //insert notes to db
  Future<int> insertNote(NotesModel notes) async {
    Database db = await instance.database;
    return await db.insert(_tableName, notes.toJson());
  }

  //update notes to db
  Future<int> updateNote(NotesModel notes) async {
    Database db = await instance.database;
    return await db.update(_tableName, notes.toJson(),
        where: '$_id = ?', whereArgs: [notes.id]);
  }

  //delete notes from db
  Future<int> deleteNote(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$_id = ?', whereArgs: [id]);
  }

  // get all lables from db
  Future<List<LabelModel>> getLabels() async {
    Database db = await instance.database;
    List<LabelModel> labelList = [];
    final result = await db.query(_labelsTable);
    for (var element in result) {
      var note = LabelModel.fromJson(element);
      labelList.add(note);
    }
    return labelList;
  }

  //insert lable to db
  Future<int> insertLabel(LabelModel label) async {
    Database db = await instance.database;
    return await db.insert(_labelsTable, label.toJson());
  }

  //update lable to db
  Future<int> updateLabel(LabelModel label) async {
    Database db = await instance.database;
    return await db.update(_labelsTable, label.toJson(),
        where: '$_id = ?', whereArgs: [label.id]);
  }

  //delete lable from db
  Future<int> deleteLabel(int id) async {
    Database db = await instance.database;
    return await db.delete(_labelsTable, where: '$_id = ?', whereArgs: [id]);
  }
}
