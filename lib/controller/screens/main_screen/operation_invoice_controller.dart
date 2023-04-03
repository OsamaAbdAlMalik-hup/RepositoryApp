
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/invoice_details_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/controller/screens/main_screen/invoices_controller.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/core/service/storage_services.dart';
import 'package:repository/data/models/classes/pair.dart';
import 'package:repository/data/models/purchases_invoice.dart';
import 'package:repository/data/models/purchase.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/sale_invoice.dart';
import 'package:repository/data/models/sale.dart';

class OperationsInvoiceController extends GetxController {

  MainController mainController=Get.find();
  InvoicesController invoicesController=Get.find();
  late InvoiceDetailsController invoiceDetailsController;

  GlobalKey<FormState> formKeyAddProduct = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyUpdateProduct = GlobalKey<FormState>();
  GlobalKey<FormState> formKeySaveInvoice = GlobalKey<FormState>();
  TextEditingController totalFieldController = TextEditingController();
  TextEditingController paidMoneyFieldController = TextEditingController();

  List<Product> unselectedProducts = [], allProducts = [];
  List<Pair<Product, double>> selectedPairProducts = [];
  List<Sale> sales=[];
  List<Purchase> purchases=[];
  Product selectedProduct=Product(details: ProductDetails(), stocktaking: ProductStocktaking());
  SaleInvoice saleInvoice=SaleInvoice(details: SaleInvoiceDetails());
  PurchasesInvoice purchasesInvoice=PurchasesInvoice(details: PurchasesInvoiceDetails());
  StatusView statusView= StatusView.loading;

  OperationType operationType = OperationType.create;
  InvoiceType invoiceType = InvoiceType.purchases;
  double remained = 0;
  int invoiceId=0,invoiceNumber=0;

  @override
  onInit() async {
    operationType = await Get.arguments[AppSharedKeys.passOperationType];
    invoiceType = await Get.arguments[AppSharedKeys.passInvoiceType];
    await getProductsSomeDetails();
    statusView = StatusView.loading;
    update();if (operationType==OperationType.create){
      totalFieldController.text = '0';
      mainController.dateFieldController.text = HelperDesignFunctions.formatDate(DateTime.now());
      if(invoiceType==InvoiceType.sales) {
        invoiceNumber=StorageServices.sharedPreferences.getInt(AppSharedKeys.latestSaleInvoicesNumber) ?? 20000;
        await invoicesController.mainController.getClientsNames();
      }
      else {
        invoiceNumber=StorageServices.sharedPreferences.getInt(AppSharedKeys.latestPurchaseInvoicesNumber) ?? 30000;
        await invoicesController.mainController.getSuppliersNames();
      }
      unselectedProducts = allProducts;
      if (unselectedProducts.isNotEmpty) {
        selectedProduct = unselectedProducts.take(1).first;
      }
    }
    else {
      invoiceId = await Get.arguments[AppSharedKeys.passId];
      if(invoiceType==InvoiceType.sales) {
        ApiService.sendRequest(
          request: () async {
            return await invoicesController.invoicesApiController.getSalesInvoice(id: invoiceId);
          },
          onSuccess: (response) async {
            if(response is SaleInvoice){
              saleInvoice = response;
              // mainController.totalMoneyBox = (mainController.totalMoneyBox - saleInvoice.totalPrice + saleInvoice.remainder);
              mainController.dateFieldController.text = saleInvoice.date;
              totalFieldController.text = saleInvoice.totalPrice.toString();
              await invoicesController.mainController.getClientsNames();
              if(mainController.clients.isNotEmpty){
                mainController.selectedClient=mainController.clients.where((element) => element.id==saleInvoice.clientId).first;
              }
              sales=saleInvoice.details.sales;
              HelperLogicFunctions.printNote(sales);
              unselectedProducts=allProducts.where((product) {
                for (var sale in sales) {
                  if(product.id == sale.productId) {
                    return false;
                  }
                }
                return true;
              }).toList();
              if(unselectedProducts.isNotEmpty) {
                selectedProduct=unselectedProducts.take(1).first;
              }
              for (var sale in sales) {
                Product product=allProducts.where((product) => product.id==sale.productId).toList().first;
                product.amount+=sale.amount;
                selectedPairProducts.add(Pair(product, sale.amount));
              }
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
      else {

        ApiService.sendRequest(

          request: () async {
            return await invoicesController.invoicesApiController.getPurchasesInvoice(id: invoiceId);
          },
          onSuccess: (response) async {
            if(response is PurchasesInvoice){
              purchasesInvoice = response;
              // mainController.totalMoneyBox = (mainController.totalMoneyBox + purchasesInvoice.totalPrice - purchasesInvoice.remainder);
              mainController.dateFieldController.text = purchasesInvoice.date;
              totalFieldController.text = purchasesInvoice.totalPrice.toString();
              await invoicesController.mainController.getSuppliersNames();
              purchases=purchasesInvoice.details.purchases;
              unselectedProducts=allProducts.where((product) {
                for (var pay in purchases) {
                  if(product.id == pay.productId) {
                    return false;
                  }
                }
                return true;
              }).toList();
              if(unselectedProducts.isNotEmpty) {
                selectedProduct=unselectedProducts.take(1).first;
              }
              for (var purchase in purchases) {
                Product product=allProducts.where((product) => product.id==purchase.productId).toList().first;
                product.amount-=purchase.amount;
                selectedPairProducts.add(Pair(product, purchase.amount));
              }
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
    }
    update();
    super.onInit();
  }

  String getTitle(){
    return '${operationType == OperationType.create ? 'Create' : 'Update'} ${invoiceType == InvoiceType.sales? 'Sale ':'Pay '} Invoice' ;
  }
  Future<bool> getProductsSomeDetails() async {
    ApiService.sendRequest(

      request: () async {
        return await invoicesController.invoicesApiController.getProductsSomeDetails();
      },
      onSuccess: (response) async {
        if(response is List<Product>){
          allProducts=response;
          statusView = StatusView.none;
          update();
        }
      },

      onFailure: (statusView,message) async {
          this.statusView = statusView;
          if(statusView==StatusView.none) {
            HelperDesignFunctions.showErrorSnackBar(message: message.text);
          }
          update();
        },
    );
    return true;
  }
  void addProduct(Product value) {
    if (formKeyAddProduct.currentState!.validate()) {
      double amount = double.parse(mainController.totalPriceFieldController.text);
      double oldTotal = double.parse(totalFieldController.text);
      double total=0;
      if(invoiceType==InvoiceType.sales){
        total = oldTotal + selectedProduct.salePrice * amount;
      } else {
        total = oldTotal + selectedProduct.purchasePrice * amount;
      }
      totalFieldController.text = total.toString();
      selectedPairProducts.add(Pair(value, amount));
      unselectedProducts = allProducts.where((element) {
        for (var e in selectedPairProducts) {
          if (element.id == e.first.id) {
            return false;
          }
        }
        return true;
      }).toList();
    } else {
      HelperDesignFunctions.showErrorSnackBar(message: 'available amount not enough');
    }
    update();
  }
  void updateProduct(int i) {
    if (formKeyUpdateProduct.currentState!.validate()) {
      double amount = double.parse(mainController.totalPriceFieldController.text);
      double oldTotal = double.parse(totalFieldController.text);
      double total = oldTotal - selectedPairProducts[i].first.salePrice * selectedPairProducts[i].second;
      total += selectedPairProducts[i].first.salePrice * amount;
      totalFieldController.text = total.toString();
      selectedPairProducts[i].second = amount;
    } else {
      HelperDesignFunctions.showErrorSnackBar(message: 'available amount not enough');
    }
    update();
  }
  void deleteProduct(int index) {
    double total=double.parse(totalFieldController.text);
    double price=invoiceType==InvoiceType.sales? selectedPairProducts[index].first.salePrice:selectedPairProducts[index].first.purchasePrice;
    totalFieldController.text=(total- selectedPairProducts[index].second * price ).toString();
    unselectedProducts.add(selectedPairProducts[index].first);
    selectedPairProducts.removeAt(index);
    HelperDesignFunctions.showSuccessSnackBar(message: 'Done delete ');
    update();
  }

  Future<bool> createInvoice() async {
    if (invoiceType == InvoiceType.sales) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          List<Map> sales=[];
          for (var element in selectedPairProducts) {
            sales.add({
              AppResponseKeys.productId:element.first.id,
              AppResponseKeys.amount:element.second,
              AppResponseKeys.totalPurchasePrice:element.first.purchasePrice*element.second,
              AppResponseKeys.totalSalePrice:element.first.salePrice*element.second,
            });
          }
          StorageServices.sharedPreferences.setInt(AppSharedKeys.latestSaleInvoicesNumber,++invoiceNumber);
          return await invoicesController.invoicesApiController.addSalesInvoice(
              clientId: mainController.selectedClient.id,
              number: invoiceNumber,
              totalPrice: double.parse(totalFieldController.text),
              remained: remained,
              date: mainController.dateFieldController.text,
              sales: sales
          );
        },
        onSuccess: (response) async {
          if(Get.previousRoute == AppPagesRoutes.invoicesScreen){
            await invoicesController.onMainTabChange(invoicesController.mainTabIndex);
          }
          await mainController.onNavBarChange(mainController.selectedBottomNavigationBarItem);
          statusView = StatusView.none;
          update();
          Get.back();
          HelperDesignFunctions.showSuccessSnackBar(message: "Sales Invoice number # $invoiceNumber created");
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
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        List<Map> purchases=[];
        for (var element in selectedPairProducts) {
          purchases.add({
            AppResponseKeys.productId:element.first.id,
            AppResponseKeys.amount:element.second,
            AppResponseKeys.totalPurchasePrice:element.first.purchasePrice*element.second,
            AppResponseKeys.totalSalePrice:element.first.salePrice*element.second,
          });
        }
        StorageServices.sharedPreferences.setInt(AppSharedKeys.latestPurchaseInvoicesNumber,++invoiceNumber);
        return await invoicesController.invoicesApiController.addPurchasesInvoice(
            supplierId: mainController.selectedSupplier.id,
            number: invoiceNumber,
            totalPrice: double.parse(totalFieldController.text),
            remained: remained,
            date: mainController.dateFieldController.text,
            purchases: purchases
        );
      },
      onSuccess: (response) async {
        if(Get.previousRoute == AppPagesRoutes.invoicesScreen){
            await invoicesController.onMainTabChange(invoicesController.mainTabIndex);
        }
        await mainController.onNavBarChange(mainController.selectedBottomNavigationBarItem);
        Get.back();
        statusView = StatusView.none;
        update();
        HelperDesignFunctions.showSuccessSnackBar(message: "Purchases Invoice number # $invoiceNumber created");
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
  Future<bool> updateInvoice() async {
    if (invoiceType == InvoiceType.sales) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          List<Map> sales=[];
          for (var element in selectedPairProducts) {
            sales.add({
              AppResponseKeys.productId:element.first.id,
              AppResponseKeys.amount:element.second,
              AppResponseKeys.totalPurchasePrice:element.first.purchasePrice*element.second,
              AppResponseKeys.totalSalePrice:element.first.salePrice*element.second,
            });
          }
          return await invoicesController.invoicesApiController.updateSalesInvoice(
              id: invoiceId,
              totalPrice: double.parse(totalFieldController.text),
              remained: remained,
              clientId: mainController.selectedClient.id,
              date: mainController.dateFieldController.text,
              sales: sales
          );
        },
        onSuccess: (response) async {
          if(Get.previousRoute==AppPagesRoutes.invoicesScreen){
            invoicesController=Get.find();
              await invoicesController.onMainTabChange(invoicesController.mainTabIndex);
          }
          if(Get.previousRoute==AppPagesRoutes.invoiceDetailsScreen){
            invoiceDetailsController=Get.find();
            await invoiceDetailsController.getInvoice();
          }
          await mainController.onNavBarChange(mainController.selectedBottomNavigationBarItem);
          statusView = StatusView.none;
          update();
          Get.back();
          HelperDesignFunctions.showSuccessSnackBar(message: "Sales Invoice number # $invoiceNumber updated");
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
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        List<Map> purchases=[];
        for (var element in selectedPairProducts) {
          purchases.add({
            AppResponseKeys.productId:element.first.id,
            AppResponseKeys.amount:element.second,
            AppResponseKeys.totalPurchasePrice:element.first.purchasePrice*element.second,
            AppResponseKeys.totalSalePrice:element.first.salePrice*element.second,
          });
        }
        return await invoicesController.invoicesApiController.updatePurchasesInvoice(
            totalPrice: double.parse(totalFieldController.text),
            paid: remained,
            supplierId: mainController.selectedSupplier.id,
            date: mainController.dateFieldController.text,
            purchases: purchases,
            id: invoiceId
        );
      },
      onSuccess: (response) async {
        if(Get.previousRoute==AppPagesRoutes.invoicesScreen){
          invoicesController=Get.find();
            await invoicesController.onMainTabChange(invoicesController.mainTabIndex);
        }
        if(Get.previousRoute==AppPagesRoutes.invoiceDetailsScreen){
          invoiceDetailsController=Get.find();
          await invoiceDetailsController.getInvoice();
        }
        await mainController.onNavBarChange(mainController.selectedBottomNavigationBarItem);
        statusView = StatusView.none;
        update();
        Get.back();
        HelperDesignFunctions.showSuccessSnackBar(message: "Purchases Invoice number # $invoiceNumber updated");
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
