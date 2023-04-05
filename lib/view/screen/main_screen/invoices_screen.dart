
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/invoices_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/view/widget/shared/empty.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/search_appbar.dart';
import 'package:repository/view/widget/shared/sort_dialog.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class InvoicesScreen extends GetView<InvoicesController> {
  const InvoicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoicesController>(
      builder: (controller) => Scaffold(
      appBar: AppBar(
        title: !controller.isSearchMode
            ? const Text(
                'Invoices',
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
                      List invoices = controller.mainTabIndex==0
                          ? controller.purchasesInvoices
                          : controller.saleInvoices;
                      await controller.sort(invoices);
                    },
                    title: "Sort Invoices",
                    children: [
                      SortDialog<InvoicesController>(
                        ascending: controller.ascending,
                        onChange: (sortItems,isAscending) {
                          controller.ascending = isAscending;
                          controller.sortItems = sortItems;
                          controller.update();
                        },
                        sortItems: controller.sortItems,
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
              onBackIconPressed:  () async {
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
                controller: controller.filterTabController,
                children: List.generate(
                  controller.sortItems.length,
                  (index) => Text(index.toString()),
                ),
              )),
          Visibility(
              visible: false,
              child: TabBarView(
                controller: controller.filterTabController,
                children: List.generate(
                  2,
                  (index) => Text(index.toString()),
                ),
              )),
        ],
        bottom: controller.isSearchMode
            ? TabBar(
                isScrollable: true,
                onTap: (index) {
                  controller.mainController.onTapFilter(index,controller.search);
                },
                controller: controller.filterTabController,
                tabs: List.generate(
                    controller.sortItems.length,
                    (index) => Tab(
                          child: Text(
                            controller.sortItems[index].label,
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
                      'Purchases',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: AppColors.primary60),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Sales',
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
              title: 'Invoice Type',
              hasButtonsAction: false,
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.toNamed(
                              AppPagesRoutes.operationOnInvoiceScreen,
                              arguments: {
                                AppSharedKeys.passInvoiceType:
                                InvoiceType.purchases,
                                AppSharedKeys.passOperationType:
                                OperationType.create,
                              });
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.login,
                              color: AppColors.primary50,
                            ),
                            Text(
                              "Purchase",
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
                        onTap: () {
                          Get.back();
                          Get.toNamed(
                              AppPagesRoutes.operationOnInvoiceScreen,
                              arguments: {
                                AppSharedKeys.passInvoiceType:
                                InvoiceType.sales,
                                AppSharedKeys.passOperationType:
                                OperationType.create,
                              });
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.logout,
                              color: AppColors.primary50,
                            ),
                            Text(
                              "     Sale    ",
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
                ),
              ],
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller.mainTabController,
                        children: [
                          controller.purchasesInvoices.isNotEmpty
                              ? SlidableAutoCloseBehavior(
                                  closeWhenOpened: true,
                                  child: ListView.builder(
                                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          controller.purchasesInvoices.length,
                                      itemBuilder: (context, index) => Slidable(
                                            endActionPane: ActionPane(
                                              extentRatio: 0.25,
                                              motion: const StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (c) async {
                                                    controller.archiveInvoice(
                                                        invoice: controller
                                                                .purchasesInvoices[
                                                            index],
                                                        invoiceType:
                                                            InvoiceType.purchases);
                                                  },
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  backgroundColor:
                                                      AppColors.grayAccent,
                                                  icon: controller.isArchived
                                                      ? Icons.unarchive
                                                      : Icons.archive,
                                                ),
                                              ],
                                            ),
                                            startActionPane: ActionPane(
                                              extentRatio: 0.25,
                                              motion: const StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (c) async {
                                                    controller.showDialogDeleteInvoice(
                                                        context,
                                                        invoice: controller
                                                                .purchasesInvoices[
                                                            index],
                                                        invoiceType:
                                                            InvoiceType.purchases);
                                                  },
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  backgroundColor: AppColors.danger50,
                                                  icon: Icons.delete_outlined,
                                                ),
                                              ],
                                            ),
                                            child: Card(
                                                child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () {
                                                Get.toNamed(
                                                    AppPagesRoutes
                                                        .invoiceDetailsScreen,
                                                    arguments: {
                                                      AppSharedKeys.passId:
                                                          controller
                                                              .purchasesInvoices[
                                                                  index]
                                                              .id,
                                                      AppSharedKeys.passInvoiceType:
                                                          InvoiceType.purchases
                                                    });
                                              },
                                              child: IntrinsicHeight(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '#${controller.purchasesInvoices[index].number}',
                                                              ),
                                                              Text(
                                                                controller
                                                                    .purchasesInvoices[
                                                                        index]
                                                                    .date,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                            ],
                                                          )),
                                                      const VerticalDivider(
                                                          thickness: 1),
                                                      Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                controller
                                                                    .purchasesInvoices[
                                                                        index]
                                                                    .supplierName
                                                                    .toString(),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            22,
                                                                        letterSpacing:
                                                                            1),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  TextIcon(
                                                                    text: controller
                                                                        .purchasesInvoices[
                                                                            index]
                                                                        .totalPrice
                                                                        .toString(),
                                                                    color: AppColors
                                                                        .black,
                                                                    icon: Icons
                                                                        .monetization_on_rounded,
                                                                  ),
                                                                  TextIcon(
                                                                    text: controller
                                                                        .purchasesInvoices[
                                                                            index]
                                                                        .remained
                                                                        .toString(),
                                                                    color: AppColors
                                                                        .black,
                                                                    icon: Icons
                                                                        .money_off,
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                          )),
                                )
                              : Empty(
                                  imagePath: AppAssets.noInvoices,
                                  text: "No any Purchase Invoice",
                                  height: 200,
                                  fontSize: 24,
                                ),
                          controller.saleInvoices.isNotEmpty
                              ? SlidableAutoCloseBehavior(
                                  closeWhenOpened: true,
                                  child: ListView.builder(
                                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: controller.saleInvoices.length,
                                      itemBuilder: (context, index) => Slidable(
                                            endActionPane: ActionPane(
                                              extentRatio: 0.25,
                                              motion: const StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (c) async {
                                                    controller.archiveInvoice(
                                                        invoice: controller
                                                            .saleInvoices[index],
                                                        invoiceType:
                                                            InvoiceType.sales);
                                                  },
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  backgroundColor:
                                                      AppColors.grayAccent,
                                                  icon: controller.isArchived
                                                      ? Icons.unarchive
                                                      : Icons.archive,
                                                ),
                                              ],
                                            ),
                                            startActionPane: ActionPane(
                                              extentRatio: 0.25,
                                              motion: const StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (c) async {
                                                    controller
                                                        .showDialogDeleteInvoice(
                                                            context,
                                                            invoice: controller
                                                                    .saleInvoices[
                                                                index],
                                                            invoiceType:
                                                                InvoiceType.sales);
                                                  },
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  backgroundColor:
                                                      AppColors.danger50,
                                                  icon: Icons.delete_outlined,
                                                ),
                                              ],
                                            ),
                                            child: Card(
                                                child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              onTap: () {
                                                Get.toNamed(
                                                    AppPagesRoutes
                                                        .invoiceDetailsScreen,
                                                    arguments: {
                                                      AppSharedKeys.passId:
                                                          controller
                                                              .saleInvoices[index]
                                                              .id,
                                                      AppSharedKeys.passInvoiceType:
                                                          InvoiceType.sales
                                                    });
                                              },
                                              child: IntrinsicHeight(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '#${controller.saleInvoices[index].number}',
                                                              ),
                                                              Text(
                                                                controller
                                                                    .saleInvoices[
                                                                        index]
                                                                    .date,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                            ],
                                                          )),
                                                      const VerticalDivider(
                                                          thickness: 1),
                                                      Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                controller
                                                                    .saleInvoices[
                                                                        index]
                                                                    .clientName,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            22,
                                                                        letterSpacing:
                                                                            1),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  TextIcon(
                                                                    text: controller
                                                                        .saleInvoices[
                                                                            index]
                                                                        .totalPrice
                                                                        .toString(),
                                                                    color: AppColors
                                                                        .black,
                                                                    icon: Icons
                                                                        .monetization_on_rounded,
                                                                  ),
                                                                  TextIcon(
                                                                    text: controller
                                                                        .saleInvoices[
                                                                            index]
                                                                        .remained
                                                                        .toString(),
                                                                    color: AppColors
                                                                        .black,
                                                                    icon: Icons
                                                                        .money_off,
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                          )),
                                )
                              : Empty(
                                  imagePath: AppAssets.noInvoices,
                                  text: "No any Sales Invoice",
                                  height: 200,
                                  fontSize: 24,
                                ),
                        ],
                      ),
                    ),
                  ),
        ),
      )),
    );
  }
}