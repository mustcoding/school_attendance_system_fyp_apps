import'../Controller/request_controller.dart';

class checkpoint{
  int? id;
  String? name;
  int? is_Delete;


  checkpoint(
      this.id,
      this.name,
      this.is_Delete,
      );



  checkpoint.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        name = json['name'] as String,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'is_Delete': is_Delete,
  };
}