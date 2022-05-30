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
    this.label,
    this.isActive = 'true',
  });

  int? id;
  String? title;
  String? notes;
  String? label;
  String? isActive;

  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
        id: json["id"],
        title: json["title"],
        notes: json["note"],
        label: json["label"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "note": notes,
        "label": label,
        "isActive": isActive,
      };
}
