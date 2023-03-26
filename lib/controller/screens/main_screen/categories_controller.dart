
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repository/controller/api/categories_api_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/helper/validator_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/category.dart';
import 'package:repository/view/screen/main_screen/products_screen.dart';

class CategoriesController extends GetxController with GetSingleTickerProviderStateMixin{

  MainController mainController=Get.find();
  CategoriesApiController categoriesApiController=CategoriesApiController(Get.find());
  GlobalKey<FormState> formKeyUpdate = GlobalKey<FormState>();
  late TabController filterTabController;
  List<SortItem> sortItems=[
    SortItem(label: "category name", icon: Icons.text_fields, isSelected: true),
    SortItem(label: "product amount", icon: Icons.bar_chart, isSelected: false),
    SortItem(label: "sales amount", icon: Icons.multiline_chart, isSelected: false),
    SortItem(label: "purchase amount", icon: Icons.stacked_line_chart, isSelected: false),
  ];
  List<Category> allCategories = [], categories = [];
  StatusView statusView= StatusView.loading;

  bool ascending = true, isSearchMode=false;



  @override
  onInit() async {
    filterTabController = TabController(length: sortItems.length, vsync: this);
    await getCategories();
    super.onInit();
  }

  Future<bool> getCategories() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await categoriesApiController.getCategories(repositoryId: mainController.repositoryId);
      },
      onSuccess: (response) async {
        if(response is List<Category>){
          allCategories = response;
          sort(allCategories);
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
  Future<void> createCategory(BuildContext context) async {
    mainController.showDialogCreateCategory(context,
      onSuccess: () async {
        await getCategories();
      },
    );
  }

  void showDialogUpdateCategory(BuildContext context, {required Category category, Future Function()? onSuccess}) {
    mainController.clearFields();
    mainController.nameFieldController.text = category.name;
    HelperDesignFunctions.showAwesomeDialog(
        context,
        btnOkOnPress: () async {
          bool result = await _updateCategory(category);
          if(result && onSuccess!=null){
            await onSuccess.call();
          }
        },
        btnCancelOnPress: () {},
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKeyUpdate,
            child: Column(
              children: [
                Text(
                  "Update Category",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GetBuilder<CategoriesController>(
                      builder: (controller) => CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.primary,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.whiteSecondary,
                          backgroundImage: controller.mainController.image == null
                              ? FileImage(File(category.photo))
                              : FileImage(controller.mainController.image!),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: InkWell(
                        onTap: () async {
                          mainController.image = await HelperLogicFunctions.pickImage(ImageSource.gallery);
                          update();
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor:
                          AppColors.primaryAccent200,
                          child: Icon(
                            Icons.camera,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Category name'),
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                  autofocus: true,
                  controller: mainController.nameFieldController,
                  validator: (text) {
                    return Validate.valid(text!);
                  },
                )
              ],
            ),
          ),
        )
    );
    update();
  }
  Future<bool> _updateCategory(Category category) async {
    if (formKeyUpdate.currentState!.validate()) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return await categoriesApiController.updateCategory(
              name: mainController.nameFieldController.text,
              photo: mainController.image,
              id: category.id
          );
        },
        onSuccess: (response) async {
          HelperDesignFunctions.showSuccessSnackBar(message: "Category '${mainController.nameFieldController.text}' updated");
          await getCategories();
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
    return false;
  }

  void showDialogDeleteCategory(BuildContext context, {required Category category, Future Function()? onSuccess}) {
    HelperDesignFunctions.showAwesomeDialog(context, dialogType: DialogType.error,
        btnOkOnPress: () async {
          bool result = await _deleteCategory(category);
          if(result && onSuccess!=null){
            await onSuccess.call();
            HelperDesignFunctions.showSuccessSnackBar(message: "Category '${category.name}' deleted");
          }
        }, btnCancelOnPress: () {},
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Delete Category",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              Text("Are you sure from delete ${category.name} !")
            ],
          ),
        )
    );
  }
  Future<bool> _deleteCategory(Category category) async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await categoriesApiController.deleteCategory(id: category.id);
      },
      onSuccess: (response) async {
        await getCategories();
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

  Future<void> search(String val) async {
    if (val != '') {
      if (sortItems[0].isSelected) {
        categories = allCategories.where((element) => element.name.toLowerCase().contains(val.toLowerCase())).toList();
      } else if (sortItems[1].isSelected) {
        categories = allCategories.where((element) => element.productsAmount.toString().contains(val.toLowerCase())).toList();
      }else if (sortItems[2].isSelected) {
        categories = allCategories.where((element) => element.salesAmount.toString().contains(val.toLowerCase())).toList();
      } else if (sortItems[3].isSelected) {
        categories = allCategories.where((element) => element.purchasesAmount.toString().contains(val.toLowerCase())).toList();
      }
    } else {
      categories = allCategories;
    }
    update();
  }
  Future<void> sort(List<Category> allCategories) async {
    if (sortItems[0].isSelected) {
      categories = allCategories..sort((a, b) => ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),);
    } else if (sortItems[1].isSelected) {
      categories = allCategories
        ..sort((a, b) {return ascending ? (a.productsAmount - a.productsAmount).ceil() : (b.productsAmount - b.productsAmount).ceil();});
    } else if (sortItems[2].isSelected) {
      categories = allCategories
        ..sort((a, b) {return ascending ? (a.salesAmount - a.salesAmount).ceil() : (b.salesAmount - b.salesAmount).ceil();});

    } else if (sortItems[3].isSelected) {
      categories = allCategories
        ..sort((a, b) {return ascending ? (a.purchasesAmount - a.purchasesAmount).ceil() : (b.purchasesAmount - b.purchasesAmount).ceil();});
    } else {
      categories = allCategories;
    }
    update();
  }
  Future<void> onFilterTab(int index) async {
    for (int i = 0; i < sortItems.length; i++) {
      sortItems[i].isSelected = (i == 0);
    }
    search(mainController.searchFieldController.text);
    update();
  }

}