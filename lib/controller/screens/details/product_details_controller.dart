
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/products_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/register.dart';

class ProductDetailsController extends GetxController with GetSingleTickerProviderStateMixin{

  ProductsController productsController=Get.find();
  late TabController tabController;
  int productId=1;
  Product product=Product(details: ProductDetails(),stocktaking: ProductStocktaking());
  List<Register> registers=[];
  StatusView statusView= StatusView.loading;
  bool isShowDetails=true;


  @override
  void onInit() async {
    tabController=TabController(length: 2, vsync: this);
    productId=await Get.arguments[AppSharedKeys.passId];
    await getProduct();
    super.onInit();
  }

  Future<bool> getProduct() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await productsController.productsApiController.getProduct(id: productId);
      },
      onSuccess: (response) async {
        if(response is Product) {
          product=response;
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
  Future<bool> getProductRegisters({required BuildContext context}) async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await productsController.productsApiController.getProductRegisters(
            id: product.id
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
                              await deleteCategoryRegister(registerId: registers[index].id);
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
  Future<bool> deleteCategoryRegister({required int registerId}) async {
    statusView = StatusView.loading;
    update();
    Get.back();
    return await ApiService.sendRequest(

      request: () async {
        return await productsController.productsApiController.deleteProductRegister(
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
