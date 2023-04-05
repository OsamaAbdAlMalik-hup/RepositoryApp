import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/categories_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/category.dart';
import 'package:repository/data/models/register.dart';

class CategoryDetailsController extends GetxController with GetSingleTickerProviderStateMixin{
  CategoriesController categoriesController = Get.find();
  int categoryId = 0;
  Category category =
      Category(details: CategoryDetails(), stocktaking: CategoryStocktaking());
  List<Register> registers = [];
  late TabController tabController;
  StatusView statusView = StatusView.loading;
  bool isShowDetails=true;

  @override
  void onInit() async {
    tabController=TabController(length: 3, vsync: this);
    categoryId = await Get.arguments[AppSharedKeys.passId];
    await getCategory();
    super.onInit();
  }

  Future<bool> getCategory() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await categoriesController.categoriesApiController
            .getCategory(id: categoryId);
      },
      onSuccess: (response) async {
        if (response is Category) {
          category = response;
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

  Future<bool> getCategoryRegisters({required BuildContext context}) async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await categoriesController.categoriesApiController
            .getCategoryRegisters(id: category.id);
      },
      onSuccess: (response) async {
        if (response is List<Register>) {
          registers = response;
          HelperDesignFunctions.showFormDialog(context,
              hasButtonsAction: false,
              insetPaddingHorizontal: 50,
              title: "Registers",
              children: List.generate(registers.length, (index) => Slidable(
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (c) async {
                        await deleteCategoryRegister(
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
                        : const Icon(Icons.add),
                  ),
                ),
              ))
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

  Future<bool> deleteCategoryRegister({required int registerId}) async {
    statusView = StatusView.loading;
    update();
    Get.back();
    return await ApiService.sendRequest(
      request: () async {
        return await categoriesController.categoriesApiController
            .deleteCategoryRegister(id: registerId);
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
