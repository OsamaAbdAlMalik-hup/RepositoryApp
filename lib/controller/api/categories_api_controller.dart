
import 'dart:io';
import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/category.dart';
import 'package:repository/data/models/register.dart';
import 'package:repository/data/models/validation_message.dart';


class CategoriesApiController
{

  ApiService apiService;
  CategoriesApiController(this.apiService);

  Future<dynamic> getCategories({required int repositoryId}) async {
    HelperLogicFunctions.printNote('Start getCategories() Api');
    var response = await apiService.post(url: AppApiRoute.getCategories,headers: {},
        body: {
          "repository_id":repositoryId.toString()
        });
    HelperLogicFunctions.printNote('End getCategories() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success) && map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Category.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getCategory({required int id}) async {
    HelperLogicFunctions.printNote('Start getCategory() Api');
    var response = await apiService.post(url: AppApiRoute.getCategory,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getCategory() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Category.jsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> updateCategory({required int id, required String name, File? photo}) async {
    HelperLogicFunctions.printNote('Start updateCategory() Api');
    var response = await apiService.postMultiPart(url: AppApiRoute.updateCategory, body: {
        'id':id.toString(),
        'name':name,
      },headers: {}
      ,file: photo
    );
    HelperLogicFunctions.printNote('End updateCategory() Api: $response');
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
  Future<dynamic> deleteCategory({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteCategory() Api');
    var response = await apiService.post(url: AppApiRoute.deleteCategory,headers: {}, body:  {
        'id':id.toString(),
      }
    );
    HelperLogicFunctions.printNote('End deleteCategory() Api: $response');
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
  Future<dynamic> getCategoryRegisters({required int id}) async {
    HelperLogicFunctions.printNote('Start getCategoryRegisters() Api');
    var response = await apiService.post(url: AppApiRoute.getCategoryRegisters,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getCategoryRegisters() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Register.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> deleteCategoryRegister({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteCategoryRegister() Api');
    var response = await apiService.post(url: AppApiRoute.deleteCategoryRegister,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deleteCategoryRegister() Api: $response');
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
}
