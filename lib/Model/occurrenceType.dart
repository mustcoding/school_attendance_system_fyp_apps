
import'../Controller/request_controller.dart';

class occurrenceType {
  int ? id;
  String ? name;
  String ? description;
  int ? is_Delete;

  occurrenceType (
      this.id,
      this.name,
      this.description,
      this.is_Delete,
      );

  occurrenceType.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        name = json['name'] as String,
        description = json['description'] as String,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'is_Delete': is_Delete,
  };
}