
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repository/controller/api/products_api_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/helper/validator_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/category.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/view/screen/main_screen/products_screen.dart';

class ProductsController extends GetxController with GetSingleTickerProviderStateMixin {

  MainController mainController = Get.find();
  ProductsApiController productsApiController=ProductsApiController(Get.find());
  GlobalKey<FormState> formKeyUpdate = GlobalKey<FormState>();
  late TabController filterTabController;
  List<SortItem> sortItems=[
    SortItem(label: "name", icon: Icons.text_fields, isSelected: true),
    SortItem(label: "category", icon: Icons.category, isSelected: false),
    SortItem(label: "profit", icon: Icons.add_chart, isSelected: false),
    SortItem(label: "product amount", icon: Icons.bar_chart, isSelected: false),
    SortItem(label: "selling price", icon: Icons.multiline_chart, isSelected: false),
    SortItem(label: "purchase price", icon: Icons.stacked_line_chart, isSelected: false),
  ];
  List<Product> products = [], allProducts = [];
  StatusView statusView= StatusView.loading;

  bool ascending = true, isSearchMode=false;
  PublicFilterType filterType = PublicFilterType.date;

  @override
  onInit() async {
    filterTabController = TabController(length: sortItems.length, vsync: this);
    filterType = Get.arguments[AppSharedKeys.passFilter]??PublicFilterType.date;
    if(filterType==PublicFilterType.profit){
      sortItems[2].isSelected=true;
    } else if(filterType==PublicFilterType.amount){
      sortItems[3].isSelected=true;
    }
    await getProducts();
    super.onInit();
    if(mainController.categories.isNotEmpty) {
      mainController.selectedCategory = mainController.categories[0];
    } else{
      HelperDesignFunctions.showWarringSnackBar(message: "you can't create any product you must add one category at least");
    }
  }

  Future<bool> getProducts() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await productsApiController.getProducts(repositoryId: mainController.repositoryId);
      },
      onSuccess: (response) async {
        if(response is List<Product>) {
          allProducts =response;
          sort(allProducts);
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
  Future<void> createProduct(BuildContext context) async {
    mainController.clearFields();
    mainController.showSheetCreateProduct(context,
      onSuccess: () async {
        await getProducts();
      },
    );
  }

  void showSheetUpdateProduct(BuildContext context, {required Product product, Future Function()? onSuccess}) {
    mainController.nameFieldController.text = product.name;
    mainController.salePriceFieldController.text = product.salePrice.toString();
    mainController.purchasePriceFieldController.text = product.purchasePrice.toString();
    mainController.selectedCategory = mainController.categories.where((element) => element.id == product.categoryId).toList().first;
    HelperDesignFunctions.showMainBottomSheet(context,
      height: Get.height,
      title: "Update Product",
      btnOkOnPress: () async {
        bool result = await _updateProduct(product);
        if(result && onSuccess!=null){
          await onSuccess.call();
        }
      },
      btnCancelOnPress: () {},
      content: Form(
        key: formKeyUpdate,
        child: Column(
          children: [
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GetBuilder<ProductsController>(
                    builder: (controller) =>
                        CircleAvatar(
                          radius: 105,
                          backgroundColor:
                          AppColors.primary,
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: AppColors.whiteSecondary,
                            backgroundImage:
                            controller.mainController.image ==
                                null
                                ? FileImage(File(product.photo))
                                : FileImage(
                                controller.mainController.image!),
                          ),
                        ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () async {
                        mainController.image=await HelperLogicFunctions.pickImage(ImageSource.gallery);
                        update();
                      },
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor:
                        AppColors.primaryAccent200,
                        child: Icon(
                          Icons.camera,
                          color: AppColors.black,
                          size: 35,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding:
              const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10))),
                  contentPadding: EdgeInsets.all(10),
                ),
                controller: mainController.nameFieldController,
                autovalidateMode:
                AutovalidateMode.onUserInteraction,
                validator: (text) {
                  return Validate.valid(text!);
                },
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'product pay price',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10))),
                  contentPadding: EdgeInsets.all(10),
                ),
                keyboardType: TextInputType.number,
                controller: mainController.purchasePriceFieldController,
                autovalidateMode:
                AutovalidateMode.onUserInteraction,
                validator: (text) {
                  double max = double.infinity;
                  if (mainController.salePriceFieldController.text != '' && mainController.salePriceFieldController.text != '-') {
                    max = double.parse(mainController.salePriceFieldController.text);
                  }
                  return Validate.valid(text!, type: Validate.positiveNum, maxVal: max);
                },
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'product sale price',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10))),
                  contentPadding: EdgeInsets.all(10),
                ),
                keyboardType: TextInputType.number,
                controller: mainController.salePriceFieldController,
                autovalidateMode:
                AutovalidateMode.onUserInteraction,
                validator: (text) {
                  double min = 0;
                  if (mainController.purchasePriceFieldController.text != '' && mainController.purchasePriceFieldController.text != '-') {
                    min = double.parse(mainController.purchasePriceFieldController.text);
                  }
                  return Validate.valid(text!, type: Validate.positiveNum,minVal: min);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              child: GetBuilder<MainController>(
                builder: (controller) => DropdownSearch<Category>(
                  popupProps: PopupProps.dialog(
                    title: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Chose Category"),
                    ),
                    showSearchBox: true,
                    itemBuilder: (context, item, isSelected) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Card(
                          color: AppColors.primary0,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Category",
                    ),
                  ),
                  compareFn: (item1, item2) => true,
                  itemAsString: (item) => item.name,
                  items: controller.categories,
                  selectedItem: controller.selectedCategory,
                  onChanged: (value) {
                    controller.selectedCategory = value!;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
    update();
  }
  Future<bool> _updateProduct(Product product) async {
    if (formKeyUpdate.currentState!.validate()) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return await productsApiController.updateProduct(
              name: mainController.nameFieldController.text,
              photo: mainController.image,
              salePrice: double.parse(mainController.salePriceFieldController.text),
              purchasePrice: double.parse(mainController.purchasePriceFieldController.text),
              categoryId: mainController.selectedCategory.id,
              id: product.id
          );
        },
        onSuccess: (response) async {
          Get.back();
          HelperDesignFunctions.showSuccessSnackBar(message: "Product ${mainController.nameFieldController.text} updated");
          await getProducts();
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

  void showDialogDeleteProduct(BuildContext context, {required Product product, Future Function()? onSuccess}) {
    HelperDesignFunctions.showAwesomeDialog(context, dialogType: DialogType.error,
        btnOkOnPress: () async {
          bool result = await _deleteProduct(product);
          if(result && onSuccess!=null){
            await onSuccess.call();
            HelperDesignFunctions.showSuccessSnackBar(message: "Product ${product.name} deleted");
          }
        }, btnCancelOnPress: () {},
        body: Container(
          height: 0.15 * Get.height,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Delete Product",
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Text("Are you sure from delete ${product.name} !")
            ],
          ),
        )
    );
  }
  Future<bool> _deleteProduct(Product product) async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await productsApiController.deleteProduct(id: product.id);
      },
      onSuccess: (response) async {
        await getProducts();
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
        products = allProducts.where((element) => element.name.toLowerCase().contains(val.toLowerCase())).toList();
      } else if (sortItems[1].isSelected) {
        products = allProducts.where((element) => element.categoryName.toLowerCase().contains(val.toLowerCase())).toList();
      }else if (sortItems[2].isSelected) {
        products = allProducts.where((element) => element.amount.toString().contains(val.toLowerCase())).toList();
      } else if (sortItems[3].isSelected) {
        products = allProducts.where((element) => element.salePrice.toString().contains(val.toLowerCase())).toList();
      } else if (sortItems[4].isSelected) {
        products = allProducts.where((element) => element.purchasePrice.toString().contains(val.toLowerCase())).toList();
      }
    } else {
      products = allProducts;
    }
    update();
  }
  Future<void> sort(List<Product> allProducts) async {
    if (sortItems[0].isSelected) {
      HelperLogicFunctions.printNote(ascending);
      products = allProducts
        ..sort(
          (a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
    } else if (sortItems[1].isSelected) {
      products = allProducts
        ..sort(
          (a, b) => ascending
              ? a.categoryName.toString().compareTo(b.categoryName.toString())
              : b.categoryName.toString().compareTo(a.categoryName.toString()),
        );
    } else if (sortItems[2].isSelected) {
      products = allProducts
        ..sort((a, b) {
          double benefitA = a.salePrice - a.purchasePrice;
          double benefitB = b.salePrice - b.purchasePrice;
          return ascending ? (benefitA-benefitB).ceil() : (benefitB-benefitA).ceil();
        });
    } else if (sortItems[3].isSelected) {
      products = allProducts
        ..sort(
              (a, b) => ascending ? (a.amount-b.amount).ceil() : (b.amount-a.amount).ceil(),
        );
    } else if (sortItems[4].isSelected) {
      products = allProducts
        ..sort(
              (a, b) => ascending ? (a.salePrice-b.salePrice).ceil() : (b.salePrice-a.salePrice).ceil(),
        );
    } else if (sortItems[5].isSelected) {
      products = allProducts
        ..sort(
              (a, b) => ascending ? (a.purchasePrice-b.purchasePrice).ceil() : (b.purchasePrice-a.purchasePrice).ceil(),
        );
    } else {
      products = allProducts;
    }
    update();
  }
  Future<void> onFilterTab(int index) async {
    switch(index){
      case 0:{
        for (int i = 0; i < sortItems.length; i++) {
          sortItems[i].isSelected = (i == 0);
        }
        break;
      }
      case 1:{
        for (int i = 0; i < sortItems.length; i++) {
          sortItems[i].isSelected = (i == 1);
        }
        break;
      }
      case 2:{
        for (int i = 0; i < sortItems.length; i++) {
          sortItems[i].isSelected = (i == 2);
        }
        break;
      }
      case 3:{
        for (int i = 0; i < sortItems.length; i++) {
          sortItems[i].isSelected = (i == 3);
        }
        break;
      }
      case 4:{
        for (int i = 0; i < sortItems.length; i++) {
          sortItems[i].isSelected = (i == 4);
        }
        break;
      }
    }
    search(mainController.searchFieldController.text);
    update();
  }

}
