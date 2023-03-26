import 'package:repository/core/constant/app_response_keys.dart';

class User {
  int id;
  String name;
  String email;
  String photo;
  bool isAdmin;
  String rememberToken;

  User(
      {this.id = 0,
      this.name = '',
      this.email = '',
      this.photo = '',
      this.rememberToken = '',
      this.isAdmin = false});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photo': photo,
        'rememberToken': rememberToken,
        'isAdmin': isAdmin,
      };
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        photo: json['photo'],
        rememberToken: json['rememberToken'],
        isAdmin: json['isAdmin'],
    );
  }

  static List<User> jsonToList(List<dynamic> usersMap) {
    List<User> users = [];
    for (var user in usersMap) {
      users.add(User(
        id: user.containsKey(AppResponseKeys.id) ? user[AppResponseKeys.id] : 0,
        name: user.containsKey(AppResponseKeys.name)
            ? user[AppResponseKeys.name]
            : '',
        email: user.containsKey(AppResponseKeys.email)
            ? user[AppResponseKeys.email]
            : '',
        photo: user.containsKey(AppResponseKeys.photo)
            ? user[AppResponseKeys.photo]
            : '',
        rememberToken: user.containsKey(AppResponseKeys.rememberToken)
            ? user[AppResponseKeys.rememberToken]
            : '',
        isAdmin: user.containsKey(AppResponseKeys.isAdmin)
            ? user[AppResponseKeys.isAdmin] == 1
            : false,
      ));
    }
    return users;
  }
}
