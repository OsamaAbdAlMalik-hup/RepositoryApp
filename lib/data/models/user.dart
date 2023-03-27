
import 'package:repository/core/helper/logic_functions.dart';

class User {
  int id;
  String name;
  String email;
  String password;
  String photo;
  bool isAdmin;
  String rememberToken;

  User(
      {this.id = 0,
      this.name = '',
      this.email = '',
      this.password = '',
      this.photo = '',
      this.rememberToken = '',
      this.isAdmin = false});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'photo': photo,
        'remember_token': rememberToken,
        'is_admin': isAdmin ? 1 : 0,
      };
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: HelperLogicFunctions.getVale(map: json, key: 'id', defaultVal: 0),
        name: HelperLogicFunctions.getVale(map: json, key: 'name', defaultVal: ''),
        email: HelperLogicFunctions.getVale(map: json, key: 'email', defaultVal: ''),
        password: HelperLogicFunctions.getVale(map: json, key: 'password', defaultVal: ''),
        photo: HelperLogicFunctions.getVale(map: json, key: 'photo', defaultVal: ''),
        rememberToken: HelperLogicFunctions.getVale(map: json, key: 'remember_token', defaultVal: ''),
        isAdmin: HelperLogicFunctions.getVale(map: json, key: 'is_admin', defaultVal: 0)==1,
    );
  }

  static List<User> fromJsonToList(List<dynamic> usersMap) {
    List<User> users = [];
    for (var user in usersMap) {
      users.add(User.fromJson(user));
    }
    return users;
  }
}
