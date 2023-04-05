
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repository/controller/api/categories_api_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
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
  List<String> searchItem=['name','product amount','sales amount','purchases amount'];
  List<Category> allCategories = [], categories = [];
  StatusView statusView= StatusView.loading;
  bool ascending = true, isSearchMode = false;



  @override
  onInit() async {
    filterTabController = TabController(length: searchItem.length, vsync: this);
    await getCategories();
    super.onInit();
  }

  Future<bool> getCategories() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await categoriesApiController.getCategories(repositoryId: RegistrationController.currentRepository.id);
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
    HelperDesignFunctions.showAlertDialog(context,
        btnOkOnPress: () async {
          bool result = await _updateCategory(category);
          if(result && onSuccess!=null){
            await onSuccess.call();
          }
        },
        title: "Update Category",
        children:[
          Form(
            key: formKeyUpdate,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GetBuilder<CategoriesController>(
                      builder: (controller) => CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.primary50,
                        child: controller.mainController.image != null
                            ? CircleAvatar(
                              radius: 50,
                              //
                              backgroundColor: AppColors.primary0,
                              backgroundImage: FileImage(controller.mainController.image!),)
                            : category.photo != ''
                                ? CircleAvatar(
                                  radius: 50,
                                  backgroundColor: AppColors.primary0,
                                  backgroundImage: CachedNetworkImageProvider(category.photo),)
                                : CircleAvatar(
                                  radius: 50,
                                  backgroundColor: AppColors.primary0,
                                  child: SvgPicture.asset(
                                    AppAssets.categoriesIconSvg,
                                    color: AppColors.primary60,
                                  ),),
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
                          AppColors.primary30,
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
          )
        ]
    );
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
    HelperDesignFunctions.showAlertDialog(context,
        btnOkOnPress: () async {
          bool result = await _deleteCategory(category);
          if(result && onSuccess!=null){
            await onSuccess.call();
            HelperDesignFunctions.showSuccessSnackBar(message: "Category '${category.name}' deleted");
          }
        },
        title: "Delete Category",
        subTitle: "Are you sure from delete ${category.name} !",
        okText: "Delete",
        dialogType: "delete",
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
      switch(mainController.filterTabIndex){
        case 0:{
          categories = allCategories.where((element) => element.name.toLowerCase().contains(val.toLowerCase())).toList();
          break;
        }
        case 1:{
          categories = allCategories.where((element) => element.productsAmount.toString().contains(val)).toList();
          break;
        }
        case 2:{
          categories = allCategories.where((element) => element.salesAmount.toString().contains(val)).toList();
          break;
        }
        case 3:{
          categories = allCategories.where((element) => element.purchasesAmount.toString().contains(val)).toList();
          break;
        }
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
        ..sort((a, b) {return ascending ? (a.productsAmount - b.productsAmount).ceil() : (b.productsAmount - a.productsAmount).ceil();});
    } else if (sortItems[2].isSelected) {
      categories = allCategories
        ..sort((a, b) {return ascending ? (a.salesAmount - b.salesAmount).ceil() : (b.salesAmount - a.salesAmount).ceil();});

    } else if (sortItems[3].isSelected) {
      categories = allCategories
        ..sort((a, b) {return ascending ? (a.purchasesAmount - b.purchasesAmount).ceil() : (b.purchasesAmount - a.purchasesAmount).ceil();});
    } else {
      categories = allCategories;
    }
    update();
  }
}