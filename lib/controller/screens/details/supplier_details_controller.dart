
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/suppliers_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/register.dart';
import 'package:repository/data/models/supplier.dart';

class SupplierDetailsController extends GetxController with GetTickerProviderStateMixin{

  SuppliersController suppliersController=Get.find();
  late TabController tabController;
  int supplierId=1;
  Supplier supplier=Supplier(details: SupplierDetails(),stocktaking: SupplierStocktaking());
  StatusView statusView= StatusView.loading;
  double remainder=0;
  List<Register> registers=[];
  bool isShowDetails=true;

  @override
  void onInit() async {
    tabController=TabController(length: 2, vsync: this);
    supplierId = await Get.arguments[AppSharedKeys.passId];
    await getSupplier();
    super.onInit();
  }

  Future<bool> getSupplier() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return suppliersController.isArchived
            ? await suppliersController.suppliersApiController.getArchiveSupplier(id: supplierId)
            : await suppliersController.suppliersApiController.getSupplier(id: supplierId);
      },
      onSuccess: (response) async {
        if(response is Supplier) {
          supplier=response;
          remainder=supplier.debts;
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
  Future<bool> meetDebtSupplier() async {
    if (suppliersController.mainController.formKeyMeetDebt.currentState!.validate()) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return await suppliersController.suppliersApiController.meetDebtSupplier(
              id: supplier.id,
              payment: double.parse(suppliersController.mainController.totalPriceFieldController.text)
          );
        },
        onSuccess: (response) async {
          HelperDesignFunctions.showSuccessSnackBar(message: "supplier ${supplier.name} done meet his debts");
          await getSupplier();
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
    return false;
  }

  Future<bool> archiveSupplier() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return suppliersController.isArchived
            ? await suppliersController.suppliersApiController.removeSupplierFromArchive(
          id: supplier.id,)
            : await suppliersController.suppliersApiController.addSupplierToArchive(
          id: supplier.id,);
      },
      onSuccess: (response) async {
        Get.back();
        HelperDesignFunctions.showSuccessSnackBar(message: "supplier ${supplier.name} done archived");
        suppliersController.getSuppliers();
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
  Future<bool> getSupplierRegisters({required BuildContext context}) async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await suppliersController.suppliersApiController.getSupplierRegisters(
            id: supplier.id
        );
      },
      onSuccess: (response) async {
        if(response is List<Register>) {
          registers=response;
          HelperDesignFunctions.showFormDialog(context,
              hasButtonsAction: false,
              insetPaddingHorizontal: 50,
              title: "Registers",
              children:[
                SlidableAutoCloseBehavior(
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
                              await deleteSupplierRegister(registerId: registers[index].id);
                            },
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            backgroundColor: AppColors.danger50,
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
                )
              ]
          );
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
  Future<bool> deleteSupplierRegister({required int registerId}) async {
    statusView = StatusView.loading;
    update();
    Get.back();
    return await ApiService.sendRequest(

      request: () async {
        return await suppliersController.suppliersApiController.deleteSupplierRegister(
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
