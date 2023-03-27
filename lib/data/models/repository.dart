import 'package:repository/core/helper/logic_functions.dart';

class Repository {
  int id;
  String name;
  String address;
  String code;

  Repository({this.id = 0, this.name = '', this.address = '', this.code = ''});

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: HelperLogicFunctions.getVale(map: json, key: 'id', defaultVal: 0),
      name: HelperLogicFunctions.getVale(map: json, key: 'name', defaultVal: ''),
      address: HelperLogicFunctions.getVale(map: json, key: 'address', defaultVal: ''),
      code: HelperLogicFunctions.getVale(map: json, key: 'code', defaultVal: ''),
    );
  }

  static List<Repository> fromJsonToList(List<dynamic> repositoriesMap) {
    List<Repository> repositories = [];
    for (var repository in repositoriesMap) {
      repositories.add(Repository.fromJson(repository));
    }
    return repositories;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'code': code,
      };
}
