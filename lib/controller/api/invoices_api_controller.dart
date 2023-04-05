
import 'dart:convert';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/purchases_invoice.dart';
import 'package:repository/data/models/register.dart';
import 'package:repository/data/models/sale_invoice.dart';
import 'package:repository/data/models/validation_message.dart';


class InvoicesApiController
{
  ApiService apiService;
  InvoicesApiController(this.apiService);

  Future<dynamic> getSalesInvoices() async {
    HelperLogicFunctions.printNote('Start getSalesInvoices() Api');
    var response = await apiService.post(url: AppApiRoute.getSalesInvoices,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getSalesInvoices() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return SaleInvoice.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getSalesInvoice({required int id}) async {
    HelperLogicFunctions.printNote('Start getSalesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.getSalesInvoice,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getSalesInvoice() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return SaleInvoice.jsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getSalesInvoicesBetween({required String startDate,required String endDate,}) async {
    HelperLogicFunctions.printNote('Start getSalesInvoicesBetween() Api');
    var response = await apiService.post(url: AppApiRoute.getSalesInvoicesBetween,headers: {},  body: {
      'start_date':startDate,
      'end_date':endDate,
    });
    HelperLogicFunctions.printNote('End getSalesInvoicesBetween() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return SaleInvoice.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getSalesInvoicesArchive() async {
    HelperLogicFunctions.printNote('Start getSalesInvoicesArchive() Api');
    var response = await apiService.post(url: AppApiRoute.getSalesInvoicesArchive,headers: {}, body: {
      "repository_id":RegistrationController.currentRepository.id.toString()
    });
    HelperLogicFunctions.printNote('End getSalesInvoicesArchive() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return SaleInvoice.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getSalesInvoiceArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start getSalesInvoiceArchive() Api');
    var response = await apiService.post(url: AppApiRoute.getSalesInvoiceArchive,headers: {}, body: {
      "id":id.toString()
    });
    HelperLogicFunctions.printNote('End getSalesInvoiceArchive() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return SaleInvoice.jsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> addSalesInvoice({required int clientId,required int number, required String date, required double totalPrice, required double remained, required List<Map> sales}) async {
    HelperLogicFunctions.printNote('Start addSalesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.addSalesInvoice,headers: {},  body: {
        'client_id':clientId.toString(),
        'number':number.toString(),
        'total_price':totalPrice.toString(),
        'remained':remained.toString(),
        'paid':(totalPrice-remained).toString(),
        'sales':json.encode(sales),
        'date':date,
      }
    );
    HelperLogicFunctions.printNote('End addSalesInvoice() Api: $response');
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
  Future<dynamic> updateSalesInvoice({required int id,required int clientId, required String date,required double totalPrice, required double remained, required List<Map> sales}) async {
    HelperLogicFunctions.printNote('Start updateSalesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.updateSalesInvoice,headers: {},  body: {
        'id':id.toString(),
        'client_id':clientId.toString(),
        'total_price':totalPrice.toString(),
        'remained':remained.toString(),
        'paid':(totalPrice-remained).toString(),
        'sales':json.encode(sales),
        'date':date,
      }
    );
    HelperLogicFunctions.printNote('End updateSalesInvoice() Api: $response');
    return response.fold((l) => l,  (map) {
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
  Future<dynamic> deleteSalesInvoice({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteSalesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.deleteSalesInvoice,headers: {},  body: {
        'id':id.toString(),
      }
    );
    HelperLogicFunctions.printNote('End deleteSalesInvoice() Api: $response');
    return response.fold((l) => l,  (map) {
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
  Future<dynamic> meetDebtSalesInvoice({required int id, required double payment}) async {
    HelperLogicFunctions.printNote('Start meetDebtSalesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.meetDebtSalesInvoice, body: {
      'id':id.toString(),
      'payment':payment.toString(),
    },
        headers: {}
    );
    HelperLogicFunctions.printNote('End meetDebtSalesInvoice() Api: $response');
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
  Future<dynamic> addSalesInvoiceToArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start addSalesInvoiceToArchive() Api');
    var response = await apiService.post(url: AppApiRoute.addSalesInvoiceToArchive,headers: {},  body: {
      'id':id.toString(),
    });
    HelperLogicFunctions.printNote('End addSalesInvoiceToArchive() Api: $response');
    return response.fold((l) => l,  (map) {
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
  Future<dynamic> removeSalesInvoiceFromArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start removeSalesInvoiceFromArchive() Api');
    var response = await apiService.post(url: AppApiRoute.removeSalesInvoiceFromArchive,headers: {},  body: {
      'id':id.toString(),
    });
    HelperLogicFunctions.printNote('End removeSalesInvoiceFromArchive() Api: $response');
    return response.fold((l) => l,  (map) {
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
  Future<dynamic> getSalesInvoiceRegisters({required int id}) async {
    HelperLogicFunctions.printNote('Start getSalesInvoiceRegisters() Api');
    var response = await apiService.post(url: AppApiRoute.getSalesInvoiceRegisters,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getSalesInvoiceRegisters() Api: $response');
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
  Future<dynamic> deleteSalesInvoiceRegister({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteSalesInvoiceRegister() Api');
    var response = await apiService.post(url: AppApiRoute.deleteSalesInvoiceRegister,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deleteSalesInvoiceRegister() Api: $response');
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


  Future<dynamic> getPurchasesInvoices() async {
    HelperLogicFunctions.printNote('Start getPurchasesInvoices() Api');
    var response = await apiService.post(url: AppApiRoute.getPurchasesInvoices,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getPurchasesInvoices() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return PurchasesInvoice.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getPurchasesInvoice({required int id}) async {
    HelperLogicFunctions.printNote('Start getPurchasesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.getPurchasesInvoice,headers: {}, body: {
      'id':id.toString(),
    });
    HelperLogicFunctions.printNote('End getPurchasesInvoice() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return PurchasesInvoice.jsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getPurchasesInvoicesBetween({required String startDate,required String endDate,}) async {
    HelperLogicFunctions.printNote('Start getPurchasesInvoicesBetween() Api');
    var response = await apiService.post(url: AppApiRoute.getPurchasesInvoicesBetween,headers: {},  body: {
      'start_date':startDate,
      'end_date':endDate,
    });
    HelperLogicFunctions.printNote('End getPurchasesInvoicesBetween() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return PurchasesInvoice.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getPurchasesInvoicesArchive() async {
    HelperLogicFunctions.printNote('Start getPurchasesInvoicesArchive() Api');
    var response = await apiService.post(url: AppApiRoute.getPurchasesInvoicesArchive,headers: {} ,body: {
    "repository_id":RegistrationController.currentRepository.id.toString()
    });
    HelperLogicFunctions.printNote('End getPurchasesInvoicesArchive() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return PurchasesInvoice.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getPurchasesInvoiceArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start getPurchasesInvoiceArchive() Api');
    var response = await apiService.post(url: AppApiRoute.getPurchasesInvoiceArchive,headers: {} ,body: {
      "id":id.toString()
    });
    HelperLogicFunctions.printNote('End getPurchasesInvoiceArchive() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return PurchasesInvoice.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }

  Future<dynamic> addPurchasesInvoice({required int supplierId,required int number, required String date, required double totalPrice, required double remained,required List<Map> purchases}) async {
    HelperLogicFunctions.printNote('Start addPurchasesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.addPurchasesInvoice,headers: {},  body: {
      'supplier_id':supplierId.toString(),
      'number':number.toString(),
      'total_price':totalPrice.toString(),
      'remained':remained.toString(),
      'paid':(totalPrice-remained).toString(),
      'purchases':json.encode(purchases),
      'date':date,
    }
    );
    HelperLogicFunctions.printNote('End addPurchasesInvoice() Api: $response');
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
  Future<dynamic> updatePurchasesInvoice({required int id,required int supplierId, required String date, required double totalPrice, required double paid,required List<Map> purchases}) async {
    HelperLogicFunctions.printNote('Start updatePurchasesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.updatePurchasesInvoice,headers: {},  body: {
      'id':id.toString(),
      'supplier_id':supplierId.toString(),
      'date':date,
      'total_price':totalPrice.toString(),
      'paid':paid.toString(),
      'remained':(totalPrice-paid).toString(),
      'purchases':json.encode(purchases),
    }
    );
    HelperLogicFunctions.printNote('End updatePurchasesInvoice() Api: $response');
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
  Future<dynamic> deletePurchasesInvoice({required int id}) async {
    HelperLogicFunctions.printNote('Start deletePurchasesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.deletePurchasesInvoice,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deletePurchasesInvoice() Api: $response');
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
  Future<dynamic> meetDebtPurchasesInvoice({required int id, required double payment}) async {
    HelperLogicFunctions.printNote('Start meetDebtPurchasesInvoice() Api');
    var response = await apiService.post(url: AppApiRoute.meetDebtPurchasesInvoice, body: {
      'id':id.toString(),
      'payment':payment.toString(),
    },
        headers: {}
    );
    HelperLogicFunctions.printNote('End meetDebtPurchasesInvoice() Api: $response');
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
  Future<dynamic> addPurchasesInvoiceToArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start addPurchasesInvoiceToArchive() Api');
    var response = await apiService.post(url: AppApiRoute.addPurchasesInvoiceToArchive,headers: {},  body: {
      'id':id.toString(),
    });
    HelperLogicFunctions.printNote('End addPurchasesInvoiceToArchive() Api: $response');
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
  Future<dynamic> removePurchasesInvoiceFromArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start removePurchasesInvoiceFromArchive() Api');
    var response = await apiService.post(url: AppApiRoute.removePurchasesInvoiceFromArchive,headers: {},  body: {
      'id':id.toString(),
    });
    HelperLogicFunctions.printNote('End removePurchasesInvoiceFromArchive() Api: $response');
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
  Future<dynamic> getPurchasesInvoiceRegisters({required int id}) async {
    HelperLogicFunctions.printNote('Start getPurchasesInvoiceRegisters() Api');
    var response = await apiService.post(url: AppApiRoute.getPurchasesInvoiceRegisters,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getPurchasesInvoiceRegisters() Api: $response');
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
  Future<dynamic> deletePurchasesInvoiceRegister({required int id}) async {
    HelperLogicFunctions.printNote('Start deletePurchasesInvoiceRegister() Api');
    var response = await apiService.post(url: AppApiRoute.deletePurchasesInvoiceRegister,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deletePurchasesInvoiceRegister() Api: $response');
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

  Future<dynamic> getProductsSomeDetails() async {
    HelperLogicFunctions.printNote('Start getProductsSomeDetails() Api');
    var response = await apiService.post(url: AppApiRoute.getProductsSomeDetails,headers: {},
        body: {
          "repository_id": RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getProductsSomeDetails() Api: $response');
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

}