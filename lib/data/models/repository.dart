
import 'package:repository/core/constant/app_response_keys.dart';

class Repository {
  int id;
  String name;
  String address;
  String code;

  Repository(
      { this.id=0,
       this.name='',
       this.address='',
       this.code=''});

  static List<Repository> jsonToList(List<dynamic> repositoriesMap) {
    List<Repository> repositories = [];
    for (var repository in repositoriesMap) {
      repositories.add(Repository(
        id: repository.containsKey(AppResponseKeys.id) ? repository[AppResponseKeys.id] : 0,
        name: repository.containsKey(AppResponseKeys.name)
            ? repository[AppResponseKeys.name]
            : '',
        address: repository.containsKey(AppResponseKeys.address)
            ? repository[AppResponseKeys.address]
            : '',
        code: repository.containsKey(AppResponseKeys.codeCln)
            ? repository[AppResponseKeys.codeCln]
            : '',
      ));
    }
    return repositories;
  }
}
