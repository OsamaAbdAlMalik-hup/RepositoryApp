
import 'dart:io';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/register.dart';
import 'package:repository/data/models/validation_message.dart';


class ProductsApiController
{
  ApiService apiService;
  ProductsApiController(this.apiService);

  Future<dynamic> getProducts() async {
    HelperLogicFunctions.printNote('Start getProducts() Api');
    var response = await apiService.post(url: AppApiRoute.getProducts,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getProducts() Api: $response');
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
  Future<dynamic> getProduct({required int id}) async {
    HelperLogicFunctions.printNote('Start getProduct() Api');
    var response = await apiService.post(url: AppApiRoute.getProduct,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getProduct() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Product.jsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> updateProduct({required int id, required String name, required int categoryId,required double purchasePrice,required double salePrice,String measuringUnit="Kg",   File? photo}) async {
    HelperLogicFunctions.printNote('Start updateProduct() Api');
    var response = await apiService.postMultiPart(url: AppApiRoute.updateProduct,  body: {
        'id':id.toString(),
        'name':name,
        'category_id':categoryId.toString(),
        'purchase_price':purchasePrice.toString(),
        'sale_price':salePrice.toString(),
        'measuring_unit':measuringUnit,
      },headers: {}
      ,file: photo
    );
    HelperLogicFunctions.printNote('End updateProduct() Api: $response');
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
  Future<dynamic> deleteProduct({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteProduct() Api');
    var response = await apiService.post(url: AppApiRoute.deleteProduct,headers: {},  body: {
        'id':id.toString(),
      }
    );
    HelperLogicFunctions.printNote('End deleteProduct() Api: $response');
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
  Future<dynamic> getProductRegisters({required int id}) async {
    HelperLogicFunctions.printNote('Start getProductRegisters() Api');
    var response = await apiService.post(url: AppApiRoute.getProductRegisters,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getProductRegisters() Api: $response');
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
  Future<dynamic> deleteProductRegister({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteProductRegister() Api');
    var response = await apiService.post(url: AppApiRoute.deleteProductRegister,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deleteProductRegister() Api: $response');
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
