import'../Controller/request_controller.dart';

class schoolSession {
  int ? id;
  String ? start_date;
  String ? end_date;
  int ? year;
  int ? is_Delete;

  schoolSession (
      this.id,
      this.start_date,
      this.end_date,
      this.year,
      this.is_Delete,
      );

  schoolSession.fromJson(Map<String, dynamic> json)
      : id = json['id'] as dynamic,
        start_date = json['start_date'] as String,
        end_date = json['end_date'] as String,
        year = json['year'] as dynamic,
        is_Delete = json['is_Delete'] as dynamic;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'start_date': start_date,
    'end_date': end_date,
    'year': year,
    'is_Delete': is_Delete,
  };
}