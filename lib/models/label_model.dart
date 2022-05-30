import 'package:flutter/material.dart';

class LabelModel with ChangeNotifier {
  LabelModel({
    this.id,
    this.label,
  });

  int? id;
  String? label;

  factory LabelModel.fromJson(Map<String, dynamic> json) => LabelModel(
        id: json["id"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
      };
}
