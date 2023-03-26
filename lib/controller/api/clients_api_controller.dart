
import 'dart:io';
import 'package:repository/core/constant/app_api_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/client.dart';
import 'package:repository/data/models/register.dart';
import 'package:repository/data/models/validation_message.dart';


class ClientsApiController
{
  ApiService apiService;
  ClientsApiController(this.apiService);

  Future<dynamic> getClients({required int repositoryId}) async {
    HelperLogicFunctions.printNote('Start getClients() Api');
    var response = await apiService.post(url: AppApiRoute.getClients,headers: {},
        body: {
          "repository_id":repositoryId.toString()
        });
    HelperLogicFunctions.printNote('End getClients() Api: $response');
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
  Future<dynamic> getClient({required int id}) async {
    HelperLogicFunctions.printNote('Start getClient() Api');
    var response = await apiService.post(url: AppApiRoute.getClient,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getClient() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Client.jsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> updateClient({required int id, required String name,required String phoneNumber,required String address, File? photo}) async {
    HelperLogicFunctions.printNote('Start updateClient() Api');
    var response = await apiService.postMultiPart(url: AppApiRoute.updateClient, body: {
        'id':id.toString(),
        'name':name,
        'phone_number':phoneNumber,
        'address':address,
      },headers: {}
      ,file: photo
    );
    HelperLogicFunctions.printNote('End updateClient() Api: $response');
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
  Future<dynamic> deleteClient({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteClient() Api');
    var response = await apiService.post(url: AppApiRoute.deleteClient,headers: {},  body: {
        'id':id.toString(),
      }
    );
    HelperLogicFunctions.printNote('End deleteClient() Api: $response');
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
  Future<dynamic> meetDebtClient({required int id, required double payment}) async {
    HelperLogicFunctions.printNote('Start meetDebtClient() Api');
    var response = await apiService.post(url: AppApiRoute.meetDebtClient, body: {
      'id':id.toString(),
      'payment':payment.toString(),
    },
      headers: {}
    );
    HelperLogicFunctions.printNote('End meetDebtClient() Api: $response');
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
  Future<dynamic> getArchivesClients({required int repositoryId}) async {
    HelperLogicFunctions.printNote('Start getArchivesClients() Api');
    var response = await apiService.post(url: AppApiRoute.getArchivesClients,headers: {} ,body: {
      "repository_id":repositoryId.toString()
    });
    HelperLogicFunctions.printNote('End getArchivesClients() Api: $response');
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
  Future<dynamic> getArchiveClient({required int id}) async {
    HelperLogicFunctions.printNote('Start getArchiveClient() Api');
    var response = await apiService.post(url: AppApiRoute.getArchiveClient ,headers: {} ,body: {
      "id":id.toString()
    });
    HelperLogicFunctions.printNote('End getArchiveClient() Api: $response');
    return response.fold((l) => l, (map) {
      if (map.containsKey(AppResponseKeys.success)
          && map.containsKey(AppResponseKeys.data)
          && map[AppResponseKeys.success]) {
        return Client.jsonToList([map[AppResponseKeys.data]]).first;
      }
      if(map.containsKey(AppResponseKeys.message)) {
        return ValidationMessage(map[AppResponseKeys.message]);
      }
    });
  }
  Future<dynamic> addClientToArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start addClientToArchive() Api');
    var response = await apiService.post(url: AppApiRoute.addClientToArchives,headers: {},  body: {
      'id':id.toString(),
    });
    HelperLogicFunctions.printNote('End addClientToArchive() Api: $response');
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
  Future<dynamic> removeClientFromArchive({required int id}) async {
    HelperLogicFunctions.printNote('Start removeClientFromArchive() Api');
    var response = await apiService.post(url: AppApiRoute.removeClientFromArchives,headers: {},  body: {
      'id':id.toString(),
    });
    HelperLogicFunctions.printNote('End removeClientFromArchive() Api: $response');
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
  Future<dynamic> getClientRegisters({required int id}) async {
    HelperLogicFunctions.printNote('Start getClientRegisters() Api');
    var response = await apiService.post(url: AppApiRoute.getClientRegisters,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End getClientRegisters() Api: $response');
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
  Future<dynamic> deleteClientRegister({required int id}) async {
    HelperLogicFunctions.printNote('Start deleteClientRegister() Api');
    var response = await apiService.post(url: AppApiRoute.deleteClientRegister,headers: {},  body: {
      'id':id.toString(),
    }
    );
    HelperLogicFunctions.printNote('End deleteClientRegister() Api: $response');
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
