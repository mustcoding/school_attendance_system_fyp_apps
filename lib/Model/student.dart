
import'../Controller/request_controller.dart';
import '../model/classroom.dart';
import '../model/staff.dart';
import '../model/absentSupportingDocument.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Student {
  int? id;
  String? name;
  String? date_of_birth;
  int? parent_guardian_id;
  String? card_rfid;
  String? tag_rfid;
  String? type_student;
  int? is_Delete;
  String? created_at;
  String? updated_at;
  classroom? kelas;
  staff? teacher;
  absentSupportingDocument? leaves;


  Student(
      this.id,
      this.name,
      this.date_of_birth,
      this.parent_guardian_id,
      this.card_rfid,
      this.tag_rfid,
      this.type_student,
      this.is_Delete,
      this.created_at,
      this.updated_at,
      this.kelas,
      this.teacher
      );

  Student.findChild(
    this.parent_guardian_id,
    );

  Student.findStudentStudySession(
      this.id,
      );

  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        name = json['name'] as String?,
        date_of_birth = json['date_of_birth'] as String?,
        parent_guardian_id = json['parent_guardian_id'] as dynamic,
        card_rfid = json['card_rfid'] as String?,
        tag_rfid = json['tag_rfid'] as String?,
        type_student = json['type_student'] as String?,
        is_Delete = json['is_Delete'] as dynamic,
        created_at = json['created_at'] as String?,
        updated_at = json['updated_at'] as String?,
        kelas = json['class_name'] != null
            ? classroom.ASD(
          json['class_name'] as String? ?? '',
          json['form_number'] as int? ?? 0,
        )
            : null,
        teacher = json['teacher_name'] != null
            ? staff.ASD(
          json['teacher_id'] as int? ?? 0,
          json['teacher_name'] as String? ?? '',
        )
            : null,
        leaves = json['verification_status'] != null
            ? absentSupportingDocument.ASD(
          json['verification_status'] as String? ?? '',
          json['reason'] as String? ?? '',
          json['start_date_leave'] as String? ?? '',
          json['end_date_leave'] as String? ?? '',
        )
            : null;


  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'date_of_birth': date_of_birth,
    'parent_guardian_id': parent_guardian_id,
    'card_rfid': card_rfid,
    'tag_rfid': tag_rfid,
    'type_student': type_student,
    'is_Delete': is_Delete,
    'created_at': created_at,
    'updated_at': updated_at,
    'kelas': kelas,
    'teacher':teacher,
    'leaves':leaves,
  };

  Future<List<Student>> loadChildren(int? parent_id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    List<Student> result = [];

    RequestController req =
    RequestController(path: "/ParentGuardianApps/ListChildren");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'parent_id': parent_id});

    await req.post();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        result.add(Student.fromJson(item));

      }
    }
    return result;
  }

  Future<List<Student>> loadChildrenLeaves(int? parent_id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    List<Student> status = [];

    RequestController req =
    RequestController(path: "/ParentGuardianApps/ListLeaves");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'parent_id': parent_id});

    await req.post();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        status.add(Student.fromJson(item));

      }
    }
    return status;
  }

  Future<int> getStudentStudySession(int student_id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    RequestController req = RequestController(path: "/ParentGuardianApps/studentStudySession");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'student_id': student_id});
    await req.post();
    if (req.status() == 200)
    {
      var result = req.result();

      return result['student_study_session_id'] as int;
    }
    else {
      return 0;
    }
  }


}