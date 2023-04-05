
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/api/invoices_api_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/core/service/storage_services.dart';
import 'package:repository/data/models/purchases_invoice.dart';
import 'package:repository/data/models/sale_invoice.dart';
import 'package:repository/view/screen/main_screen/products_screen.dart';

class InvoicesController extends GetxController with GetTickerProviderStateMixin {

  MainController mainController=Get.find();
  InvoicesApiController invoicesApiController=InvoicesApiController(Get.find());
  late TabController filterTabController,mainTabController;

  List<SaleInvoice> saleInvoices=[],allSaleInvoices=[];
  List<PurchasesInvoice> purchasesInvoices=[],allPurchasesInvoices=[];

  bool ascending = true, isSearchMode=false,isArchived = false;
  List<SortItem> sortItems=[
    SortItem(label: "number", icon: Icons.numbers, isSelected: true),
    SortItem(label: "total", icon: Icons.movie_filter, isSelected: false),
    SortItem(label: "debt", icon: Icons.account_balance_wallet, isSelected: false),
    SortItem(label: "date", icon: Icons.date_range, isSelected: false),
    SortItem(label: "name", icon: Icons.text_fields, isSelected: false),
  ];
  PublicFilterType filterType = PublicFilterType.date;
  ViewModeType viewModeType=ViewModeType.defaultMode;
  StatusView statusView= StatusView.loading;
  int mainTabIndex=0, filterTabIndex=0;
  double totalMoneyBox=0;

  @override
  onInit() async {
    filterTabController = TabController(length: sortItems.length, vsync: this);
    mainTabController = TabController(length: 2, vsync: this);

    if(!(StorageServices.sharedPreferences.getBool(AppSharedKeys.isInitNumbers)??false)){
      StorageServices.sharedPreferences.setInt(AppSharedKeys.latestSaleInvoicesNumber,20000);
      StorageServices.sharedPreferences.setInt(AppSharedKeys.latestPurchaseInvoicesNumber,30000);
      StorageServices.sharedPreferences.setBool(AppSharedKeys.isInitNumbers,true);
    }
    viewModeType = HelperLogicFunctions.getVale(
        map: Get.arguments,
        key: AppSharedKeys.passViewMode,
        defaultVal: ViewModeType.defaultMode
    );
    filterType = HelperLogicFunctions.getVale(
        map: Get.arguments,
        key: AppSharedKeys.passFilter,
        defaultVal: PublicFilterType.date
    );

    isArchived = viewModeType == ViewModeType.archiveMode;
    if(filterType == PublicFilterType.salesInvoices){
      mainTabController.animateTo(1);
      mainTabIndex=1;
      await getSaleInvoices();
    }
    else {
      await getPurchasesInvoices();
    }
    HelperLogicFunctions.printNote(isArchived);

    update();
    super.onInit();
  }

  Future<bool> getSaleInvoices() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return isArchived
            ? await invoicesApiController.getSalesInvoicesArchive()
            : await invoicesApiController.getSalesInvoices();
      },
      onSuccess: (response) async {
        if(response is List<SaleInvoice>) {
          allSaleInvoices = response;
          sort(allSaleInvoices);
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
  Future<bool> getPurchasesInvoices() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return isArchived
            ? await invoicesApiController.getPurchasesInvoicesArchive()
            : await invoicesApiController.getPurchasesInvoices();
      },
      onSuccess: (response) async {
        if(response is List<PurchasesInvoice>) {
          allPurchasesInvoices = response;
          sort(allPurchasesInvoices);
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

  void showDialogDeleteInvoice(BuildContext context, {invoice,required InvoiceType invoiceType, Future Function()? onSuccess}) {
    HelperDesignFunctions.showAlertDialog(context,
        btnOkOnPress: () async {
          bool result = await _deleteInvoice(invoice: invoice,invoiceType: invoiceType);
          if(result){
            if(onSuccess!=null){
              await onSuccess.call();
            }
            HelperDesignFunctions.showSuccessSnackBar(message: "${invoiceType==InvoiceType.sales?'Sales':'Purchases'} Invoice ${invoice.number} deleted");
          }
        },
        title: "Delete Invoice",
        subTitle: "Are you sure from delete ${invoiceType==InvoiceType.sales?'Sales':'Purchases'} Invoice ${invoice.number} !",
        okText: "Delete",
        dialogType: "delete",
    );
  }
  Future<bool> _deleteInvoice({invoice,required InvoiceType invoiceType,}) async {
    if(invoiceType==InvoiceType.sales) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return await invoicesApiController.deleteSalesInvoice(id: invoice.id);
        },
        onSuccess: (response) async {
          await getSaleInvoices();
          await mainController.onNavBarChange(mainController.selectedBottomNavigationBarItem);
        },

        onFailure: (statusView,message) async {
          this.statusView = statusView;
          if(statusView==StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
      );
    } else {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return await invoicesApiController.deletePurchasesInvoice(id: invoice.id);
        },
        onSuccess: (response) async {
          await getPurchasesInvoices();
          await mainController.onNavBarChange(mainController.selectedBottomNavigationBarItem);
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

  Future<bool> archiveInvoice({invoice,required InvoiceType invoiceType,void Function()? onSuccess}) async {
    if(invoiceType==InvoiceType.sales) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(
        request: () async {
            return isArchived
            ? await invoicesApiController.removeSalesInvoiceFromArchive(id: invoice.id)
            : await invoicesApiController.addSalesInvoiceToArchive(id: invoice.id);
        },
        onSuccess: (response) async {
          if(onSuccess!=null){
            onSuccess.call();
          }
          getSaleInvoices();
          await mainController.onNavBarChange(mainController.selectedBottomNavigationBarItem);
          HelperDesignFunctions.showSuccessSnackBar(message: "Sales Invoice ${invoice.number} archived");
        },

        onFailure: (statusView,message) async {
          this.statusView = statusView;
          if(statusView==StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
      );
    } else {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return isArchived
              ? await invoicesApiController.removePurchasesInvoiceFromArchive(id: invoice.id)
              : await invoicesApiController.addPurchasesInvoiceToArchive(id: invoice.id);
        },
        onSuccess: (response) async {
          await getPurchasesInvoices();
          await mainController.onNavBarChange(mainController.selectedBottomNavigationBarItem);
          HelperDesignFunctions.showSuccessSnackBar(message: "Purchases Invoice ${invoice.number} archived");
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

  Future<void> search(String val) async {
    if(mainTabIndex==1){
      if (val != '') {
        if (mainController.filterTabIndex==0) {
          saleInvoices = allSaleInvoices.where((element) => element.number.toString().contains(val.toLowerCase())).toList();
        } else if (mainController.filterTabIndex==1) {
          saleInvoices = allSaleInvoices.where((element) => element.totalPrice.toString().contains(val.toLowerCase())).toList();
        } else if (mainController.filterTabIndex==2) {
          saleInvoices = allSaleInvoices.where((element) => element.remained.toString().contains(val.toLowerCase())).toList();
        } else if (mainController.filterTabIndex==3) {
          saleInvoices = allSaleInvoices.where((element) => element.date.contains(val.toLowerCase())).toList();
        } else if (mainController.filterTabIndex==4) {
          saleInvoices = allSaleInvoices.where((element) => element.clientName.toLowerCase().contains(val.toLowerCase())).toList();
        }
      } else {
        saleInvoices = allSaleInvoices;
      }
    } else {
      if (val != '') {
        if (mainController.filterTabIndex==0) {
          purchasesInvoices = allPurchasesInvoices.where((element) => element.number.toString().contains(val.toLowerCase())).toList();
        } else if (mainController.filterTabIndex==1) {
          purchasesInvoices = allPurchasesInvoices.where((element) => element.totalPrice.toString().contains(val.toLowerCase())).toList();
        } else if (mainController.filterTabIndex==2) {
          purchasesInvoices = allPurchasesInvoices.where((element) => element.remained.toString().contains(val.toLowerCase())).toList();
        } else if (mainController.filterTabIndex==3) {
          purchasesInvoices = allPurchasesInvoices.where((element) => element.date.toString().contains(val.toLowerCase())).toList();
        } else if (mainController.filterTabIndex==4) {
          purchasesInvoices = allPurchasesInvoices.where((element) => element.supplierName.toLowerCase().contains(val.toLowerCase())).toList();
        }
      } else {
        purchasesInvoices = allPurchasesInvoices;
      }
    }
    update();
  }
  Future<void> sort(List invoices) async {
    if(mainTabIndex==1){
      invoices=invoices as List<SaleInvoice>;
      if (sortItems[0].isSelected) {
        saleInvoices = invoices
          ..sort((a, b) => ascending
              ? a.number.toString().toLowerCase().compareTo(b.number.toString().toLowerCase())
              : b.number.toString().toLowerCase().compareTo(a.number.toString().toLowerCase()),
          );
      }
      else if (sortItems[1].isSelected) {
        saleInvoices = invoices
          ..sort((a, b) => ascending ? (a.totalPrice - b.totalPrice).ceil() : (b.totalPrice - a.totalPrice).ceil()
          );
      }
      else if (sortItems[2].isSelected) {
        saleInvoices = invoices
          ..sort((a, b) => ascending ? (a.remained - b.remained).ceil() : (b.remained - a.remained).ceil()
          );
      }
      else if (sortItems[3].isSelected) {
        saleInvoices = invoices
          ..sort((a, b) => ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
          );
      }
      else if (sortItems[4].isSelected) {
        saleInvoices = invoices
          ..sort((a, b) => ascending ? a.clientName.compareTo(b.clientName) : b.clientName.compareTo(a.clientName),
          );
      }
      else {
        saleInvoices = invoices;
      }
    }
    else {
      invoices = invoices as List<PurchasesInvoice>;
      if (sortItems[0].isSelected) {
        purchasesInvoices = invoices
          ..sort((a, b) => ascending
              ? a.number.toString().compareTo(b.number.toString().toLowerCase())
              : b.number.toString().toLowerCase().compareTo(a.number.toString().toLowerCase()),
          );
      }
      else if (sortItems[1].isSelected) {
        purchasesInvoices = invoices
          ..sort((a, b) => ascending ? (a.totalPrice - b.totalPrice).ceil() : (b.totalPrice - a.totalPrice).ceil());
      }
      else if (sortItems[2].isSelected) {
        purchasesInvoices = invoices
          ..sort((a, b) => ascending ? (a.remained - b.remained).ceil() : (b.remained - a.remained).ceil());
      }
      else if (sortItems[3].isSelected) {
        purchasesInvoices = invoices
          ..sort((a, b) => ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
          );
      }
      else if (sortItems[4].isSelected) {
        purchasesInvoices = invoices
          ..sort((a, b) => ascending ? a.supplierName.compareTo(b.supplierName) : b.supplierName.compareTo(a.supplierName),
          );
      }
      else {
        purchasesInvoices = invoices;
      }
    }
    update();
  }
  Future<void> onFilterTabChange(int tabIndex) async {
    for (int i = 0; i < sortItems.length; i++) {
      sortItems[i].isSelected = (i == tabIndex);
    }
    search(mainController.searchFieldController.text);
    update();
  }
  Future<void> onMainTabChange(int tabIndex) async {
    mainTabIndex=tabIndex;
    if(tabIndex==0){
      await getPurchasesInvoices();
    }
    else if(tabIndex==1){
      await getSaleInvoices();
    }
    update();
  }

}
