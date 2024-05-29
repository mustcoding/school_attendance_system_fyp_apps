import'../Controller/request_controller.dart';

class schoolSessionClass {
  int ? id;
  int ? school_session_id;
  int ? class_id;
  int ? staff_id;
  int ? is_Delete;


  schoolSessionClass (
      this.id,
      this.school_session_id,
      this.class_id,
      this.staff_id,
      this.is_Delete,
      );

  schoolSessionClass.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        school_session_id = json['school_session_id'] as dynamic,
        class_id = json['class_id'] as dynamic,
        staff_id = json['staff_id'] as dynamic,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'school_session_id': school_session_id,
    'class_id': class_id,
    'staff_id': staff_id,
    'is_Delete': is_Delete,
  };
}