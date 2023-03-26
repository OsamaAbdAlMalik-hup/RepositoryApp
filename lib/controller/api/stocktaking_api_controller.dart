
import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/category.dart';
import 'package:repository/data/models/client.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/supplier.dart';
import 'package:repository/data/models/validation_message.dart';


class StocktakingApiController
{
  ApiService apiService;
  StocktakingApiController(this.apiService);

  Future<dynamic> stocktakingCategory({required int id,required String startDate, required String endDate}) async {
    HelperLogicFunctions.printNote('Start stocktakingCategory() Api');
    var response = await apiService.post(url: AppApiRoute.stocktakingCategory,
        headers: {},
        body:{
        'id':id.toString(),
        'start_date':startDate,
        'end_date':endDate,
      }
    );
    HelperLogicFunctions.printNote('End stocktakingCategory() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return CategoryStocktaking.jsonTo(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> stocktakingProduct({required int id,required String startDate, required String endDate}) async {
    HelperLogicFunctions.printNote('Start stocktakingProduct() Api');
    var response = await apiService.post(url: AppApiRoute.stocktakingProduct,
        headers: {},
        body:{
        'id':id.toString(),
        'start_date':startDate,
        'end_date':endDate,
      }
    );
    HelperLogicFunctions.printNote('End stocktakingProduct() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return ProductStocktaking.jsonTo(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> stocktakingClient({required int id,required String startDate, required String endDate}) async {
    HelperLogicFunctions.printNote('Start stocktakingClient() Api');
    var response = await apiService.post(url: AppApiRoute.stocktakingClient,
      headers: {},
      body:{
        'id':id.toString(),
        'start_date':startDate,
        'end_date':endDate,
      }
    );
    HelperLogicFunctions.printNote('End stocktakingClient() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return ClientStocktaking.jsonTo(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> stocktakingSupplier({required int id,required String startDate, required String endDate}) async {
    HelperLogicFunctions.printNote('Start stocktakingSupplier() Api');
    var response = await apiService.post(url: AppApiRoute.stocktakingSupplier,
        headers: {},
      body:{
        'id':id.toString(),
        'start_date':startDate,
        'end_date':endDate,
      }
    );
    HelperLogicFunctions.printNote('End stocktakingSupplier() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return SupplierStocktaking.jsonTo(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }

}
