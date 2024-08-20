import 'package:shared_preferences/shared_preferences.dart';

import'../Controller/request_controller.dart';
import 'attendanceTimetable.dart';

class attendance {
  int ? id;
  String ? date_time_in;
  String ? date_time_out;
  int ? is_attend;
  int ? checkpoint_id;
  int ? attendance_timetable_id;
  int ? student_study_session_id;
  String? dateStart;
  String? dateEnd;

  attendanceTimetable? kehadiran;


  attendance (
      this.id,
      this.date_time_in,
      this.date_time_out,
      this.is_attend,
      this.checkpoint_id,
      this.attendance_timetable_id,
      this.student_study_session_id,
      this.dateEnd,
      this.dateStart,
      this.kehadiran,
      );

  attendance.calculate(
      this.student_study_session_id
      );

  attendance.find(
      this.student_study_session_id,
      );

  attendance.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic ?? 0,
        date_time_in = json['date_time_in'] != null ? json['date_time_in'] as String : '',
        //date_time_out = json['date_time_out'] as String ?? '',
        date_time_out = json['date_time_out'] != null ? json['date_time_out'] as String : '',
        is_attend = json['is_attend'] as dynamic ?? 0,
        checkpoint_id = json['checkpoint_id'] as dynamic ?? 0,
        attendance_timetable_id = json['attendance_timetable_id'] as dynamic ?? 0,
        student_study_session_id = json['student_study_session_id'] as dynamic ?? 0,
        dateStart = json['dateStart'] != null ? json['dateStart'] as String : '',
        dateEnd = json['dateEnd'] != null ? json['dateEnd'] as String : '',
        kehadiran = json['name'] != null
            ? attendanceTimetable.nama(
          json['name'] != null ? json['name'] as String : '',
        )
            : null;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'date_time_in': date_time_in,
    'date_time_out': date_time_out,
    'is_attend': is_attend,
    'checkpoint_id': checkpoint_id,
    'attendance_timetable_id': attendance_timetable_id,
    'student_study_session_id':student_study_session_id,
    'dateStart':dateStart,
    'dateEnd':dateEnd,
    'kehadiran':kehadiran,
  };

  Future<int> TotalPresent(int? student_study_session_id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    RequestController req = RequestController(path: "/ParentGuardianApps/totalPresent");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'student_study_session_id': student_study_session_id});
    await req.post();
    if (req.status() == 200)
    {
      var result = req.result();
      return result['total_attendance'] as int;
    }
    else {
      return 0;
    }
  }

  Future<int> TotalLeave(int student_study_session_id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    RequestController req = RequestController(path: "/ParentGuardianApps/totalLeave");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'student_study_session_id': student_study_session_id});
    await req.post();
    if (req.status() == 200)
    {
      var result = req.result();
      return result['total_leave'] as int;
    }
    else {
      return 0;
    }
  }

  Future<int> TotalAbsent(int student_study_session_id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    RequestController req = RequestController(path: "/ParentGuardianApps/totalAbsent");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'student_study_session_id': student_study_session_id});
    await req.post();
    if (req.status() == 200)
    {
      var result = req.result();
      return result['total_absent'] as int;
    }
    else {
      return 0;
    }
  }

  Future<List<attendance>> loadChildrenPresent(int? student_study_session_id) async {
    print("DSSDFGFDSDFGFDS");
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    List<attendance> status = [];
    RequestController req =
    RequestController(path: "/ParentGuardianApps/ListPresent");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'student_study_session_id': student_study_session_id});

    await req.post();

    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        status.add(attendance.fromJson(item));

      }
    }

    return status;
  }

  Future<List<attendance>> loadChildrenLeaves(int? student_study_session_id) async {
    print("DSSDFGFDSDFGFDS");
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    List<attendance> status = [];
    RequestController req =
    RequestController(path: "/ParentGuardianApps/ListLeave");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'student_study_session_id': student_study_session_id});

    await req.post();
    print("printnttt: ${req.result()}");

    if (req.status() == 200 && req.result() != null) {

      for (var item in req.result()) {
        status.add(attendance.fromJson(item));
        print("SDFDDF ${item}");
      }
    }
    return status;
  }

  Future<List<attendance>> loadChildrenAbsent(int? student_study_session_id) async {
    print("DSSDFGFDSDFGFDS");
    print("ufiuif : " + student_study_session_id.toString());
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    List<attendance> status = [];
    RequestController req =
    RequestController(path: "/ParentGuardianApps/ListAbsent");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'student_study_session_id': student_study_session_id});

    await req.post();
    print("printnttt: ${req.result()}");

    if (req.status() == 200 && req.result() != null) {

      for (var item in req.result()) {
        status.add(attendance.fromJson(item));
        print("SDFDDF ${item}");
      }
    }
    return status;
  }


}


