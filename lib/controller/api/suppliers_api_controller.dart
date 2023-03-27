
import 'dart:io';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/register.dart';
import 'package:repository/data/models/supplier.dart';
import 'package:repository/data/models/validation_message.dart';


class SuppliersApiController
{
  ApiService apiService;
  SuppliersApiController(this.apiService);

  Future<dynamic> getSuppliers() async {
    HelperLogicFunctions.printNote('Start getSuppliers() Api');
    var response = await apiService.post(url: AppApiRoute.getSuppliers,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getSuppliers() Api: $response');
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
  Future<dynamic> getSupplier({required int id}) async {
    HelperLogicFunctions.printNote('Start getSupplier() Api');
    var response = await apiService.post(url: AppApiRoute.getSupplier, headers: {}, body: {
      'id': id.toString(),
    });
    HelperLogicFunctions.printNote('End getSupplier() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Supplier.jsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> updateSupplier({required int id, required String name,required String phoneNumber,required String address, File? photo}) async {
    HelperLogicFunctions.printNote('Start updateSupplier() Api');
    var response = await apiService.postMultiPart(url: AppApiRoute.updateSupplier, body: {
        'id':id.toString(),
        'name':name,
        'phone_number':phoneNumber,
        'address':address,
      },headers: {}
      ,file: photo
    );
    HelperLogicFunctions.printNote('End updateSupplier() Api: $response');
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
  Future<dynamic> deleteSupplier({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteSupplier() Api');
    var response = await apiService.post(url: AppApiRoute.deleteSupplier,headers: {}, body: {
        'id':id.toString(),
      }
    );
    HelperLogicFunctions.printNote('End deleteSupplier() Api: $response');
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
  Future<dynamic> meetDebtSupplier({required int id, required double payment}) async {
    HelperLogicFunctions.printNote('Start meetDebtSupplier() Api');
    var response = await apiService.post(url: AppApiRoute.meetDebtSupplier, body: {
      'id':id.toString(),
      'payment':payment.toString(),
    },
        headers: {}
    );
    HelperLogicFunctions.printNote('End meetDebtSupplier() Api: $response');
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
  Future<dynamic> getArchiveSuppliers() async {
    HelperLogicFunctions.printNote('Start getArchiveSuppliers() Api');
    var response = await apiService.post(url: AppApiRoute.getArchivesSuppliers,headers: {} ,body: {
      "repository_id":RegistrationController.currentRepository.id.toString()
    });
    HelperLogicFunctions.printNote('End getArchiveSuppliers() Api: $response');
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
  Future<dynamic> getArchiveSupplier({required int id}) async {
    HelperLogicFunctions.printNote('Start getArchiveSupplier() Api');
    var response = await apiService.post(url: AppApiRoute.getArchiveSupplier ,headers: {} ,body: {
      "id":id.toString()
    });
    HelperLogicFunctions.printNote('End getArchiveSupplier() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Supplier.jsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> addSupplierToArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start addSupplierToArchive() Api');
    var response = await apiService.post(url: AppApiRoute.addSupplierToArchives,headers: {},  body: {
      'id':id.toString(),
    });
    HelperLogicFunctions.printNote('End addSupplierToArchive() Api: $response');
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
  Future<dynamic> removeSupplierFromArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start removeSupplierFromArchive() Api');
    var response = await apiService.post(url: AppApiRoute.removeSupplierFromArchives,headers: {},  body: {
      'id':id.toString(),
    });
    HelperLogicFunctions.printNote('End removeSupplierFromArchive() Api: $response');
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
  Future<dynamic> getSupplierRegisters({required int id}) async {
    HelperLogicFunctions.printNote('Start getSupplierRegisters() Api');
    var response = await apiService.post(url: AppApiRoute.getSupplierRegisters,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getSupplierRegisters() Api: $response');
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
  Future<dynamic> deleteSupplierRegister({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteSupplierRegister() Api');
    var response = await apiService.post(url: AppApiRoute.deleteSupplierRegister,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deleteSupplierRegister() Api: $response');
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
