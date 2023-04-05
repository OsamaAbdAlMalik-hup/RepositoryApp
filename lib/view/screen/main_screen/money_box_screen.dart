
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/mone_box_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:repository/view/widget/shared/empty.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/search_appbar.dart';
import 'package:repository/view/widget/shared/sort_dialog.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class MoneyBoxScreen extends GetView<MoneyBoxController> {
  const MoneyBoxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoneyBoxController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: !controller.isSearchMode
              ? const Text(
                  'Money Box',
                )
              : null,
          actions: [
            Visibility(
              visible: !controller.isSearchMode,
              child: IconButton(
                onPressed: () {
                  controller.isSearchMode = true;
                  controller.update();
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ),
            Visibility(
              visible: !controller.isSearchMode,
              child: IconButton(
                onPressed: () {
                  HelperDesignFunctions.showAlertDialog(context,
                      btnOkOnPress: () async {
                        List operations = controller.mainTabIndex == 0
                            ? controller.pushCacheOperations
                            : controller.mainTabIndex == 1
                            ? controller.pullCacheOperations
                            : controller.expenses;
                        await controller.sort(operations);
                      },
                      title: "Sort Operations",
                      btnCancelOnPress: () {},
                      children: [
                        SortDialog<MoneyBoxController>(
                          ascending: controller.ascending,
                          onChange: (sortItems,isAscending) {
                            controller.ascending = isAscending;
                            if(controller.mainTabIndex != 2) {
                              controller.sortItemsCache = sortItems;
                            } else {
                              controller.sortItemsExpense = sortItems;
                            }
                            controller.update();
                          },
                          sortItems: controller.mainTabIndex != 2
                              ? controller.sortItemsCache
                              : controller.sortItemsExpense,
                        )
                      ]);
                },
                icon: const Icon(
                  Icons.sort_by_alpha,
                ),
              ),
            ),
            Visibility(
              visible: controller.isSearchMode,
              child: SearchAppbar(
                hintText: "Search By any Filter",
                controller: controller.mainController.searchFieldController,
                onChanged: (value) {
                  controller.search(value);
                },
                onBackIconPressed: () async {
                  controller.isSearchMode = false;
                  controller.mainController.searchFieldController.clear();
                  await controller.search('');
                },
                onSearchIconPressed: () {},
              ),
            ),
            Visibility(
                visible: false,
                child: TabBarView(
                  controller: controller.filterCacheTabController,
                  children: List.generate(
                    controller.searchItemsCache.length,
                    (index) => Text(index.toString()),
                  ),
                )),
            Visibility(
                visible: false,
                child: TabBarView(
                  controller: controller.filterExpenseTabController,
                  children: List.generate(
                    controller.searchItemsExpense.length,
                    (index) => Text(index.toString()),
                  ),
                )),
          ],
          bottom: controller.isSearchMode && controller.mainTabIndex != 2
              ? TabBar(
                  onTap: (index) {
                    controller.filterCacheTabIndex=index;
                    controller.search(controller.mainController.searchFieldController.text);
                  },
                  controller: controller.filterCacheTabController,
                  tabs: List.generate(
                      controller.searchItemsCache.length,
                      (index) => Tab(
                            child: Text(
                              controller.searchItemsCache[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: AppColors.primary60),
                            ),
                          )),
                )
              : controller.isSearchMode && controller.mainTabIndex == 2
                  ? TabBar(
                      onTap: (index) {
                        controller.filterExpensesTabIndex=index;
                        controller.search(controller.mainController.searchFieldController.text);
                      },
                      controller: controller.filterExpenseTabController,
                      tabs: List.generate(
                          controller.searchItemsExpense.length,
                          (index) => Tab(
                                child: Text(
                                  controller.searchItemsExpense[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: AppColors.primary60),
                                ),
                              )),
                    )
                  : TabBar(
                      onTap: (value) {
                        controller.onMainTabChange(value);
                      },
                      controller: controller.mainTabController,
                      tabs: [
                        Tab(
                          child: Text(
                            'Pushed',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: AppColors.primary60),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Pulled',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: AppColors.primary60),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Expenses',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: AppColors.primary60),
                          ),
                        )
                      ],
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            HelperDesignFunctions.showAlertDialog(context,
              title: "Money Operation",
              hasButtonsAction: false,
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          Get.back();
                          await controller.createCacheMoney(context,
                              isPush: true);
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.login,
                              color: AppColors.primary50,
                            ),
                            Text(
                              "Push",
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          Get.back();
                          await controller.createExpense(context);
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.clean_hands,
                              color: AppColors.primary50,
                            ),
                            Text(
                              "expense",
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          Get.back();
                          await controller.createCacheMoney(context,
                              isPush: false);
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.logout,
                              color: AppColors.primary50,
                            ),
                            Text(
                              "Pull",
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]
            );
          },
          child: const Icon(Icons.add, color: AppColors.black),
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (controller.isSearchMode) {
              controller.isSearchMode = false;
              controller.update();
              return false;
            }
            return true;
          },
          child: InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: HandleRequest(
              statusView: controller.statusView,
              child: TabBarView(
                controller: controller.mainTabController,
                children: [
                  controller.pushCacheOperations.isNotEmpty
                      ? SlidableAutoCloseBehavior(
                          closeWhenOpened: true,
                          child: ListView.builder(
                            itemCount: controller.pushCacheOperations.length,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (c) {
                                      controller.showSheetUpdateCacheMoney(
                                          context,
                                          operation: controller
                                              .pushCacheOperations[index]);
                                    },
                                    foregroundColor: AppColors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    backgroundColor: AppColors.success50,
                                    icon: Icons.edit_outlined,
                                  ),
                                ],
                              ),
                              startActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (c) {
                                      controller.showDialogDeleteCacheMoney(
                                          context,
                                          operation: controller
                                              .pushCacheOperations[index]);
                                    },
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    backgroundColor: AppColors.danger50,
                                    icon: Icons.delete_outlined,
                                  ),
                                ],
                              ),
                              child: Card(
                                  child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  controller.getCacheRegisters(context: context, id: controller.pushCacheOperations[index].id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            SvgPicture.asset(
                                              AppAssets.moneyIconSvg,
                                              height: 28,
                                              color: AppColors.primary70,
                                            ),
                                            Positioned(
                                                left: -10,
                                                child: Icon(
                                                  controller
                                                              .pushCacheOperations[
                                                                  index]
                                                              .typeMoney ==
                                                          MoneyType.addCashMoney
                                                      ? Icons.arrow_forward
                                                      : Icons.arrow_back,
                                                  color: AppColors.primary70,
                                                  size: 20,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${controller.pushCacheOperations[index].totalPrice} \$',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontSize: 20,
                                                      letterSpacing: 1),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            TextIcon(
                                              icon: Icons.date_range,
                                              text: controller
                                                  .pushCacheOperations[index]
                                                  .date,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ),
                          ),
                        )
                      : Empty(
                          imagePath: AppAssets.noExpenses,
                          text: "No any Cache operation",
                          height: 200,
                          fontSize: 24,
                        ),
                  controller.pullCacheOperations.isNotEmpty
                      ? SlidableAutoCloseBehavior(
                          closeWhenOpened: true,
                          child: ListView.builder(
                            itemCount: controller.pullCacheOperations.length,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (c) {
                                      controller.showSheetUpdateCacheMoney(
                                          context,
                                          operation: controller
                                              .pullCacheOperations[index]);
                                    },
                                    foregroundColor: AppColors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    backgroundColor: AppColors.success50,
                                    icon: Icons.edit_outlined,
                                  ),
                                ],
                              ),
                              startActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (c) {
                                      controller.showDialogDeleteCacheMoney(
                                          context,
                                          operation: controller
                                              .pullCacheOperations[index]);
                                    },
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    backgroundColor: AppColors.danger50,
                                    icon: Icons.delete_outlined,
                                  ),
                                ],
                              ),
                              child: Card(
                                  child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  controller.getCacheRegisters(context: context, id: controller.pullCacheOperations[index].id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            SvgPicture.asset(
                                              AppAssets.moneyIconSvg,
                                              height: 28,
                                              color: AppColors.primary70,
                                            ),
                                            Positioned(
                                                left: -10,
                                                child: Icon(
                                                  controller
                                                              .pullCacheOperations[
                                                                  index]
                                                              .typeMoney ==
                                                          MoneyType.addCashMoney
                                                      ? Icons.arrow_forward
                                                      : Icons.arrow_back,
                                                  color: AppColors.primary70,
                                                  size: 20,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${controller.pullCacheOperations[index].totalPrice} \$',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontSize: 20,
                                                      letterSpacing: 1),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            TextIcon(
                                              icon: Icons.date_range,
                                              text: controller
                                                  .pullCacheOperations[index]
                                                  .date,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ),
                          ),
                        )
                      : Empty(
                          imagePath: AppAssets.noExpenses,
                          text: "No any Cache operation",
                          height: 200,
                          fontSize: 24,
                        ),
                  controller.expenses.isNotEmpty
                      ? SlidableAutoCloseBehavior(
                          closeWhenOpened: true,
                          child: ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: controller.expenses.length,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (c) {
                                      controller.showSheetUpdateExpense(context,
                                          expense: controller.expenses[index]);
                                    },
                                    foregroundColor: AppColors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    backgroundColor: AppColors.success50,
                                    icon: Icons.edit_outlined,
                                  ),
                                ],
                              ),
                              startActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (c) {
                                      controller.showDialogDeleteExpense(context,
                                          expense: controller.expenses[index]);
                                    },
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    backgroundColor: AppColors.danger50,
                                    icon: Icons.delete_outlined,
                                  ),
                                ],
                              ),
                              child: Card(
                                  child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  controller.getExpenseRegisters(context: context, id: controller.expenses[index].id);
                                },
                                onLongPress: () {
                                  controller.meetDebtExpense(expense: controller.expenses[index], payment: 0);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: Icon(
                                          size: 28,
                                          Icons.clean_hands,
                                          color: AppColors.primary70,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    controller
                                                        .expenses[index].name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                            fontSize: 22,
                                                            letterSpacing: 1),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    controller
                                                        .expenses[index].details,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${controller.expenses[index].totalPrice} \$",
                                                    style: const TextStyle(
                                                        color:
                                                            AppColors.primary70,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextIcon(
                                                    icon: Icons.date_range,
                                                    text: controller
                                                        .expenses[index].date,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              )),
                            ),
                          ),
                        )
                      : Empty(
                          imagePath: AppAssets.noExpenses,
                          text: "No any Expense",
                          height: 200,
                          fontSize: 24,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}