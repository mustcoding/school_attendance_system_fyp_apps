import 'package:shared_preferences/shared_preferences.dart';

import'../Controller/request_controller.dart';

class warningAbsent{
  int? student_id;
  int? teacher_id;
  String? date;
  String? typeWarning;

  warningAbsent(
      this.student_id,
      this.teacher_id,
      this.date,
      this.typeWarning
      );

  warningAbsent.findAbsent(
      this.student_id,
      this.teacher_id
      );


  warningAbsent.fromJson(Map<String, dynamic> json)
      : student_id = json['student_id'] as dynamic,
        teacher_id = json['teacher_id'] as dynamic,
        date = json['date'] as String,
        typeWarning = json['typeWarning'] as String;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'student_id': student_id,
    'teacher_id':teacher_id,
    'date': date,
    'typeWarning': typeWarning,
  };


  Future<List<warningAbsent>> loadAbsentWarning(int? student_id, int? teacher_id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    List<warningAbsent> status = [];

    RequestController req = RequestController(path: "/attendanceWarning");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'studentId': student_id, 'teacherId': teacher_id});

    await req.post();
    if (req.status() == 200 && req.result() != null) {
      var result = req.result();
      var warnings = result['warnings'] as List<dynamic>; // Extract the list

      for (var item in warnings) {
        status.add(warningAbsent.fromJson({'student_id': student_id, 'teacher_id': teacher_id, 'date': '', 'typeWarning': item}));
      }
    }
    return status;
  }

}