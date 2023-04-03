import 'package:get/get.dart';
import 'package:repository/controller/api/stocktaking_api_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/category.dart';
import 'package:repository/data/models/client.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/supplier.dart';

class IndividualStocktakingController extends GetxController {
  StocktakingApiController stocktakingApiController =
      StocktakingApiController(Get.find());
  CategoryStocktaking categoryStocktaking = CategoryStocktaking();
  ProductStocktaking productStocktaking = ProductStocktaking();
  ClientStocktaking clientStocktaking = ClientStocktaking();
  SupplierStocktaking supplierStocktaking = SupplierStocktaking();
  MainController mainController = Get.find();

  int id = 0;
  String title = 'Category',
      name = '',
      targetPage = AppPagesRoutes.categoryDetailsScreen;
  StocktakingType stocktakingType = StocktakingType.category;
  StatusView statusView = StatusView.loading;
  bool isCategory = true;
  bool isSupplier = true;

  @override
  onInit() async {
    stocktakingType = Get.arguments[AppSharedKeys.passStocktakingType];
    id = Get.arguments[AppSharedKeys.passId];
    name = Get.arguments[AppSharedKeys.passName];
    mainController.startDate = Get.arguments[AppSharedKeys.passStartDate];
    mainController.endDate = Get.arguments[AppSharedKeys.passEndDate];
    await stocktaking();
    super.onInit();
  }

  Future<void> stocktaking() async {
    statusView = StatusView.loading;
    switch (stocktakingType) {
      case StocktakingType.category:
        {
          await ApiService.sendRequest(
            request: () async {
              return await stocktakingApiController.stocktakingCategory(
                id: id,
                startDate: mainController.startDate,
                endDate: mainController.endDate,
              );
            },
            onSuccess: (response) async {
              if (response is CategoryStocktaking) {
                categoryStocktaking = response;
              }
              title = 'Category';
              targetPage = AppPagesRoutes.categoryDetailsScreen;
              isCategory = true;
              statusView = StatusView.none;
            },
            onFailure: (statusView, message) async {
              this.statusView = statusView;
              if (statusView == StatusView.none) {
                HelperDesignFunctions.showErrorSnackBar(message: message.text);
              }
              update();
            },
          );
          break;
        }
      case StocktakingType.product:
        {
          await ApiService.sendRequest(
            request: () async {
              return await stocktakingApiController.stocktakingProduct(
                  id: id,
                  startDate: mainController.startDate,
                  endDate: mainController.endDate);
            },
            onSuccess: (response) async {
              if (response is ProductStocktaking) {
                productStocktaking = response;
              }
              title = 'Product';
              targetPage = AppPagesRoutes.productDetailsScreen;
              isCategory = false;
              statusView = StatusView.none;
            },
            onFailure: (statusView, message) async {
              this.statusView = statusView;
              if (statusView == StatusView.none) {
                HelperDesignFunctions.showErrorSnackBar(message: message.text);
              }
              update();
            },
          );
          break;
        }
      case StocktakingType.client:
        {
          await ApiService.sendRequest(
            request: () async {
              return await stocktakingApiController.stocktakingClient(
                  id: id,
                  startDate: mainController.startDate,
                  endDate: mainController.endDate);
            },
            onSuccess: (response) async {
              if (response is ClientStocktaking) {
                clientStocktaking = response;
              }
              title = 'Client';
              targetPage = AppPagesRoutes.clientDetailsScreen;
              isSupplier = false;
              statusView = StatusView.none;
            },
            onFailure: (statusView, message) async {
              this.statusView = statusView;
              if (statusView == StatusView.none) {
                HelperDesignFunctions.showErrorSnackBar(message: message.text);
              }
              update();
            },
          );
          break;
        }
      case StocktakingType.supplier:
        {
          await ApiService.sendRequest(
            request: () async {
              return await stocktakingApiController.stocktakingSupplier(
                  id: id,
                  startDate: mainController.startDate,
                  endDate: mainController.endDate);
            },
            onSuccess: (response) async {
              if (response is SupplierStocktaking) {
                supplierStocktaking = response;
              }
              title = 'Supplier';
              targetPage = AppPagesRoutes.supplierDetailsScreen;
              isSupplier = true;
              statusView = StatusView.none;
            },
            onFailure: (statusView, message) async {
              this.statusView = statusView;
              if (statusView == StatusView.none) {
                HelperDesignFunctions.showErrorSnackBar(message: message.text);
              }
              update();
            },
          );
          break;
        }
    }
    update();
  }
}
