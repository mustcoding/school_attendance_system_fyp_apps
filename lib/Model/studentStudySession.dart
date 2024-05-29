import'../Controller/request_controller.dart';

class studentStudySession {
  int ? id;
  int ? student_id;
  int ? ssc_id;
  int ? is_Delete;


  studentStudySession (
      this.id,
      this.student_id,
      this.ssc_id,
      this.is_Delete,
      );

  studentStudySession.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        student_id = json['student_id'] as dynamic,
        ssc_id = json['ssc_id'] as dynamic,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': student_id,
    'ssc_id': ssc_id,
    'is_Delete': is_Delete,
  };
}