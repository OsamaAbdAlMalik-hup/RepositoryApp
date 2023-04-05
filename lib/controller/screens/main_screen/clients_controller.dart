
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repository/controller/api/clients_api_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/core/helper/validator_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/client.dart';
import 'package:repository/view/screen/main_screen/products_screen.dart';

class ClientsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  MainController mainController = Get.find();
  ClientsApiController clientsApiController = ClientsApiController(Get.find());
  GlobalKey<FormState> formKeyUpdate = GlobalKey<FormState>();
  late TabController filterTabController;
  List<SortItem> sortItems = [
    SortItem(label: "name", icon: Icons.text_fields, isSelected: true),
    SortItem(label: "address", icon: Icons.add_location, isSelected: false),
    SortItem(label: "phone", icon: Icons.phone, isSelected: false),
    SortItem(label: "debts", icon: Icons.account_balance_wallet, isSelected: false),
    SortItem(label: "invoices count", icon: Icons.animation, isSelected: false),
    SortItem(label: "invoices total", icon: Icons.multiline_chart, isSelected: false),
  ];
  List<String> searchItem = [
    'name',
    'address',
    'phone',
    'debts',
    'invoices count',
    'invoices total'
  ];
  List<Client> clients = [], allClients = [];
  StatusView statusView = StatusView.loading;

  PublicFilterType filterType = PublicFilterType.date;
  ViewModeType viewModeType=ViewModeType.defaultMode;
  bool ascending = true, isSearchMode = false, isArchived = false;

  @override
  onInit() async {
    filterTabController = TabController(length: sortItems.length, vsync: this);
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
    if (filterType == PublicFilterType.invoicesCount) {
      sortItems[4].isSelected = true;
    }
    await getClients();
    super.onInit();
  }

  Future<bool> getClients() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return isArchived
            ? await clientsApiController.getArchivesClients(repositoryId: RegistrationController.currentRepository.id)
            : await clientsApiController.getClients(repositoryId: RegistrationController.currentRepository.id);
      },
      onSuccess: (response) async {
        if (response is List<Client>) {
          allClients = response;
          sort(allClients);
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

  Future<void> createClient(BuildContext context) async {
    mainController.showSheetCreateClientOrSupplier(
      context,
      isClient: true,
      onSuccess: () async {
        await getClients();
      },
    );
  }

  Future<void> showSheetUpdateClient(BuildContext context,
      {required Client client, Future Function()? onSuccess}) async {
    mainController.nameFieldController.text = client.name;
    mainController.phoneNumberFieldController.text = client.phoneNumber;
    mainController.addressFieldController.text = client.address;
    HelperDesignFunctions.showFormDialog(context,
        formKey: formKeyUpdate,
        btnOkOnPress: () async {
          bool result = await _updateClient(client);
          if (result && onSuccess != null) {
            await onSuccess.call();
          }
        },
        title: "Update Client",
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GetBuilder<ClientsController>(
                  builder: (controller) => CircleAvatar(
                    radius: 105,
                    backgroundColor: AppColors.primary50,
                    child: controller.mainController.image != null
                        ? CircleAvatar(
                      radius: 100,
                      backgroundColor: AppColors.primary0,
                      backgroundImage: FileImage(controller.mainController.image!),
                    )
                        : client.photo != ''
                        ? CircleAvatar(
                      radius: 100,
                      backgroundColor: AppColors.primary0,
                      backgroundImage:
                      CachedNetworkImageProvider(client.photo),
                    )
                        : CircleAvatar(
                      radius: 100,
                      backgroundColor: AppColors.primary0,
                      child: SvgPicture.asset(
                        AppAssets.clientsIconSvg,
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
                      await HelperLogicFunctions.pickImage(
                          ImageSource.gallery);
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
        ]
    );
  }

  Future<bool> _updateClient(Client client) async {
    if (formKeyUpdate.currentState!.validate()) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return await clientsApiController.updateClient(
              name: mainController.nameFieldController.text,
              photo: mainController.image,
              phoneNumber: mainController.phoneNumberFieldController.text,
              address: mainController.addressFieldController.text,
              id: client.id);
        },
        onSuccess: (response) async {
          Get.back();
          HelperDesignFunctions.showSuccessSnackBar(
              message:
                  "Client '${mainController.nameFieldController.text}' updated");
          await getClients();
          await mainController.onNavBarChange(
              mainController.selectedBottomNavigationBarItem);
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

  Future<void> showDialogDeleteClient(BuildContext context,
      {required Client client, Future Function()? onSuccess}) async {
    HelperDesignFunctions.showAlertDialog(context,
        btnOkOnPress: () async {
          bool result = await _deleteClient(client);
          if (result && onSuccess != null) {
            await onSuccess.call();
            HelperDesignFunctions.showSuccessSnackBar(
                message: "Client '${client.name}' deleted");
          }
        },
        title: "Delete Client",
        subTitle: "Are you sure from delete ${client.name} !",
        okText: "Delete",
        dialogType: "delete",
    );
  }

  Future<bool> _deleteClient(Client client) async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await clientsApiController.deleteClient(id: client.id);
      },
      onSuccess: (response) async {
        await getClients();
        await mainController.onNavBarChange(
            mainController.selectedBottomNavigationBarItem);
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
      if (mainController.filterTabIndex==0) {
        clients = allClients
            .where((element) =>
                element.name.toLowerCase().contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==1) {
        clients = allClients
            .where((element) =>
                element.address.toLowerCase().contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==2) {
        clients = allClients
            .where((element) => element.phoneNumber.contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==3) {
        clients = allClients
            .where((element) =>
                element.debts.toString().contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==4) {
        clients = allClients
            .where((element) =>
                element.invoicesCount.toString().contains(val.toLowerCase()))
            .toList();
      } else if (mainController.filterTabIndex==5) {
        clients = allClients
            .where((element) =>
                element.invoicesTotal.toString().contains(val.toLowerCase()))
            .toList();
      }
    } else {
      clients = allClients;
    }
    update();
  }

  Future<void> sort(List<Client> allClients) async {
    if (sortItems[0].isSelected) {
      clients = allClients
        ..sort(
          (a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
    } else if (sortItems[1].isSelected) {
      clients = allClients
        ..sort(
          (a, b) => ascending
              ? a.address.compareTo(b.address)
              : b.address.compareTo(a.address),
        );
    } else if (sortItems[2].isSelected) {
      clients = allClients
        ..sort(
          (a, b) => ascending
              ? a.phoneNumber.compareTo(b.phoneNumber)
              : b.phoneNumber.compareTo(a.phoneNumber),
        );
    } else if (sortItems[3].isSelected) {
      clients = allClients
        ..sort((a, b) {
          return ascending
              ? (a.debts - b.debts).ceil()
              : (b.debts - a.debts).ceil();
        });
    } else if (sortItems[4].isSelected) {
      clients = allClients
        ..sort((a, b) {
          return ascending
              ? (a.invoicesCount - b.invoicesCount).ceil()
              : (b.invoicesCount - a.invoicesCount).ceil();
        });
    } else if (sortItems[5].isSelected) {
      clients = allClients
        ..sort((a, b) {
          return ascending
              ? (a.invoicesTotal - b.invoicesTotal).ceil()
              : (b.invoicesTotal - a.invoicesTotal).ceil();
        });
    } else {
      clients = allClients;
    }
    update();
  }

}
