import'../Controller/request_controller.dart';

class rfid{
  int? id;
  String? number;
  String? type;
  int? is_Delete;


  rfid(
      this.id,
      this.number,
      this.type,
      this.is_Delete,
      );



  rfid.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        number = json['number'] as String,
        type = json['type'] as String,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'type': type,
    'is_Delete': is_Delete,
  };
}