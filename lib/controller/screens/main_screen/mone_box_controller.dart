
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:repository/controller/api/money_box_management_api_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/validator_functions.dart';
import 'package:repository/core/service/api_service.dart';
import 'package:repository/data/models/expense.dart';
import 'package:repository/data/models/money_box_operation.dart';
import 'package:repository/data/models/register.dart';
import 'package:repository/view/screen/main_screen/products_screen.dart';

class MoneyBoxController extends GetxController with GetTickerProviderStateMixin {
  MainController mainController = Get.find();
  MoneyBoxManagementApiController moneyBoxManagementApiController = MoneyBoxManagementApiController(Get.find());
  GlobalKey<FormState> formKeyUpdateExpense = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyUpdateMoneyOperation = GlobalKey<FormState>();
  late TabController filterCacheTabController,filterExpenseTabController, mainTabController;
  int mainTabIndex = 0, filterCacheTabIndex = 0, filterExpensesTabIndex = 0;
  List<Register> registers=[];

  List<MoneyBoxOperation> pushCacheOperations = [], pullCacheOperations = [];
  List<MoneyBoxOperation> allPullCacheOperations = [], allPushCacheOperations = [];
  List<Expense> expenses = [], allExpenses = [];

  bool ascending = true, isSearchMode = false;
  List<SortItem> sortItemsCache = [
    SortItem(label: "total", icon: Icons.movie_filter, isSelected: true),
    SortItem(label: "date", icon: Icons.date_range, isSelected: false),
  ];
  List<SortItem> sortItemsExpense = [
    SortItem(label: "name", icon: Icons.text_fields, isSelected: true),
    SortItem(label: "details", icon: Icons.account_balance_wallet, isSelected: false),
    SortItem(label: "total", icon: Icons.movie_filter, isSelected: false),
    SortItem(label: "date", icon: Icons.date_range, isSelected: false),
  ];
  List<String> searchItemsCache=['total','date'];
  List<String> searchItemsExpense=['name','details','total','date'];


  PublicFilterType filterType = PublicFilterType.date;
  StatusView statusView = StatusView.loading;

  @override
  onInit() async {
    filterCacheTabController = TabController(length: sortItemsCache.length, vsync: this);
    filterExpenseTabController = TabController(length: sortItemsExpense.length, vsync: this);
    mainTabController = TabController(length: 3, vsync: this);
    filterType = Get.arguments[AppSharedKeys.passFilter];
    if (filterType == PublicFilterType.expenses) {
      mainTabController.animateTo(2);
      mainTabIndex=2;
      await getExpenses();
    } else {
      await getPushCacheOperations();
    }
    super.onInit();
  }

  Future<bool> getExpenses() async {
    // totalMoneyBox = await moneyBoxManagementApiController.getTotalBox();
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await moneyBoxManagementApiController.getExpenses();
      },
      onSuccess: (response) async {
        if (response is List<Expense>) {
          allExpenses = response;
          sort(allExpenses);
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

  Future<void> createExpense(BuildContext context) async {
    mainController.showSheetCreateExpense(
      context,
      onSuccess: () async {
        await getExpenses();
      },
    );
  }

  void showSheetUpdateExpense(BuildContext context, {required Expense expense, Future Function()? onSuccess}) {
    mainController.nameFieldController.text = expense.name;
    mainController.totalPriceFieldController.text = expense.totalPrice.toString();
    mainController.paidFieldController.text = expense.paid.toString();
    mainController.detailsFieldController.text = expense.details;
    mainController.dateFieldController.text = expense.date;
    HelperDesignFunctions.showFormDialog(context,
        formKey: formKeyUpdateExpense,
        btnOkOnPress: () async {
          bool result = await _updateExpense(expense);
          if (result && onSuccess != null) {
            await onSuccess.call();
            HelperDesignFunctions.showSuccessSnackBar(
                message: "Expense '${mainController.nameFieldController.text}' updated");
          }
        },
        title: "Update Expense",
        children: [
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
                  labelText: 'Details',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              keyboardType: TextInputType.text,
              controller: mainController.detailsFieldController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                return Validate.valid(text!);
              },
            ),
          ),
          Row(children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(10).copyWith(left: 0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Total',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                keyboardType: TextInputType.number,
                controller: mainController.totalPriceFieldController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (text) {
                  String? message =
                  Validate.valid(text!, type: Validate.positiveNum);
                  if (message == null && double.parse(text) > mainController.totalMoneyBox) {
                    return 'Money not enough to Expense you have ${mainController.totalMoneyBox} \$';
                  }
                  return message;
                },
              ),
            ),),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(10).copyWith(right: 0),
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Paid',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                keyboardType: TextInputType.number,
                controller: mainController.paidFieldController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (text) {
                  String? message =
                  Validate.valid(text!, type: Validate.positiveNum);
                  if (message == null && double.parse(text) > mainController.totalMoneyBox) {
                    return 'Money not enough to Expense you have ${mainController.totalMoneyBox} \$';
                  }
                  return message;
                },
              ),
            ),),
          ],),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              readOnly: true,
              onTap: () async {
                String date =
                    await HelperDesignFunctions.choseDate(context) ??
                        mainController.dateFieldController.text;
                mainController.dateFieldController.text = date;
              },
              controller: mainController.dateFieldController,
            ),
          ),
        ]
    );
  }

  Future<bool> _updateExpense(Expense expense) async {
    if (formKeyUpdateExpense.currentState!.validate()) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return await moneyBoxManagementApiController.updateExpense(
              name: mainController.nameFieldController.text,
              totalPrice:
                  double.parse(mainController.totalPriceFieldController.text),
              paid: double.parse(mainController.totalPriceFieldController.text),
              date: mainController.dateFieldController.text,
              details: mainController.detailsFieldController.text,
              id: expense.id);
        },
        onSuccess: (response) async {
          Get.back();
          await getExpenses();
          await mainController.onNavBarChange(
              mainController.selectedBottomNavigationBarItem);
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
    return false;
  }

  void showDialogDeleteExpense(BuildContext context, {required Expense expense, Future Function()? onSuccess}) {
    HelperDesignFunctions.showAlertDialog(context,
        btnOkOnPress: () async {
          bool result = await _deleteExpense(expense);
          if (result && onSuccess != null) {
            await onSuccess.call();
            HelperDesignFunctions.showSuccessSnackBar(
                message: "Expense ${expense.name} deleted");
          }
        },
        title: "Delete Expense",
        subTitle: "Are you sure from delete ${expense.name} !",
        okText: "Delete",
        dialogType: "delete",
    );
  }

  Future<bool> _deleteExpense(Expense expense) async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await moneyBoxManagementApiController.deleteExpense(
            id: expense.id);
      },
      onSuccess: (response) async {
        await getExpenses();
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

  Future<bool> meetDebtExpense({required Expense expense,required double payment}) async {
    if (mainController.formKeyMeetDebt.currentState!.validate()) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return await moneyBoxManagementApiController.meetDebtExpense(
              id: expense.id,
              payment: payment
          );
        },
        onSuccess: (response) async {
          HelperDesignFunctions.showSuccessSnackBar(message: "supplier  done meet his debts");
          await getExpenses();
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

  Future<bool> getExpenseRegisters({required BuildContext context,required int id}) async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await moneyBoxManagementApiController.getExpenseRegisters(
            id: id
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
                              await deleteExpenseRegister(registerId: registers[index].id);
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
  Future<bool> deleteExpenseRegister({required int registerId}) async {
    statusView = StatusView.loading;
    update();
    Get.back();
    return await ApiService.sendRequest(

      request: () async {
        return await moneyBoxManagementApiController.deleteExpenseRegister(
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


  Future<bool> getTotalBox() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await moneyBoxManagementApiController.getTotalBox();
      },
      onSuccess: (response) async {
        if (response is double) {
          mainController.totalMoneyBox = response;
        }
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
  Future<bool> getPushCacheOperations() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await moneyBoxManagementApiController.getPushOrPullRegisters(isPushed: true);
      },
      onSuccess: (response) async {
        if (response is List<MoneyBoxOperation>) {
          allPushCacheOperations = response;
          sort(allPushCacheOperations);
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
  Future<bool> getPullCacheOperations() async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await moneyBoxManagementApiController.getPushOrPullRegisters(isPushed: false);
      },
      onSuccess: (response) async {
        if (response is List<MoneyBoxOperation>) {
          allPullCacheOperations = response;
          sort(allPullCacheOperations);
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
  Future<void> createCacheMoney(BuildContext context, {required bool isPush}) async {
    mainController.showSheetCreateCacheMoney(
      context,
      isPush: isPush,
      onSuccess: () async {
        await getPushCacheOperations();
      },
    );
  }

  void showSheetUpdateCacheMoney(BuildContext context, {required MoneyBoxOperation operation, Future Function()? onSuccess}) {
    mainController.totalPriceFieldController.text = operation.totalPrice.toString();
    mainController.dateFieldController.text = operation.date;
    HelperDesignFunctions.showFormDialog(context,
        formKey: formKeyUpdateMoneyOperation,
        btnOkOnPress: () async {
          bool result = await _updateCacheMoney(operation);
          if (result && onSuccess != null) {
            await onSuccess.call();
            HelperDesignFunctions.showSuccessSnackBar(
                message: "${operation.typeMoney == MoneyType.addCashMoney ? 'Pushed' : 'Pulled'} Money  ${operation.totalPrice}updated");
          }
        },
        title: "Update ${operation.typeMoney == MoneyType.addCashMoney ? 'Pushed' : 'Pulled'} Money",
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Money amount',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              autofocus: true,
              keyboardType: TextInputType.number,
              controller: mainController.totalPriceFieldController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                String? message =
                Validate.valid(text!, type: Validate.positiveNum);
                if (operation.typeMoney == MoneyType.addCashMoney &&
                    message == null &&
                    double.parse(text) > mainController.totalMoneyBox) {
                  return 'Money not enough to Pull ${mainController.totalMoneyBox} \$';
                }
                return message;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText:
                  '${operation.typeMoney == MoneyType.addCashMoney ? 'Push' : 'Pull'} date',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              keyboardType: TextInputType.number,
              controller: mainController.dateFieldController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: true,
              onTap: () async {
                // String date=await choseDate(context) ?? controller.dateFieldController.text;
                // controller.dateFieldController.text = date;
              },
              validator: (text) {
                return Validate.valid(text!);
              },
            ),
          ),
        ]
    );
  }

  Future<bool> _updateCacheMoney(MoneyBoxOperation operation) async {
    if (formKeyUpdateMoneyOperation.currentState!.validate()) {
      statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

        request: () async {
          return await moneyBoxManagementApiController.updateRegister(
            totalPrice: double.parse(mainController.totalPriceFieldController.text),
            date: mainController.dateFieldController.text,
            id: operation.id,
          );
        },
        onSuccess: (response) async {
          Get.back();
          await getPushCacheOperations();
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

  void showDialogDeleteCacheMoney(BuildContext context, {required MoneyBoxOperation operation, Future Function()? onSuccess}) {
    HelperDesignFunctions.showAlertDialog(context,
        btnOkOnPress: () async {
          bool result = await _deleteCacheMoney(operation);
          if (result && onSuccess != null) {
            await onSuccess.call();
            HelperDesignFunctions.showSuccessSnackBar(
                message: "${operation.typeMoney == MoneyType.addCashMoney ? 'Pushed' : 'Pulled'} Money ${operation.totalPrice} deleted");
          }
        },
        title: "Delete ${operation.typeMoney == MoneyType.addCashMoney ? 'Pushed' : 'Pulled'} Money",
        subTitle: "Are you sure from delete ${operation.totalPrice}  !",
        okText: "Delete",
        dialogType: "delete",
    );
  }

  Future<bool> _deleteCacheMoney(MoneyBoxOperation operation) async {
    statusView = StatusView.loading;
        update();
    return await ApiService.sendRequest(

      request: () async {
        return await moneyBoxManagementApiController.deleteRegister(
            id: operation.id);
      },
      onSuccess: (response) async {
        await getPushCacheOperations();
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
  Future<bool> getCacheRegisters({required BuildContext context,required int id}) async {
    statusView = StatusView.loading;
    update();
    return await ApiService.sendRequest(
      request: () async {
        return await moneyBoxManagementApiController.getRegisterRegisters(
            id: id
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
                              await deleteCacheRegister(registerId: registers[index].id);
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
  Future<bool> deleteCacheRegister({required int registerId}) async {
    statusView = StatusView.loading;
    update();
    Get.back();
    return await ApiService.sendRequest(

      request: () async {
        return await moneyBoxManagementApiController.deleteRegisterRegister(
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

  Future<void> search(String val) async {
    if (mainTabIndex == 0) {
      if (val != '') {
        if (filterCacheTabIndex==0) {
          pushCacheOperations = allPushCacheOperations
              .where((element) =>
                  element.totalPrice.toString().contains(val.toLowerCase()))
              .toList();
        } else if (filterCacheTabIndex==1) {
          pushCacheOperations = allPushCacheOperations
              .where((element) => element.date.contains(val.toLowerCase()))
              .toList();
        }
      } else {
        pushCacheOperations = allPushCacheOperations;
      }
    }
    else if (mainTabIndex == 1) {
      if (val != '') {
        if (filterCacheTabIndex==0) {
          pullCacheOperations = allPullCacheOperations
              .where((element) =>
                  element.totalPrice.toString().contains(val.toLowerCase()))
              .toList();
        } else if (filterCacheTabIndex==0) {
          pullCacheOperations = allPullCacheOperations
              .where((element) => element.date.contains(val.toLowerCase()))
              .toList();
        }
      } else {
        pullCacheOperations = allPullCacheOperations;
      }
    }
    else {
      if (val != '') {
        if (filterExpensesTabIndex==0) {
          expenses = allExpenses
              .where((element) => element.name.toLowerCase().contains(val.toLowerCase()))
              .toList();
        } else if (filterExpensesTabIndex==1) {
          expenses = allExpenses
              .where((element) => element.details.toLowerCase().contains(val.toLowerCase()))
              .toList();
        } else if (filterExpensesTabIndex==2) {
          expenses = allExpenses
              .where((element) =>
                  element.totalPrice.toString().contains(val.toLowerCase()))
              .toList();
        } else if (filterExpensesTabIndex==3) {
          expenses = allExpenses
              .where((element) => element.date.contains(val.toLowerCase()))
              .toList();
        }
      } else {
        expenses = allExpenses;
      }
    }
    update();
  }
  Future<void> sort(List operations) async {
    if (mainTabIndex == 0) {
      pushCacheOperations = operations as List<MoneyBoxOperation>;
      if (sortItemsCache[0].isSelected) {
        pushCacheOperations = operations
          ..sort((a, b) => ascending
              ? (a.totalPrice - b.totalPrice).ceil()
              : (b.totalPrice - a.totalPrice).ceil());
      } else if (sortItemsCache[1].isSelected) {
        pushCacheOperations = operations
          ..sort(
            (a, b) => ascending
                ? a.date.toLowerCase().compareTo(b.date.toLowerCase())
                : b.date.toLowerCase().compareTo(a.date.toLowerCase()),
          );
      }
    }
    else if (mainTabIndex == 1) {
      pullCacheOperations = operations as List<MoneyBoxOperation>;
      if (sortItemsCache[0].isSelected) {
        pullCacheOperations = operations
          ..sort((a, b) => ascending
              ? (a.totalPrice - b.totalPrice).ceil()
              : (b.totalPrice - a.totalPrice).ceil());
      } else if (sortItemsCache[1].isSelected) {
        pullCacheOperations = operations
          ..sort(
            (a, b) => ascending
                ? a.date.toLowerCase().compareTo(b.date.toLowerCase())
                : b.date.toLowerCase().compareTo(a.date.toLowerCase()),
          );
      }
    }
    else if (mainTabIndex == 2) {
      expenses = operations as List<Expense>;
      if (sortItemsExpense[0].isSelected) {
        expenses = operations
          ..sort(
            (a, b) => ascending
                ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
                : b.name.toLowerCase().compareTo(a.name.toLowerCase()),
          );
      } else if (sortItemsExpense[1].isSelected) {
        expenses = operations
          ..sort(
            (a, b) => ascending
                ? a.details.toLowerCase().compareTo(b.details.toLowerCase())
                : b.details.toLowerCase().compareTo(a.details.toLowerCase()),
          );
      } else if (sortItemsExpense[2].isSelected) {
        expenses = operations
          ..sort((a, b) => ascending
              ? (a.totalPrice - b.totalPrice).ceil()
              : (b.totalPrice - a.totalPrice).ceil());
      } else if (sortItemsExpense[3].isSelected) {
        expenses = operations
          ..sort(
            (a, b) => ascending
                ? a.date.toLowerCase().compareTo(b.date.toLowerCase())
                : b.date.toLowerCase().compareTo(a.date.toLowerCase()),
          );
      }
    }
    update();
  }

  Future<void> onMainTabChange(int tabIndex) async {
    mainTabIndex = tabIndex;
    if (tabIndex == 0) {
      await getPushCacheOperations();
    } else if (tabIndex == 1) {
      await getPullCacheOperations();
    } else if (tabIndex == 2) {
      await getExpenses();
    }
    update();
  }
}
