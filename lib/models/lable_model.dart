class LableModel {
  LableModel({
    this.id,
    this.lable,
  });

  int? id;
  String? lable;

  factory LableModel.fromJson(Map<String, dynamic> json) => LableModel(
        id: json["id"],
        lable: json["lable"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lable": lable,
      };
}
