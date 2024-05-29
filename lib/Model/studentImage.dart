import'../Controller/request_controller.dart';

class studentImage {
  int ? id;
  String ? image;
  String ? is_Official;
  int ? student_id;


  studentImage (
      this.id,
      this.image,
      this.is_Official,
      this.student_id,
      );

  studentImage.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        image = json['image'] as String,
        is_Official = json['is_Official'] as String,
        student_id = json['student_id'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'is_Official': is_Official,
    'student_id': student_id,
  };
}