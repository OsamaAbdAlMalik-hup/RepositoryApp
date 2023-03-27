
import 'dart:io';
import 'package:get/get.dart';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/category.dart';
import 'package:repository/data/models/client.dart';
import 'package:repository/data/models/money_box_operation.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/validation_message.dart';
import 'package:repository/data/models/monitoring.dart';
import 'package:repository/data/models/supplier.dart';


/// all function @return only one case form the following:
    /// if result success: @return data if need to it or null
    /// if result failed cause validation: @return message as String
    /// if result failed cause any other problem: @return StatusView

class MainScreenApiController extends GetxController
{
  ApiService apiService=Get.find();
  MainScreenApiController();


  /// Shortcut Creation
  Future<dynamic> addCategory({required String name, File? photo}) async {
    HelperLogicFunctions.printNote('Start addCategory() Api');
    var response = await apiService.postMultiPart(url: AppApiRoute.addCategory, body: {
        'name':name,
        'repository_id':RegistrationController.currentRepository.id.toString(),
      },headers: {}
      ,file: photo
    );
    HelperLogicFunctions.printNote('End addCategory() Api: $response');
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
  Future<dynamic> addProduct({required String name, required int categoryId,required double purchasePrice,required double salePrice,String measuringUnit="Kg",  File? photo}) async {
    HelperLogicFunctions.printNote('Start addProduct() Api');
    var response = await apiService.postMultiPart(url: AppApiRoute.addProduct, body: {
      'name':name,
      'category_id':categoryId.toString(),
      'purchase_price':purchasePrice.toString(),
      'sale_price':salePrice.toString(),
      'measuring_unit':measuringUnit,
    },headers: {}
        ,file: photo
    );
    HelperLogicFunctions.printNote('End addProduct() Api: $response');
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
  Future<dynamic> addClient({required String name,required String phoneNumber,required String address, File? photo}) async {
    HelperLogicFunctions.printNote('Start addClient() Api');
    var response = await apiService.postMultiPart(url: AppApiRoute.addClient, body: {
      'name':name,
      'phone_number':phoneNumber,
      'address':address,
      'repository_id':RegistrationController.currentRepository.id.toString(),
    },headers: {}
        ,file: photo
    );
    HelperLogicFunctions.printNote('End addClient() Api: $response');
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
  Future<dynamic> addSupplier({required String name,required String phoneNumber,required String address, File? photo}) async {
    HelperLogicFunctions.printNote('Start addSupplier() Api');
    var response = await apiService.postMultiPart(url: AppApiRoute.addSupplier, body: {
      'name':name,
      'phone_number':phoneNumber,
      'address':address,
      'repository_id':RegistrationController.currentRepository.id.toString(),
    },headers: {}
        ,file: photo
    );
    HelperLogicFunctions.printNote('End addSupplier() Api: $response');
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
  Future<dynamic> addExpense({required String name,required String details,required String date, required double totalPrice,required double paid}) async {
    HelperLogicFunctions.printNote('Start addExpense() Api');
    var response = await apiService.post(url: AppApiRoute.addExpense,headers: {},  body: {
      'name':name,
      'details':details,
      'date':date,
      'total_price':totalPrice.toString(),
      'paid':paid.toString(),
      'remained':(totalPrice-paid).toString(),
      'repository_id':RegistrationController.currentRepository.id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End addExpense() Api: $response');
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
  Future<dynamic> addOrRemoveCash({required double totalPrice,required String date}) async {
    HelperLogicFunctions.printNote('Start addOrRemoveCash() Api');
    var response = await apiService.post(url: AppApiRoute.addOrRemoveCash,headers: {},  body: {
      'total_price':totalPrice.toString(),
      'date':date,
      'repository_id':RegistrationController.currentRepository.id.toString(),
    });
    HelperLogicFunctions.printNote('End addOrRemoveCash() Api: $response');
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

  /// Stocktaking and Monitoring
  Future<dynamic> getCategoriesNames() async {
    HelperLogicFunctions.printNote('Start getCategoriesNames() Api');
    var response = await apiService.post(url: AppApiRoute.getCategoriesNames,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getCategoriesNames() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Category.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getProductsNames() async {
    HelperLogicFunctions.printNote('Start getProductsNames() Api');
    var response = await apiService.post(url: AppApiRoute.getProductsNames,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getProductsNames() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Product.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getClientsNames() async {
    HelperLogicFunctions.printNote('Start getClientsNames() Api');
    var response = await apiService.post(url: AppApiRoute.getClientNames,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getClientsNames() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Client.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getSuppliersNames() async {
    HelperLogicFunctions.printNote('Start getSuppliersNames() Api');
    var response = await apiService.post(url: AppApiRoute.getSuppliersNames,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getSuppliersNames() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Supplier.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getFullStocktaking({required String startDate, required String endDate}) async {
    HelperLogicFunctions.printNote('Start getFullStocktaking() Api');
    var response = await apiService.post(url: AppApiRoute.stocktakingAll,
        headers: {},
        body:{
          'repository_id':RegistrationController.currentRepository.id.toString(),
          'start_date':startDate,
          'end_date':endDate,
        }
    );
    HelperLogicFunctions.printNote('End getFullStocktaking() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return FullStocktaking.jsonTo(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getMonitoring() async {
    HelperLogicFunctions.printNote('Start getMonitoring() Api');
    var response = await apiService.post(url: AppApiRoute.getMonitoring,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getMonitoring() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Monitoring.jsonToMonitoring(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }

}
