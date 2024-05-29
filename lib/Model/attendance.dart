import'../Controller/request_controller.dart';

class attendance {
  int ? id;
  String ? date_time_in;
  String ? date_time_out;
  int ? is_attend;
  int ? checkpoint_id;
  int ? attendance_timetable_id;
  int ? student_study_session_id;


  attendance (
      this.id,
      this.date_time_in,
      this.date_time_out,
      this.is_attend,
      this.checkpoint_id,
      this.attendance_timetable_id,
      this.student_study_session_id,
      );

  attendance.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        date_time_in = json['date_time_in'] as String,
        date_time_out = json['date_time_out'] as String,
        is_attend = json['is_attend'] as dynamic,
        checkpoint_id = json['checkpoint_id'] as dynamic,
        attendance_timetable_id = json['attendance_timetable_id'] as dynamic,
        student_study_session_id = json['student_study_session_id'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'date_time_in': date_time_in,
    'date_time_out': date_time_out,
    'is_attend': is_attend,
    'checkpoint_id': checkpoint_id,
    'attendance_timetable_id': attendance_timetable_id,
    'student_study_session_id':student_study_session_id,
  };
}
