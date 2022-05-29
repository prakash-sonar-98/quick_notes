import 'package:sqflite/sqflite.dart';

import '../models/notes_model.dart';
import '../models/lable_model.dart';

// database version
int _databaseVersion = 1;
// table names
String _tableName = "notes";
String _lablesTable = "lables";
// column names
String _id = "id";
String _title = "title";
String _note = "note";
String _isActive = "isActive";
String _lable = "lable";

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
            $_lable TEXT NULL,
            $_isActive TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $_lablesTable (
            $_id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_lable TEXT NOT NULL
          )
          ''');
  }

  // get all notes from db
  Future<List<NotesModel>> getNotes(bool isActive) async {
    Database db = await instance.database;
    List<NotesModel> notesList = [];
    // final result = await db.query(_tableName);
    final result = await db.query(_tableName, where: '$_isActive = ?', whereArgs: ['$isActive']);
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
  Future<List<LableModel>> getLables() async {
    Database db = await instance.database;
    List<LableModel> lableList = [];
    final result = await db.query(_lablesTable);
    for (var element in result) {
      var note = LableModel.fromJson(element);
      lableList.add(note);
    }
    return lableList;
  }

  //insert lable to db
  Future<int> insertLable(LableModel lable) async {
    Database db = await instance.database;
    return await db.insert(_lablesTable, lable.toJson());
  }

  //update lable to db
  Future<int> updateLable(LableModel lable) async {
    Database db = await instance.database;
    return await db.update(_lablesTable, lable.toJson(),
        where: '$_id = ?', whereArgs: [lable.id]);
  }

  //delete lable from db
  Future<int> deleteLable(int id) async {
    Database db = await instance.database;
    return await db.delete(_lablesTable, where: '$_id = ?', whereArgs: [id]);
  }
}
