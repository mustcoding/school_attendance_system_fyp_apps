import'../Controller/request_controller.dart';

class classroom {
  int ? id;
  String ? name;
  int ? form_number;
  int ? max_capacity;
  int ? is_Delete;

  classroom (
      this.id,
      this.name,
      this.form_number,
      this.max_capacity,
      this.is_Delete,
      );

  classroom.ASD(
      this.name,
      this.form_number
      );

  classroom.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        name = json['name'] as String,
        form_number = json['form_number'] as dynamic,
        max_capacity = json['max_capacity'] as dynamic,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'form_number': form_number,
    'max_capacity': max_capacity,
    'is_Delete': is_Delete,
  };
}