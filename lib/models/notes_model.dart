import 'dart:convert';

import 'package:flutter/material.dart';

NotesModel notesModelFromJson(String str) =>
    NotesModel.fromJson(json.decode(str));

String notesModelToJson(NotesModel data) => json.encode(data.toJson());

class NotesModel with ChangeNotifier {
  NotesModel({
    this.id,
    this.title,
    this.notes,
  });

  int? id;
  String? title;
  String? notes;

  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
        id: json["id"],
        title: json["title"],
        notes: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "note": notes,
      };
}
