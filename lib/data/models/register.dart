import 'package:repository/core/constant/app_response_keys.dart';

class Register {
  int id;
  String name;
  String date;
  String userName;
  String typeOperation;

  Register(
      {required this.id,
      required this.name,
      required this.date,
      required this.userName,
      required this.typeOperation});

  static List<Register> jsonToList(List<dynamic> registersMap) {
    List<Register> users = [];
    for (var register in registersMap) {
      users.add(Register(
        id: register.containsKey(AppResponseKeys.id) ? register[AppResponseKeys.id] : 0,
        name: register.containsKey(AppResponseKeys.name)
            ? register[AppResponseKeys.name]
            : '',
        date: register.containsKey(AppResponseKeys.date)
            ? register[AppResponseKeys.date]
            : '',
        userName: register.containsKey(AppResponseKeys.user) && register[AppResponseKeys.user].containsKey(AppResponseKeys.name)
            ? register[AppResponseKeys.user][AppResponseKeys.name]
            : '',
        typeOperation: register.containsKey(AppResponseKeys.typeOperation)
            ? register[AppResponseKeys.typeOperation]
            : '',
      ));
    }
    return users;
  }
}
