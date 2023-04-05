
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repository/controller/api/suppliers_api_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/helper/validator_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/supplier.dart';
import 'package:repository/view/screen/main_screen/products_screen.dart';

class SuppliersController extends GetxController with GetSingleTickerProviderStateMixin {
  MainController mainController = Get.find();
  SuppliersApiController suppliersApiController = SuppliersApiController(Get.find());
  GlobalKey<FormState> formKeyUpdate = GlobalKey<FormState>();
  late TabController tabController;

  List<Supplier> suppliers = [], allSuppliers = [];
  StatusView statusView = StatusView.loading;

  ViewModeType viewModeType = ViewModeType.defaultMode;
  PublicFilterType filterType = PublicFilterType.date;
  bool ascending = true, isSearchMode = false, isArchived = false;
  List<SortItem> sortItems = [
    SortItem(label: "name", icon: Icons.text_fields, isSelected: true),
    SortItem(label: "address", icon: Icons.add_location, isSelected: false),
    SortItem(label: "phone", icon: Icons.phone, isSelected: false),
    SortItem(
        label: "debt", icon: Icons.account_balance_wallet, isSelected: false),
    SortItem(label: "invoices count", icon: Icons.animation, isSelected: false),
    SortItem(
        label: "invoices total",
        icon: Icons.multiline_chart,
        isSelected: false),
  ];

  List<String> searchItem = [
    'name',
    'address',
    'phone',
    'debts',
    'invoices count',
    'invoices total'
  ];

  @override
  onInit() async {
    tabController = TabController(length: sortItems.length, vsync: this);
    viewModeType = HelperLogicFunctions.getVale(
        map: Get.arguments,
        key: AppSharedKeys.passViewMode,
        defaultVal: ViewModeType.defaultMode);
    filterType = HelperLogicFunctions.getVale(
        map: Get.arguments,
        key: AppSharedKeys.passFilter,
        defaultVal: PublicFilterType.date);
    isArchived = viewModeType == ViewModeType.archiveMode;
    if (filterType == PublicFilterType.invoicesCount) {
      sortItems[4].isSelected = true;
    }
    await getSuppliers();
    super.onInit();
  }

  Future<bool> getSuppliers() async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return isArchived
            ? await suppliersApiController.getArchiveSuppliers()
            : await suppliersApiController.getSuppliers();
      },
      onSuccess: (response) async {
        if (response is List<Supplier>) {
          allSuppliers = response;
          sort(allSuppliers);
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

  Future<void> createSupplier(BuildContext context) async {
    mainController.showSheetCreateClientOrSupplier(
      context,
      isClient: false,
      onSuccess: () async {
        await getSuppliers();
      },
    );
  }

  Future<void> showSheetUpdateSupplier(BuildContext context,
      {required Supplier supplier, Future Function()? onSuccess}) async {
    mainController.nameFieldController.text = supplier.name;
    mainController.phoneNumberFieldController.text = supplier.phoneNumber;
    mainController.addressFieldController.text = supplier.address;
    HelperDesignFunctions.showFormDialog(context, formKey: formKeyUpdate,
        btnOkOnPress: () async {
      bool result = await _updateSupplier(supplier);
      if (result && onSuccess != null) {
        await onSuccess.call();
      }
    }, title: "Update Supplier", children: [
      Align(
        alignment: Alignment.topCenter,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GetBuilder<SuppliersController>(
              builder: (controller) => CircleAvatar(
                radius: 105,
                backgroundColor: AppColors.primary50,
                child: controller.mainController.image != null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundColor: AppColors.primary0,
                        backgroundImage:
                            FileImage(controller.mainController.image!),
                      )
                    : supplier.photo != ''
                        ? CircleAvatar(
                            radius: 100,
                            backgroundColor: AppColors.primary0,
                            backgroundImage:
                                CachedNetworkImageProvider(supplier.photo),
                          )
                        : CircleAvatar(
                            radius: 100,
                            backgroundColor: AppColors.primary0,
                            child: SvgPicture.asset(
                              AppAssets.suppliersIconSvg,
                              color: AppColors.primary60,
                            ),
                          ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () async {
                  mainController.image =
                      await HelperLogicFunctions.pickImage(ImageSource.gallery);
                  update();
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary30,
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
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          autofocus: true,
          controller: mainController.nameFieldController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (text) {
            return Validate.valid(text!);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          decoration: const InputDecoration(
              labelText: 'Phone number',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          keyboardType: TextInputType.phone,
          controller: mainController.phoneNumberFieldController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (text) {
            return Validate.valid(text!, type: Validate.phone);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          keyboardType: TextInputType.text,
          controller: mainController.addressFieldController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (text) {
            return Validate.valid(text!);
          },
        ),
      ),
    ]);
  }

  Future<bool> _updateSupplier(Supplier supplier) async {
    if (formKeyUpdate.currentState!.validate()) {
      statusView = StatusView.loading;
      update();
      return await ApiService.sendRequest(
        request: () async {
          return await suppliersApiController.updateSupplier(
              name: mainController.nameFieldController.text,
              photo: mainController.image,
              phoneNumber: mainController.phoneNumberFieldController.text,
              address: mainController.addressFieldController.text,
              id: supplier.id);
        },
        onSuccess: (response) async {
          Get.back();
          HelperDesignFunctions.showSuccessSnackBar(
              message: "Supplier '${supplier.name}' updated");
          await getSuppliers();
          await mainController
              .onNavBarChange(mainController.selectedBottomNavigationBarItem);
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

  Future<void> showDialogDeleteSupplier(BuildContext context,
      {required Supplier supplier, Future Function()? onSuccess}) async {
    HelperDesignFunctions.showAlertDialog(
      context,
      btnOkOnPress: () async {
        bool result = await _deleteSupplier(supplier);
        if (result && onSuccess != null) {
          await onSuccess.call();
          HelperDesignFunctions.showSuccessSnackBar(
              message: "Supplier '${supplier.name}' deleted");
        }
      },
      title: "Delete Product",
      subTitle: "Are you sure from delete ${supplier.name}  !",
      okText: "Delete",
      dialogType: "delete",
    );
  }

  Future<bool> _deleteSupplier(Supplier supplier) async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await suppliersApiController.deleteSupplier(id: supplier.id);
      },
      onSuccess: (response) async {
        await getSuppliers();
        await mainController
            .onNavBarChange(mainController.selectedBottomNavigationBarItem);
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

  Future<void> search(String val) async {
    if (val != '') {
      if (mainController.filterTabIndex==0) {
        suppliers = allSuppliers
            .where((element) =>
                element.name.toLowerCase().contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==1) {
        suppliers = allSuppliers
            .where((element) =>
                element.address.toLowerCase().contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==2) {
        suppliers = allSuppliers
            .where((element) => element.phoneNumber.contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==3) {
        suppliers = allSuppliers
            .where((element) =>
                element.debts.toString().contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==4) {
        suppliers = allSuppliers
            .where((element) =>
                element.invoicesCount.toString().contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==5) {
        suppliers = allSuppliers
            .where((element) =>
                element.invoicesTotal.toString().contains(val.toLowerCase()))
            .toList();
      }
    } else {
      suppliers = allSuppliers;
    }
    update();
  }

  Future<void> sort(List<Supplier> allSuppliers) async {
    if (sortItems[0].isSelected) {
      suppliers = allSuppliers
        ..sort(
          (a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
    } else if (sortItems[1].isSelected) {
      suppliers = allSuppliers
        ..sort(
          (a, b) => ascending
              ? a.address.compareTo(b.address)
              : b.address.compareTo(a.address),
        );
    } else if (sortItems[2].isSelected) {
      suppliers = allSuppliers
        ..sort(
          (a, b) => ascending
              ? a.phoneNumber.compareTo(b.phoneNumber)
              : b.phoneNumber.compareTo(a.phoneNumber),
        );
    } else if (sortItems[3].isSelected) {
      suppliers = allSuppliers
        ..sort((a, b) {
          return ascending
              ? (a.debts - b.debts).ceil()
              : (b.debts - a.debts).ceil();
        });
    } else if (sortItems[4].isSelected) {
      suppliers = allSuppliers
        ..sort((a, b) {
          return ascending
              ? (a.invoicesCount - b.invoicesCount).ceil()
              : (b.invoicesCount - a.invoicesCount).ceil();
        });
    } else if (sortItems[5].isSelected) {
      suppliers = allSuppliers
        ..sort((a, b) {
          return ascending
              ? (a.invoicesTotal - b.invoicesTotal).ceil()
              : (b.invoicesTotal - a.invoicesTotal).ceil();
        });
    } else {
      suppliers = allSuppliers;
    }
    update();
  }

  Future<void> onFilterTab(int index) async {
    for (int i = 0; i < sortItems.length; i++) {
      sortItems[i].isSelected = (i == index);
    }
    search(mainController.searchFieldController.text);
    update();
  }
}
