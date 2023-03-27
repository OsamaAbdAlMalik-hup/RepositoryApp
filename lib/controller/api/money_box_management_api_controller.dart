
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/expense.dart';
import 'package:repository/data/models/money_box_operation.dart';
import 'package:repository/data/models/register.dart';
import 'package:repository/data/models/validation_message.dart';


class MoneyBoxManagementApiController
{
  ApiService apiService;
  MoneyBoxManagementApiController(this.apiService);

  Future<dynamic> getTotalBox() async {
    HelperLogicFunctions.printNote('Start getTotalBox() Api');
    var response = await apiService.get(url: AppApiRoute.getTotalBox,headers: {});
    HelperLogicFunctions.printNote('End getTotalBox() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return double.parse(map[AppResponseKeys.data]['total'].toString());
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> getPushOrPullRegisters({required bool isPushed}) async {
    HelperLogicFunctions.printNote('Start getPushOrPullRegisters() $isPushed Api');
    var response = await apiService.post(url: AppApiRoute.getPushOrPullRegisters,headers: {},  body: {
      'type_money': isPushed? 'pushed' : 'pulled',
      'repository_id': RegistrationController.currentRepository.id.toString()
    });
    HelperLogicFunctions.printNote('End getPushOrPullRegisters() $isPushed Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return MoneyBoxOperation.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> updateRegister({required int id,required String date, required double totalPrice}) async {
    HelperLogicFunctions.printNote('Start updateExpense() Api');
    var response = await apiService.post(url: AppApiRoute.updateRegister,headers: {},  body: {
      'id':id.toString(),
      'date':date,
      'total_price':totalPrice.toString(),
    });
    HelperLogicFunctions.printNote('End updateExpense() Api: $response');
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
  Future<dynamic> deleteRegister({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteExpense() Api');
    var response = await apiService.post(url: AppApiRoute.deleteRegister,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deleteExpense() Api: $response');
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
  Future<dynamic> getRegisterRegisters({required int id}) async {
    HelperLogicFunctions.printNote('Start getRegisterRegisters() Api');
    var response = await apiService.post(url: AppApiRoute.getRegisterRegisters,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getRegisterRegisters() Api: $response');
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
  Future<dynamic> deleteRegisterRegister({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteRegisterRegister() Api');
    var response = await apiService.post(url: AppApiRoute.deleteRegisterRegister,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deleteRegisterRegister() Api: $response');
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

  Future<dynamic> getExpenses() async {
    HelperLogicFunctions.printNote('Start getExpenses() Api');
    var response = await apiService.post(url: AppApiRoute.getExpenses,headers: {},
        body: {
          "repository_id":RegistrationController.currentRepository.id.toString()
        });
    HelperLogicFunctions.printNote('End getExpenses() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Expense.jsonToList(map[AppResponseKeys.data]);
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> updateExpense({required int id, required String name,required String details,required String date, required double totalPrice,required double paid}) async {
    HelperLogicFunctions.printNote('Start updateExpense() Api');
    var response = await apiService.post(url: AppApiRoute.updateExpense,headers: {},  body: {
      'id':id.toString(),
      'name':name,
      'details':details,
      'date':date,
      'total_price':totalPrice.toString(),
      'paid':paid.toString(),
      'remained':(totalPrice-paid).toString(),
    });
    HelperLogicFunctions.printNote('End updateExpense() Api: $response');
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
  Future<dynamic> deleteExpense({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteExpense() Api');
    var response = await apiService.post(url: AppApiRoute.deleteExpense,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deleteExpense() Api: $response');
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
  Future<dynamic> meetDebtExpense({required int id, required double payment}) async {
    HelperLogicFunctions.printNote('Start meetDebtExpense() Api');
    var response = await apiService.post(url: AppApiRoute.meetDebtExpense, body: {
      'id':id.toString(),
      'payment':payment.toString(),
    },
        headers: {}
    );
    HelperLogicFunctions.printNote('End meetDebtExpense() Api: $response');
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
  Future<dynamic> getExpenseRegisters({required int id}) async {
    HelperLogicFunctions.printNote('Start getExpenseRegisters() Api');
    var response = await apiService.post(url: AppApiRoute.getExpenseRegisters,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getExpenseRegisters() Api: $response');
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
  Future<dynamic> deleteExpenseRegister({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteExpenseRegister() Api');
    var response = await apiService.post(url: AppApiRoute.deleteExpenseRegister,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deleteExpenseRegister() Api: $response');
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
