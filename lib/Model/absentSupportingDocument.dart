import'../Controller/request_controller.dart';

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


  absentSupportingDocument (
      this.id,
      this.parent_guardian_id,
      this.staff_id,
      this.file_name,
      this.document_path,
      this.uploaded_date_time,
      this.verification_status,
      this.verified_date_time,
      this.reason,
      this.is_Delete,
      );

  absentSupportingDocument.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        parent_guardian_id = json['parent_guardian_id'] as dynamic,
        staff_id = json['staff_id'] as dynamic,
        file_name = json['file_name'] as String,
        document_path = json['document_path'] as String,
        uploaded_date_time = json['uploaded_date_time'] as String,
        verification_status = json['verification_status'] as String,
        verified_date_time = json['verified_date_time'] as String,
        reason = json['reason'] as String,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'parent_guardian_id': parent_guardian_id,
    'staff_id': staff_id,
    'file_name': file_name,
    'document_path': document_path,
    'uploaded_date_time': uploaded_date_time,
    'verification_status': verification_status,
    'verified_date_time': verified_date_time,
    'reason': reason,
    'is_Delete': is_Delete,
  };
}