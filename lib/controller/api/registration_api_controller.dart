
import 'dart:io';

import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/repository.dart';
import 'package:repository/data/models/user.dart';
import 'package:repository/data/models/validation_message.dart';

class RegistrationApiController {
  ApiService apiService;

  RegistrationApiController(this.apiService);

  Future<dynamic> register({required String name,required String email,required String password,required String confirmPassword}) async {
    HelperLogicFunctions.printNote('Start register() Api');
    var response = await apiService.post(url: AppApiRoute.register,headers: {}, body: {
      'name': name.toString(),
      'email': email.toString(),
      'password': password.toString(),
      'password_confirmation': confirmPassword.toString(),
    });
    HelperLogicFunctions.printNote('End register() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return User.fromJsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> login({required String email,required String password,}) async {
    HelperLogicFunctions.printNote('Start login() Api');
    var response = await apiService.post(url: AppApiRoute.login,headers: {}, body: {
      'email': email.toString(),
      'password': password.toString(),
    });
    HelperLogicFunctions.printNote('End login() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return User.fromJsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> loginWithToken({required String token}) async {
    HelperLogicFunctions.printNote('Start login() Api');
    var response = await apiService.get(url: AppApiRoute.loginWithToken,headers: {
      'Authorization': 'Bearer $token',
    },);
    HelperLogicFunctions.printNote('End login() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return User.fromJsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> logout() async {
    HelperLogicFunctions.printNote('Start logout() Api');
    var response = await apiService.get(url: AppApiRoute.logout,headers: {});
    HelperLogicFunctions.printNote('End logout() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return null;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> updateProfile({required String name,File? photo}) async {
    HelperLogicFunctions.printNote('Start updateProfile() Api');
    var response = await apiService.postMultiPart(url: AppApiRoute.updateProfile,
        headers: {},
        body: {
          "name":name
        },
        file: photo);
    HelperLogicFunctions.printNote('End updateProfile() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return null;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }

  Future<dynamic> addRepository({required String name,required String address,required String code}) async {
    HelperLogicFunctions.printNote('Start addRepository() Api');
    var response = await apiService.post(url: AppApiRoute.addRepository,headers: {}, body: {
      'name': name,
      'address': address,
      'code': code,
    });
    HelperLogicFunctions.printNote('End addRepository() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Repository.fromJsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> joinToRepository({required String code}) async {
    HelperLogicFunctions.printNote('Start joinToRepository() Api');
    var response = await apiService.post(url: AppApiRoute.joinToRepository,headers: {}, body: {
      'code': code,
    });
    HelperLogicFunctions.printNote('End joinToRepository() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Repository.fromJsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> updateRepository({required int id,required String name,required String address,required String code}) async {
    HelperLogicFunctions.printNote('Start updateRepository() Api');
    var response = await apiService.post(url: AppApiRoute.updateRepository,headers: {}, body: {
      'id': id.toString(),
      'name': name,
      'address': address,
      'code': code,
    });
    HelperLogicFunctions.printNote('End updateRepository() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Repository.fromJsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> deleteRepository({required int id,required String name,required String address,required String code}) async {
    HelperLogicFunctions.printNote('Start deleteRepository() Api');
    var response = await apiService.post(url: AppApiRoute.deleteRepository,headers: {}, body: {
      'id': id.toString(),
      'name': name,
      'address': address,
      'code': code,
    });
    HelperLogicFunctions.printNote('End deleteRepository() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Repository.fromJsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getRepositories() async {
    HelperLogicFunctions.printNote('Start getRepositories() Api');
    var response = await apiService.get(url: AppApiRoute.getRepositories,headers: {});
    HelperLogicFunctions.printNote('End getRepositories() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Repository.fromJsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getRepositoriesForUser() async {
    HelperLogicFunctions.printNote('Start getRepositoriesForUser() Api');
    var response = await apiService.get(url: AppApiRoute.getRepositoriesForUser,headers: {});
    HelperLogicFunctions.printNote('End getRepositoriesForUser() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Repository.fromJsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getUsersForRepositories({required int repositoryId}) async {
    HelperLogicFunctions.printNote('Start getUsersForRepositories() Api');
    var response = await apiService.post(url: AppApiRoute.getUsersForRepositories,headers: {},
        body: {
          "repository_id":repositoryId.toString()
        });
    HelperLogicFunctions.printNote('End getUsersForRepositories() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return User.fromJsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }

}
