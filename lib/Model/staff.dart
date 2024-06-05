
import'../Controller/request_controller.dart';

class staff {
  int? id;
  String? name;
  String? username;
  String? password;
  String? position;
  String? nickname;
  String? image;
  int? is_Delete;


  staff(
      this.id,
      this.name,
      this.username,
      this.password,
      this.position,
      this.nickname,
      this.image,
      this.is_Delete,

      );

  staff.ASD(
    this.id,
      this.name
      );

  staff.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        name = json['name'] as String,
        username = json['username'] as String,
        password = json['password'] as String,
        position = json['position'] as String,
        nickname = json['nickname'] as String,
        image = json['image'] as String,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'password': password,
    'position': position,
    'nickname': nickname,
    'image': image,
    'is_Delete': is_Delete,
  };

}