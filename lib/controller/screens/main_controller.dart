import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repository/controller/api/main_screen_api_controller.dart';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/helper/validator_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/core/service/get_storage_service.dart';
import 'package:repository/core/service/shared_preferences_service.dart';
import 'package:repository/data/models/category.dart';
import 'package:repository/data/models/client.dart';
import 'package:repository/data/models/money_box_operation.dart';
import 'package:repository/data/models/monitoring.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/repository.dart';
import 'package:repository/data/models/supplier.dart';
import 'package:repository/data/models/user.dart';

class MainController extends GetxController with GetTickerProviderStateMixin{
  SharedPreferencesService sharedService = Get.find();
  MainScreenApiController mainApiController = MainScreenApiController(Get.find(), 0);
  RegistrationController registrationController = Get.put(RegistrationController());

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKeyCreateCategory = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCreateProduct = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCreateClientOrSupplier = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCreateExpense = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyCreateMoneyOperation = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyMeetDebt = GlobalKey<FormState>();

  TextEditingController searchFieldController = TextEditingController();
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController salePriceFieldController = TextEditingController();
  TextEditingController purchasePriceFieldController = TextEditingController();
  TextEditingController phoneNumberFieldController = TextEditingController();
  TextEditingController addressFieldController = TextEditingController();
  TextEditingController detailsFieldController = TextEditingController();
  TextEditingController amountFieldController = TextEditingController();
  TextEditingController dateFieldController = TextEditingController();
  PageController pageController = PageController(initialPage: 0);
  ScrollController monitoringScrollController = ScrollController();
  ScrollController stockingScrollController = ScrollController();
  ScrollController homeScrollController = ScrollController();
  late TabController tabLatestInvoiceController;
  late TabController tabPopularPeopleController;
  late TabController tabProductsController;

  List<Category> categories = [];
  List<Product> products = [];
  List<Client> clients = [];
  List<Supplier> suppliers = [];

  dynamic selectedItem;
  Category selectedCategory = Category(details: CategoryDetails(), stocktaking: CategoryStocktaking());
  Product selectedProduct = Product(details: ProductDetails(), stocktaking: ProductStocktaking());
  Client selectedClient = Client(details: ClientDetails(), stocktaking: ClientStocktaking());
  Supplier selectedSupplier = Supplier(details: SupplierDetails(), stocktaking: SupplierStocktaking());
  Monitoring monitoring = Monitoring();
  FullStocktaking fullStocktaking = FullStocktaking();
  StatusView statusView = StatusView.loading;
  DateTime? lastPressedGoBack;
  File? image;
  String token = '', name = '', email = '', startDate = '', endDate = '';
  double totalMoneyBox = 10000000000, invoicesHeight = 250, remainder = 0;
  bool isEmailsExpansion = false, isVisibleNav = true, isSearchMode = false;
  int selectedBottomNavigationBarItem = 1, repositoryId = 0,latestInvoiceTabIndex=0,popularPeopleTabIndex=0,productsTabIndex=0;
  GetStorageService storageService=Get.find();

  @override
  onInit() async {
    tabLatestInvoiceController=TabController(length: 3, vsync: this);
    tabPopularPeopleController=TabController(length: 2, vsync: this);
    tabProductsController=TabController(length: 2, vsync: this);

    int currentUserId = sharedService.sharedPreferences.getInt(AppSharedKeys.currentUserId) ?? 0;
    int currentRepositoryId = sharedService.sharedPreferences.getInt(AppSharedKeys.currentRepositoryId) ?? 0;
    registrationController.currentUser = registrationController.myAccounts
        .firstWhere((element) => element.id == currentUserId, orElse: () => User());
    registrationController.currentRepository = registrationController.myRepositories
        .firstWhere((element) => element.id == currentRepositoryId, orElse: () => Repository());

    mainApiController = MainScreenApiController(Get.find(), repositoryId);
    await getCategoriesNames();
    await registrationController.getRepositoriesForUser();
    await registrationController.getUsersForRepositories(repositoryId: repositoryId);
    statusView = StatusView.none;
    update();
    super.onInit();
  }

  void showDialogCreateCategory(BuildContext context, {Future Function()? onSuccess}) {
    clearFields();
    HelperDesignFunctions.showAwesomeDialog(context, btnOkOnPress: () async {
      bool result = await _createCategory();
      if (result && onSuccess != null) {
        await onSuccess.call();
      }
    },
        btnCancelOnPress: () {},
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKeyCreateCategory,
            child: Column(
              children: [
                Text(
                  "Create Category",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(
                  thickness: 2,
                  height: 20,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GetBuilder<MainController>(
                      builder: (controller) => CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.primary60,
                        child: CircleAvatar(
                          backgroundImage: controller.image != null
                              ? FileImage(controller.image!)
                              : null,
                          radius: 50,
                          backgroundColor: AppColors.primary5,
                          child: controller.image == null
                              ? SvgPicture.asset(
                                  AppAssets.categoriesIconSvg,
                                  color: AppColors.primary60,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: InkWell(
                        onTap: () async {
                          image = await HelperLogicFunctions.pickImage(
                              ImageSource.gallery);
                          update();
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary10,
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
                    label: Text("Category"),
                    hintText: 'Category name',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: nameFieldController,
                  validator: (text) {
                    return Validate.valid(text!);
                  },
                )
              ],
            ),
          ),
        ));
    update();
  }
  Future<bool> _createCategory() async {
    if (formKeyCreateCategory.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await mainApiController.addCategory(
              name: nameFieldController.text, photo: image);
        },
        onSuccess: (response) async {
          HelperDesignFunctions.showSuccessSnackBar(
              message: "Category '${nameFieldController.text}' created");
          onNavBarChange(selectedBottomNavigationBarItem);
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
    return false;
  }
  void showSheetCreateProduct(BuildContext context, {Future Function()? onSuccess}) {
    clearFields();
    if (categories.isEmpty) {
      HelperDesignFunctions.showWarringSnackBar(
          title: 'Note',
          message:
              "you can't create any product you must add one category at least");
      return;
    }
    HelperDesignFunctions.showMainBottomSheet(context,
        title: "Create Product", height: Get.height, btnOkOnPress: () async {
      bool result = await _createProduct();
      if (result && onSuccess != null) {
        await onSuccess.call();
      }
    }, btnCancelOnPress: () {
      Get.back();
    },
        content: Form(
          key: formKeyCreateProduct,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GetBuilder<MainController>(
                      builder: (controller) => CircleAvatar(
                        radius: 105,
                        backgroundColor: AppColors.primary,
                        child: CircleAvatar(
                          backgroundImage: controller.image != null
                              ? FileImage(controller.image!)
                              : null,
                          radius: 100,
                          backgroundColor: AppColors.whiteSecondary,
                          child: controller.image == null
                              ? SvgPicture.asset(
                                  AppAssets.productsIconSvg,
                                  color: AppColors.primary,
                                  height: 100,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: InkWell(
                        onTap: () async {
                          image = await HelperLogicFunctions.pickImage(
                              ImageSource.gallery);
                          update();
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primaryAccent200,
                          child: Icon(
                            Icons.camera,
                            size: 30,
                            color: AppColors.black,
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
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Product name',
                  ),
                  controller: nameFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    return Validate.valid(text!);
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'product pay price',
                  ),
                  keyboardType: TextInputType.number,
                  controller: purchasePriceFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    double max = double.infinity;
                    if (salePriceFieldController.text != '' &&
                        salePriceFieldController.text != '-') {
                      max = double.parse(salePriceFieldController.text);
                    }
                    return Validate.valid(text!,
                        type: Validate.positiveNum, maxVal: max);
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'product sale price',
                  ),
                  keyboardType: TextInputType.number,
                  controller: salePriceFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    double min = 0;
                    if (purchasePriceFieldController.text != '' &&
                        purchasePriceFieldController.text != '-') {
                      min = double.parse(purchasePriceFieldController.text);
                    }
                    return Validate.valid(text!,
                        type: Validate.positiveNum, minVal: min);
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
        ));
    update();
  }
  Future<bool> _createProduct() async {
    if (formKeyCreateProduct.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await mainApiController.addProduct(
            name: nameFieldController.text,
            salePrice: double.parse(salePriceFieldController.text),
            purchasePrice: double.parse(purchasePriceFieldController.text),
            measuringUnit: "Kg",
            categoryId: selectedCategory.id,
            photo: image,
          );
        },
        onSuccess: (response) async {
          Get.back();
          HelperDesignFunctions.showSuccessSnackBar(
              message: "Product '${nameFieldController.text}' created");
          statusView = StatusView.none;
          onNavBarChange(selectedBottomNavigationBarItem);
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
    return false;
  }
  void showSheetCreateClientOrSupplier(BuildContext context, {required bool isClient, Future Function()? onSuccess}) {
    clearFields();
    HelperDesignFunctions.showMainBottomSheet(context,
        title: "Create ${isClient ? 'Client' : 'Supplier'}",
        height: Get.height, btnOkOnPress: () async {
      bool result = false;
      if (isClient) {
        result = await _createClient();
      } else {
        result = await _createSupplier();
      }
      if (result && onSuccess != null) {
        await onSuccess.call();
      }
    }, btnCancelOnPress: () {
      Get.back();
    },
        content: Form(
          key: formKeyCreateClientOrSupplier,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GetBuilder<MainController>(
                      builder: (controller) => CircleAvatar(
                        radius: 105,
                        backgroundColor: AppColors.primary,
                        child: CircleAvatar(
                          backgroundImage: controller.image != null
                              ? FileImage(controller.image!)
                              : null,
                          radius: 100,
                          backgroundColor: AppColors.whiteSecondary,
                          child: controller.image == null
                              ? SvgPicture.asset(
                                  AppAssets.clientsIconSvg,
                                  color: AppColors.primary,
                                  height: 100,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          image = await HelperLogicFunctions.pickImage(
                              ImageSource.gallery);
                          update();
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primaryAccent200,
                          child: Icon(
                            Icons.camera,
                            size: 30,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  autofocus: true,
                  controller: nameFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    return Validate.valid(text!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Phone number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  keyboardType: TextInputType.phone,
                  controller: phoneNumberFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    return Validate.valid(text!, type: Validate.phone);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  keyboardType: TextInputType.text,
                  controller: addressFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    return Validate.valid(text!);
                  },
                ),
              ),
            ],
          ),
        ));
    update();
  }
  Future<bool> _createClient() async {
    if (formKeyCreateClientOrSupplier.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await mainApiController.addClient(
            name: nameFieldController.text,
            phoneNumber: phoneNumberFieldController.text,
            address: addressFieldController.text,
            photo: image,
          );
        },
        onSuccess: (response) async {
          Get.back();
          statusView = StatusView.none;
          HelperDesignFunctions.showSuccessSnackBar(
              message: "Client '${nameFieldController.text}' created");
          onNavBarChange(selectedBottomNavigationBarItem);
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
    return false;
  }
  Future<bool> _createSupplier() async {
    if (formKeyCreateClientOrSupplier.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await mainApiController.addSupplier(
            name: nameFieldController.text,
            phoneNumber: phoneNumberFieldController.text,
            address: addressFieldController.text,
            photo: image,
          );
        },
        onSuccess: (response) async {
          Get.back();
          statusView = StatusView.none;
          HelperDesignFunctions.showSuccessSnackBar(
              message: "Supplier '${nameFieldController.text}' created");
          onNavBarChange(selectedBottomNavigationBarItem);
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
    return false;
  }
  void showSheetCreateExpense(BuildContext context, {Future Function()? onSuccess}) {
    clearFields();
    HelperDesignFunctions.showMainBottomSheet(context,
        title: "Add Expense", height: Get.height, btnOkOnPress: () async {
      bool result = await _createExpense();
      if (result && onSuccess != null) {
        await onSuccess.call();
      }
    }, btnCancelOnPress: () {
      Get.back();
    },
        content: Form(
          key: formKeyCreateExpense,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  autofocus: true,
                  controller: nameFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    return Validate.valid(text!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Cost',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  keyboardType: TextInputType.number,
                  controller: amountFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    String? message =
                        Validate.valid(text!, type: Validate.positiveNum);
                    if (message == null && double.parse(text) > totalMoneyBox) {
                      return 'Money not enough to Expense you have $totalMoneyBox \$';
                    }
                    return message;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Details',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  keyboardType: TextInputType.text,
                  controller: detailsFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    return Validate.valid(text!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  controller: dateFieldController,
                  readOnly: true,
                  onTap: () async {
                    dateFieldController.text =
                        await HelperDesignFunctions.choseDate(context) ??
                            dateFieldController.text;
                  },
                ),
              ),
            ],
          ),
        ));
    update();
  }
  Future<bool> _createExpense() async {
    if (formKeyCreateExpense.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await mainApiController.addExpense(
            name: nameFieldController.text,
            totalPrice: double.parse(amountFieldController.text),
            paid: double.parse(amountFieldController.text),
            date: dateFieldController.text,
            details: detailsFieldController.text,
          );
        },
        onSuccess: (response) async {
          Get.back();
          HelperDesignFunctions.showSuccessSnackBar(
              message: "Expense '${nameFieldController.text}' created");
          onNavBarChange(selectedBottomNavigationBarItem);
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
    return false;
  }
  void showSheetCreateCacheMoney(BuildContext context, {required bool isPush, Future Function()? onSuccess}) {
    clearFields();
    HelperDesignFunctions.showMainBottomSheet(context,
        title: "${isPush ? 'Push' : 'Pull'} Cache Money",
        height: 0.8 * Get.height, btnOkOnPress: () async {
      bool result = await _createCacheMoney(isPush);
      if (result && onSuccess != null) {
        await onSuccess.call();
      }
    }, btnCancelOnPress: () {
      Get.back();
    },
        content: Form(
          key: formKeyCreateMoneyOperation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 13,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Money amount',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: amountFieldController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (isPush) {
                      return Validate.valid(text!, type: Validate.positiveNum);
                    }
                    String? message =
                        Validate.valid(text!, type: Validate.positiveNum);
                    if (message == null && double.parse(text) > totalMoneyBox) {
                      return 'Money not enough to Pull you have $totalMoneyBox \$';
                    }
                    return message;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: '${isPush ? 'Push' : 'Pull'} date',
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  controller: dateFieldController,
                  readOnly: true,
                  onTap: () async {
                    dateFieldController.text =
                        await HelperDesignFunctions.choseDate(context) ??
                            dateFieldController.text;
                  },
                ),
              ),
            ],
          ),
        ));
    update();
  }
  Future<bool> _createCacheMoney(bool isPush) async {
    if (formKeyCreateMoneyOperation.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await mainApiController.addOrRemoveCash(
            totalPrice:
                (isPush ? 1 : -1) * double.parse(amountFieldController.text),
            date: dateFieldController.text.toString(),
          );
        },
        onSuccess: (response) async {
          Get.back();
          HelperDesignFunctions.showSuccessSnackBar(
              message:
                  "Done ${isPush ? 'Push' : 'Pull'} Money ${amountFieldController.text} \$");
          onNavBarChange(selectedBottomNavigationBarItem);
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
    return false;
  }
  void showDialogMeetDebt(BuildContext context, double debts, Future<bool> Function() meetDebt) {
    amountFieldController.clear();
    remainder = debts;
    HelperDesignFunctions.showAwesomeDialog(context, btnOkOnPress: () async {
      await meetDebt.call();
    },
        btnCancelOnPress: () {},
        body: Form(
          key: formKeyMeetDebt,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Repayment debt",
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const Divider(
                  thickness: 2,
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "All debts",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                    Text(
                      "$debts \$",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Reminder",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                    GetBuilder<MainController>(
                      builder: (controller) => Text(
                        "$remainder \$",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'payment amount',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (Validate.valid(value, type: Validate.positiveNum) ==
                          null) {
                        double amount =
                            double.parse(amountFieldController.text);
                        if (debts < amount) {
                          return;
                        }
                        remainder = debts - amount;
                        update();
                      }
                    },
                    controller: amountFieldController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) {
                      return Validate.valid(text!,
                          type: Validate.positiveNum, maxVal: debts);
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
    update();
  }
  void individualStocktaking(BuildContext context, {required StocktakingType stocktakingType, bool enabledSelect = true, dynamic item}) {
    startDate = HelperDesignFunctions.formatDate(DateTime.now().subtract(const Duration(days: 30)));
    endDate = HelperDesignFunctions.formatDate(DateTime.now());
    String type = stocktakingType == StocktakingType.category
        ? 'Category'
        : stocktakingType == StocktakingType.product
            ? 'Product'
            : stocktakingType == StocktakingType.client
                ? 'Client'
                : 'Supplier';
    List items = stocktakingType == StocktakingType.category
        ? categories
        : stocktakingType == StocktakingType.product
            ? products
            : stocktakingType == StocktakingType.client
                ? clients
                : suppliers;
    if (items.isNotEmpty) {
      selectedItem = items[0];
    }
    if (!enabledSelect) {
      selectedItem = item;
    }
    HelperDesignFunctions.showAwesomeDialog(context, btnOkOnPress: () {
      Get.toNamed(AppPagesRoutes.individualStocktaking, arguments: {
        AppSharedKeys.passStocktakingType: stocktakingType,
        AppSharedKeys.passId: selectedItem.id,
        AppSharedKeys.passName: selectedItem.name,
        AppSharedKeys.passStartDate: startDate,
        AppSharedKeys.passEndDate: endDate,
      });
    },
        btnCancelOnPress: () {},
        body: GetBuilder<MainController>(
          builder: (controller) => Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "$type Stocktaking",
                  style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ' From: ',
                          style: TextStyle(color: AppColors.gray),
                        ),
                        ActionChip(
                          label: Text(controller.startDate),
                          onPressed: () async {
                            await choseDateRange(context);
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ' To: ',
                          style: TextStyle(color: AppColors.gray),
                        ),
                        ActionChip(
                          label: Text(controller.endDate),
                          onPressed: () async {
                            await choseDateRange(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownSearch<dynamic>(
                    popupProps: PopupProps.menu(
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
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Chose $type",
                      ),
                    ),
                    compareFn: (item1, item2) => true,
                    itemAsString: (item) => item.name,
                    items: items,
                    selectedItem: selectedItem,
                    enabled: enabledSelect,
                    onChanged: (value) {
                      selectedItem = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  Future<bool> getFullStocktaking() async {
    statusView = StatusView.loading;
    update();
    startDate = HelperDesignFunctions.formatDate(DateTime.now().subtract(const Duration(days: 30)));
    endDate = HelperDesignFunctions.formatDate(DateTime.now());
    await getCategoriesNames();
    await getProductsNames();
    await getClientsNames();
    await getSuppliersNames();
    return await ApiService.sendRequest(
      request: () async {
        return await mainApiController.getFullStocktaking(
            startDate: startDate, endDate: endDate);
      },
      onSuccess: (response) async {
        if (response is FullStocktaking) {
          fullStocktaking = response;
          HelperLogicFunctions.printNote(fullStocktaking.purchasesAmount);

          statusView = StatusView.none;
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
  Future<bool> getCategoriesNames() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await mainApiController.getCategoriesNames();
      },
      onSuccess: (response) async {
        if (response is List<Category>) {
          categories = response;
          if (categories.isNotEmpty) {
            selectedCategory = categories.take(1).first;
          }
          statusView = StatusView.none;
        }
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
  Future<bool> getProductsNames() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await mainApiController.getProductsNames();
      },
      onSuccess: (response) async {
        if (response is List<Product>) {
          products = response;
          if (products.isNotEmpty) {
            selectedProduct = products.take(1).first;
          }
        }
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
  Future<bool> getClientsNames() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await mainApiController.getClientsNames();
      },
      onSuccess: (response) async {
        if (response is List<Client>) {
          clients = response;
          if (clients.isNotEmpty) {
            selectedClient = clients.take(1).first;
          }
        }
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
  Future<bool> getSuppliersNames() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await mainApiController.getSuppliersNames();
      },
      onSuccess: (response) async {
        if (response is List<Supplier>) {
          suppliers = response;
          if (suppliers.isNotEmpty) {
            selectedSupplier = suppliers.take(1).first;
          }
        }
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
  Future<bool> getMonitoring() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await mainApiController.getMonitoring();
      },
      onSuccess: (response) async {
        if (response is Monitoring) {
          monitoring = response;
          invoicesHeight = monitoring.leastPurchasesInvoices.length * 0.13 * Get.height;
          statusView = StatusView.none;
          update();
        }
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
  Future<void> onNavBarChange(int index) async {
    selectedBottomNavigationBarItem = index;
    if (index == 0) {
      await getMonitoring();
    } else if (index == 1) {
      await getCategoriesNames();
    } else if (index == 2) {
      await getFullStocktaking();
    }
    update();
  }
  void onLatestInvoiceTabChange(int index) {
    latestInvoiceTabIndex=index;
    if (index == 0) {
      invoicesHeight=monitoring.leastPurchasesInvoices.isNotEmpty
          ? monitoring.leastPurchasesInvoices.length * 0.13 * Get.height
          : 250;
    } else if (index == 1) {
      invoicesHeight=monitoring.leastSalesInvoices.isNotEmpty
          ? monitoring.leastSalesInvoices.length * 0.13 * Get.height
          : 250;
    } else if (index == 2) {
      invoicesHeight=monitoring.leastExpenses.isNotEmpty
          ? monitoring.leastExpenses.length * 0.13 * Get.height
          : 250;
    }
    update();
  }
  void onPopularPeopleTabChange(int index) {
    popularPeopleTabIndex=index;
    // if (index == 0) {
    //   invoicesHeight=monitoring.leastPurchasesInvoices.isNotEmpty
    //       ? monitoring.leastPurchasesInvoices.length * 0.13 * Get.height
    //       : 250;
    // } else if (index == 1) {
    //   invoicesHeight=monitoring.leastSalesInvoices.isNotEmpty
    //       ? monitoring.leastSalesInvoices.length * 0.13 * Get.height
    //       : 250;
    // } else if (index == 2) {
    //   invoicesHeight=monitoring.leastExpenses.isNotEmpty
    //       ? monitoring.leastExpenses.length * 0.13 * Get.height
    //       : 250;
    // }
    update();
  }
  void onProductsTabChange(int index) {
    productsTabIndex=index;
    // if (index == 0) {
    //   invoicesHeight=monitoring.leastPurchasesInvoices.isNotEmpty
    //       ? monitoring.leastPurchasesInvoices.length * 0.13 * Get.height
    //       : 250;
    // } else if (index == 1) {
    //   invoicesHeight=monitoring.leastSalesInvoices.isNotEmpty
    //       ? monitoring.leastSalesInvoices.length * 0.13 * Get.height
    //       : 250;
    // } else if (index == 2) {
    //   invoicesHeight=monitoring.leastExpenses.isNotEmpty
    //       ? monitoring.leastExpenses.length * 0.13 * Get.height
    //       : 250;
    // }
    update();
  }
  void onArrowLatestInvoiceTabPressed() {
    if (latestInvoiceTabIndex == 0) {
      Get.toNamed(AppPagesRoutes.invoicesScreen, arguments: {
        AppSharedKeys.passFilter: PublicFilterType.purchasesInvoices
      });
    } else if (latestInvoiceTabIndex == 1) {
      Get.toNamed(AppPagesRoutes.invoicesScreen, arguments: {
        AppSharedKeys.passFilter: PublicFilterType.salesInvoices
      });
    } else if (latestInvoiceTabIndex == 2) {
      Get.toNamed(AppPagesRoutes.moneyBoxScreen, arguments: {
        AppSharedKeys.passFilter: PublicFilterType.expenses
      });
    }
  }
  void onArrowPopularPeopleTabPressed() {
    if (popularPeopleTabIndex == 0) {
      Get.toNamed(AppPagesRoutes.clientsScreen, arguments: {
        AppSharedKeys.passFilter: PublicFilterType.invoicesCount
      });
    } else if (popularPeopleTabIndex == 1) {
      Get.toNamed(AppPagesRoutes.suppliersScreen, arguments: {
        AppSharedKeys.passFilter: PublicFilterType.invoicesCount
      });
    }
  }
  void onArrowProductsTabPressed() {
    if (productsTabIndex == 0) {
      Get.toNamed(AppPagesRoutes.productsScreen, arguments: {
        AppSharedKeys.passFilter: PublicFilterType.profit
      });
    } else if (productsTabIndex == 1) {
      Get.toNamed(AppPagesRoutes.productsScreen, arguments: {
        AppSharedKeys.passFilter: PublicFilterType.amount
      });
    }
  }

  Future<void> choseDateRange(BuildContext context) async{
    DateTimeRange? date = await HelperDesignFunctions.choseDateRange(context);
    if(date != null){
      startDate=HelperDesignFunctions.formatDate(date.start);
      endDate=HelperDesignFunctions.formatDate(date.end);
    }
    update();
  }
  void clearFields() {
    image = null;
    nameFieldController.clear();
    salePriceFieldController.clear();
    purchasePriceFieldController.clear();
    phoneNumberFieldController.clear();
    addressFieldController.clear();
    detailsFieldController.clear();
    amountFieldController.clear();
    dateFieldController.clear();
    dateFieldController.text = HelperDesignFunctions.formatDate(DateTime.now());
  }
  bool onNotification(notification) {
    if (notification.direction == ScrollDirection.forward) {
      isVisibleNav = true;
    } else if (notification.direction == ScrollDirection.reverse) {
      isVisibleNav = false;
    }
    update();
    return true;
  }
}