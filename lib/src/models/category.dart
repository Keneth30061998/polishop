// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  String? id;
  String? name;
  String? description;

  Category({
    this.id,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };

  //Forma convertir una lista de categorias
  static List<Category> fromJsonList(List<dynamic> jsonList){
    List<Category> toList = [];
    jsonList.forEach((item) {
      Category category = Category.fromJson(item);
      toList.add(category);
    });

    return toList;
  }
}
