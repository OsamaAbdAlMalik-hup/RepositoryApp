import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/invoices_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/purchases_invoice.dart';
import 'package:repository/data/models/register.dart';
import 'package:repository/data/models/sale_invoice.dart';

class InvoiceDetailsController extends GetxController {
  InvoicesController invoicesController = Get.find();
  SaleInvoice saleInvoice = SaleInvoice(details: SaleInvoiceDetails());
  PurchasesInvoice purchasesInvoice =
      PurchasesInvoice(details: PurchasesInvoiceDetails());
  InvoiceType invoiceType = InvoiceType.purchases;
  StatusView statusView = StatusView.loading;
  List<Register> registers = [];
  int invoiceId = 1;
  bool isPurchase = false;
  bool isEmpty = true;

  @override
  void onInit() async {
    invoiceId = await Get.arguments[AppSharedKeys.passId];
    invoiceType = await Get.arguments[AppSharedKeys.passInvoiceType];
    await getInvoice();
    super.onInit();
  }

  Future<bool> getInvoice() async {
    if (invoiceType == InvoiceType.sales) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return invoicesController.isArchived
              ? await invoicesController.invoicesApiController
                  .getSalesInvoiceArchive(id: invoiceId)
              : await invoicesController.invoicesApiController
                  .getSalesInvoice(id: invoiceId);
        },
        onSuccess: (response) async {
          if (response is SaleInvoice) {
            saleInvoice = response;
            isPurchase = false;
          }
          statusView = StatusView.none;
          update();
        },
        onFailure: (statusView, message) async {
          this.statusView = statusView;
          if (statusView == StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
      );
    }
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return invoicesController.isArchived
             ? await invoicesController.invoicesApiController
            .getPurchasesInvoiceArchive(id: invoiceId)
            : await invoicesController.invoicesApiController
            .getPurchasesInvoice(id: invoiceId);
      },
      onSuccess: (response) async {
        if (response is PurchasesInvoice) {
          purchasesInvoice = response;
          isPurchase = true;
        }
        statusView = StatusView.none;
        update();
      },
      onFailure: (statusView, message) async {
        this.statusView = statusView;
        if (statusView == StatusView.none) {
          HelperDesignFunctions.showErrorSnackBar(message: message.text);
        }
        update();
      },
    );
  }

  Future<bool> meetDebtInvoice() async {
    if (invoicesController.mainController.formKeyMeetDebt.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return invoiceType == InvoiceType.sales
              ? await invoicesController.invoicesApiController
                  .meetDebtSalesInvoice(
                      id: invoiceId,
                      payment: double.parse(invoicesController
                          .mainController.totalPriceFieldController.text))
              : await invoicesController.invoicesApiController
                  .meetDebtPurchasesInvoice(
                      id: invoiceId,
                      payment: double.parse(invoicesController
                          .mainController.totalPriceFieldController.text));
        },
        onSuccess: (response) async {
          HelperDesignFunctions.showSuccessSnackBar(
              message: "done meet his debts");
          await getInvoice();
        },
        onFailure: (statusView, message) async {
          this.statusView = statusView;
          if (statusView == StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
      );
    }
    return false;
  }

  Future<bool> getInvoiceRegisters({required BuildContext context}) async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return invoiceType == InvoiceType.sales
            ? await invoicesController.invoicesApiController
                .getSalesInvoiceRegisters(id: invoiceId)
            : await invoicesController.invoicesApiController
                .getPurchasesInvoiceRegisters(id: invoiceId);
      },
      onSuccess: (response) async {
        if (response is List<Register>) {
          registers = response;
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
                              await deleteInvoiceRegister(
                                  registerId: registers[index].id);
                            },
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                              : registers[index].typeOperation ==
                              "remove_to_archive"
                              ? const Icon(Icons.unarchive_outlined)
                              : registers[index].typeOperation ==
                              "meet_debt"
                              ? const Icon(Icons
                              .account_balance_wallet_outlined)
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
      onFailure: (statusView, message) async {
        this.statusView = statusView;
        if (statusView == StatusView.none) {
          HelperDesignFunctions.showErrorSnackBar(message: message.text);
        }
        update();
      },
    );
  }

  Future<bool> deleteInvoiceRegister({required int registerId}) async {
    statusView = StatusView.loading;
    update();
    Get.back();
    return await ApiService.sendRequest(
      request: () async {
        return invoiceType == InvoiceType.sales
            ? await invoicesController.invoicesApiController
                .deletePurchasesInvoiceRegister(id: registerId)
            : await invoicesController.invoicesApiController
                .deletePurchasesInvoiceRegister(id: registerId);
      },
      onSuccess: (response) async {
        statusView = StatusView.none;
        update();
      },
      onFailure: (statusView, message) async {
        this.statusView = statusView;
        if (statusView == StatusView.none) {
          HelperDesignFunctions.showErrorSnackBar(message: message.text);
        }
        update();
      },
    );
  }
}
