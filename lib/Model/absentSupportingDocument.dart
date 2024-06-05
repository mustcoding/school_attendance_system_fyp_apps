import'../Controller/request_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class absentSupportingDocument {

  int ? id;
  int ? parent_guardian_id;
  int ? staff_id;
  String ? file_name;
  String ? document_path;
  String ? uploaded_date_time;
  String ? verification_status;
  String ? verified_date_time;
  String ? reason;
  int ? is_Delete;
  String ? start_date_leave;
  String ? end_date_leave;


  absentSupportingDocument (
      this.id,
      this.file_name,
      this.document_path,
      this.uploaded_date_time,
      this.verification_status,
      this.verified_date_time,
      this.reason,
      this.parent_guardian_id,
      this.staff_id,
      this.is_Delete,
      this.start_date_leave,
      this.end_date_leave,
      );

  absentSupportingDocument.add(
      this.file_name,
      this.document_path,
      this.uploaded_date_time,
      this.verification_status,
      this.verified_date_time,
      this.reason,
      this.parent_guardian_id,
      this.staff_id,
      this.is_Delete,
      this.start_date_leave,
      this.end_date_leave,
      );

  absentSupportingDocument.ASD(
      this.verification_status,
      this.reason,
      this.start_date_leave,
      this.end_date_leave,
      );

  absentSupportingDocument.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        file_name = json['file_name'] as String,
        document_path = json['document_path'] as String,
        uploaded_date_time = json['uploaded_date_time'] as String,
        verification_status = json['verification_status'] as String,
        verified_date_time = json['verified_date_time'] as String,
        reason = json['reason'] as String,
        parent_guardian_id = json['parent_guardian_id'] as dynamic,
        staff_id = json['staff_id'] as dynamic,
        is_Delete = json['is_Delete'] as dynamic,
        start_date_leave = json['start_date_leave'] as String,
        end_date_leave = json['end_date_leave'] as String;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'file_name': file_name,
    'document_path': document_path,
    'uploaded_date_time': uploaded_date_time,
    'verification_status': verification_status,
    'verified_date_time': verified_date_time,
    'reason': reason,
    'parent_guardian_id': parent_guardian_id,
    'staff_id': staff_id,
    'is_Delete': is_Delete,
    'start_date_leave': start_date_leave,
    'end_date_leave': end_date_leave,
  };


  Future<bool> applyLeave() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    RequestController req = RequestController(path: "/ParentGuardianApps/ApplyLeaves");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200)
    {
      return true;
    }
    else {
      return false;
    }
  }


}