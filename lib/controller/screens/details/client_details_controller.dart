import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/clients_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/client.dart';
import 'package:repository/data/models/register.dart';

class ClientDetailsController extends GetxController {
  ClientsController clientsController = Get.find();

  int clientId = 1;
  Client client = Client(details: ClientDetails(), stocktaking: ClientStocktaking());
  List<Register> registers=[];
  StatusView statusView = StatusView.loading;

  @override
  void onInit() async {
    clientId = await Get.arguments[AppSharedKeys.passId];
    await getClient();
    super.onInit();
  }

  Future<bool> getClient() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(
      request: () async {
        return clientsController.isArchived
            ? await clientsController.clientsApiController.getArchiveClient(id: clientId)
            : await clientsController.clientsApiController.getClient(id: clientId);
      },
      onSuccess: (response) async {
        if (response is Client) {
          client = response;
        }
        statusView = StatusView.none;
        update();
      },

      onFailure: (statusView,message) async {
          this.statusView = statusView;
          if(statusView==StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
    );
  }
  Future<bool> meetDebtClient() async {

    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await clientsController.clientsApiController.meetDebtClient(
            id: client.id,
            payment: double.parse(
                clientsController.mainController.amountFieldController.text));
      },
      onSuccess: (response) async {
        HelperDesignFunctions.showSuccessSnackBar(
            message: "Client ${client.name} done meet his debts");
        await getClient();
      },
      onFailure: (statusView,message) async {
          this.statusView = statusView;
          if(statusView==StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
    );
  }

  Future<bool> archiveClient() async {

    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return clientsController.isArchived
            ? await clientsController.clientsApiController.removeClientFromArchive(
                id: client.id,)
            : await clientsController.clientsApiController.addClientToArchive(
                id: client.id,);
      },
      onSuccess: (response) async {
        Get.back();
        HelperDesignFunctions.showSuccessSnackBar(message: "Client ${client.name} done meet his debts");
        clientsController.getClients();
      },

      onFailure: (statusView,message) async {
          this.statusView = statusView;
          if(statusView==StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
    );
  }
  Future<bool> getClientRegisters({required BuildContext context}) async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await clientsController.clientsApiController.getClientRegisters(
            id: client.id
        );
      },
      onSuccess: (response) async {
        if(response is List<Register>) {
          registers=response;
          HelperDesignFunctions.showMainBottomSheet(context,
              height: Get.height,
              title: "Registers",
              content: SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: registers.length,
                  itemBuilder: (context, index) => Slidable(
                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (c) async {
                            await deleteClientRegister(registerId: registers[index].id);
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          backgroundColor: AppColors.red,
                          icon: Icons.delete_outlined,
                        ),
                      ],
                    ),
                    child: Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(registers[index].userName),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.date_range),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(registers[index].date),
                          ],
                        ),
                        trailing: registers[index].typeOperation == "edit"
                            ? const Icon(Icons.edit)
                            : registers[index].typeOperation == "add_to_archive"
                            ? const Icon(Icons.archive_outlined)
                            : registers[index].typeOperation == "remove_to_archive"
                            ? const Icon(Icons.unarchive_outlined)
                            : registers[index].typeOperation == "meet_debt"
                            ? const Icon(Icons.account_balance_wallet_outlined)
                            : const Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
              ));
        }
        statusView = StatusView.none;
        update();
      },

      onFailure: (statusView,message) async {
          this.statusView = statusView;
          if(statusView==StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
    );
  }
  Future<bool> deleteClientRegister({required int registerId}) async {
    statusView = StatusView.loading;
    update();
    Get.back();
    return await ApiService.sendRequest(

      request: () async {
        return await clientsController.clientsApiController.deleteClientRegister(
            id: registerId
        );
      },
      onSuccess: (response) async {
        statusView = StatusView.none;
        update();
      },

      onFailure: (statusView,message) async {
          this.statusView = statusView;
          if(statusView==StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
    );
  }

}
