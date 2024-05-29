import'../Controller/request_controller.dart';

class attendanceTimetable {
  int ? id;
  String ? name;
  String ? start_time;
  String ? end_time;
  int ? occurrence_id;
  int ? is_Delete;


  attendanceTimetable (
      this.id,
      this.name,
      this.start_time,
      this.end_time,
      this.occurrence_id,
      this.is_Delete,
      );

  attendanceTimetable.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        name = json['name'] as String,
        start_time = json['start_time'] as String,
        end_time = json['end_time'] as String,
        occurrence_id = json['occurrence_id'] as dynamic,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'start_time': start_time,
    'end_time': end_time,
    'occurrence_id': occurrence_id,
    'is_Delete': is_Delete,
  };
}