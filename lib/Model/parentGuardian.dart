
import '../controller/request_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class parentGuardian {
  int? id;
  String? name;
  String? username;
  String? password;
  String? phone_number;
  String? address;
  String? nickname;
  int? is_Delete;
  String? created_at;
  String? updated_at;


  parentGuardian(
      this.id,
      this.name,
      this.username,
      this.password,
      this.phone_number,
      this.address,
      this.nickname,
      this.is_Delete,
      this.created_at,
      this.updated_at
      );

  parentGuardian.login(
      this.username,
      this.password,
      );

  parentGuardian.calculateChildren(
      this.id,
      );



  parentGuardian.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        username = json['username'] as String,
        password = json['password'] as String,
        phone_number = json['phone_number'] as String,
        address = json['address'] as String,
        nickname = json['nickname'] as String,
        is_Delete = json['is_Delete'] as int,
        created_at = json['created_at'] as String,
        updated_at = json['updated_at'] as String;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'password': password,
    'phone_number': phone_number,
    'address': address,
    'nickname': nickname,
    'is_Delete': is_Delete,
    'created_at': created_at,
    'updated_at': updated_at,
  };



  Future<int> calculateChildren(int parentGuardianId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("Token not found in SharedPreferences");
    }

    RequestController req = RequestController(path: "/ParentGuardianApps/TotalChildren");
    req.setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    req.setBody({'id': parentGuardianId}); // Assuming you want to send parentGuardianId in the body
    await req.post();

    if (req.status() == 200) {
      var result = req.result();
      if (result is Map<String, dynamic>) {
        return result['total_students'] as int;
      } else {
        throw Exception("Unexpected JSON structure: $result");
      }
    } else {
      return 0;
    }
  }


  Future<bool> checkParentExistence() async {
    RequestController req = RequestController(path: "/ParentLogin");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      var result = req.result();
      if (result is Map<String, dynamic> && result.containsKey('0') && result.containsKey('token')) {
        var data = result['0'];
        var token = result['token'];

        print('Response: $data');
        print('Token: $token');

        id = data['id'] as int;
        name = data['name'] as String;
        username = data['username'] as String;
        password = data['password'] as String;
        phone_number = data['phone_number'] as String;
        address = data['address'] as String;
        nickname = data['nickname'] as String;
        is_Delete = data['is_Delete'] as int;

        // Save data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id', id ?? 0);
        await prefs.setString('name', name ?? '');
        await prefs.setString('username', username ?? '');
        await prefs.setString('password', password ?? '');
        await prefs.setString('phone_number', phone_number ?? '');
        await prefs.setString('address', address ?? '');
        await prefs.setString('nickname', nickname ?? '');
        await prefs.setInt('is_Delete', is_Delete ?? 0);
        await prefs.setString('token', token);

        return true;
      } else {
        throw Exception("Unexpected JSON structure: $result");
      }
    } else {
      return false;
    }
  }
}