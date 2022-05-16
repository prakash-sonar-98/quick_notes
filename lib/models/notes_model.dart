import 'dart:convert';

NotesModel notesModelFromJson(String str) =>
    NotesModel.fromJson(json.decode(str));

String notesModelToJson(NotesModel data) => json.encode(data.toJson());

class NotesModel {
  NotesModel({
    this.id,
    this.title,
    this.description,
  });

  int? id;
  String? title;
  String? description;

  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
      };
}
