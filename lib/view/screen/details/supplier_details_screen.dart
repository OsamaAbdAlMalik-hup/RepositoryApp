
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/supplier_details_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/view/widget/shared/nested_scroll_view_page.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class SupplierDetailsScreen extends GetView<SupplierDetailsController> {
  const SupplierDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupplierDetailsController>(
      builder: (controller) => NestedScrollViewPage(
        title: "${HelperLogicFunctions.upperFirstChar(controller.supplier.name)} Supplier",
        statusView: controller.statusView,
        imageUrl: controller.supplier.photo,
        tabBar: TabBar(
          controller: controller.tabController,
          tabs: [
            Tab(
                child: Text(
                  "Invoices",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: AppColors.primary70),
                )),
            Tab(
                child: Text(
                  "purchases",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: AppColors.primary70),
                )),
          ],
        ),
        tabBarView: TabBarView(
          controller: controller.tabController,
          children: [
            controller.supplier.details.purchasesInvoices.isNotEmpty
                ? ListView.builder(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: controller.supplier.details.purchasesInvoices.length,
                itemBuilder: (context, index) => Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Get.toNamed(AppPagesRoutes.invoiceDetailsScreen,
                            arguments: {
                              AppSharedKeys.passId: controller
                                  .supplier.details.purchasesInvoices[index].id,
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
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '#${controller.supplier.details.purchasesInvoices[index].number}',
                                      ),
                                      Text(
                                        controller.supplier.details
                                            .purchasesInvoices[index].date,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  )),
                              const VerticalDivider(thickness: 1),
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.supplier.name
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                            fontSize: 22,
                                            letterSpacing: 1),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextIcon(
                                            text: controller
                                                .supplier
                                                .details
                                                .purchasesInvoices[index]
                                                .totalPrice
                                                .toString(),
                                            color: AppColors.black,
                                            icon: Icons
                                                .monetization_on_rounded,
                                          ),
                                          TextIcon(
                                            text: controller
                                                .supplier
                                                .details
                                                .purchasesInvoices[index]
                                                .remained
                                                .toString(),
                                            color: AppColors.black,
                                            icon: Icons.money_off,
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )))
                : Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppAssets.noInvoices,
                    width: 0.6 * Get.width,
                  ),
                ),
                Text(
                  "No any Purchase",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary70, fontSize: 24),
                )
              ],
            ),
            controller.supplier.details.purchases.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              itemCount: controller.supplier.details.purchases.length,
              itemBuilder: (context, index) => Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller
                                  .supplier.details.purchases[index].supplierName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                  fontSize: 22, letterSpacing: 1),
                            ),
                            TextIcon(
                              text:
                              " ${controller.supplier.details.purchases[index].invoiceNumber}",
                              icon: Icons.numbers,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            TextIcon(
                              text:
                              "${controller.supplier.details.purchases[index].amount}",
                              icon: Icons.upload,
                            ),
                            TextIcon(
                              text:
                              " ${controller.supplier.details.purchases[index].totalPurchasePrice} \$",
                              icon: Icons.download,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                : Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppAssets.noOrder,
                    width: 0.6 * Get.width,
                  ),
                ),
                Text(
                  "No any Sale",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary70, fontSize: 24),
                )
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.suppliersController.mainController.individualStocktaking(context,
                  stocktakingType: StocktakingType.supplier,
                  enabledSelect: false,
                  item: controller.supplier
              );
            },
            icon: const Icon(
              Icons.featured_play_list_outlined,
            ),
          ),
          PopupMenuButton<OperationType>(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            tooltip: "Operation",
            onSelected: (value) async {
              switch (value) {
                case OperationType.update: {
                  controller.suppliersController.showSheetUpdateSupplier(context,
                    supplier: controller.supplier,
                    onSuccess: () async {
                      await controller.getSupplier();
                    },
                  );
                  break;
                }
                case OperationType.delete: {
                  controller.suppliersController.showDialogDeleteSupplier(context,
                    supplier: controller.supplier,
                    onSuccess: () async {
                      Get.back();
                    },
                  );
                  break;
                }
                case OperationType.debts:{
                  controller.suppliersController.mainController.showDialogMeetDebt(
                      context,
                      controller.supplier.debts,
                      controller.meetDebtSupplier
                  );
                  break;
                }
                case OperationType.archive:
                  {
                    controller.archiveSupplier();
                    break;
                  }
                case OperationType.registers:
                  {
                    controller.getSupplierRegisters(context: context);
                    break;
                  }
                default:
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<OperationType>(
                value: OperationType.update,
                child: Row(
                  children: const [
                    Icon(
                      Icons.edit_outlined,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem<OperationType>(
                  value: OperationType.delete,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete_outlined,
                        color: AppColors.danger50,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Delete'),
                    ],
                  )),
              PopupMenuItem<OperationType>(
                  value: OperationType.archive,
                  child: Row(
                    children: [
                      Icon(
                        controller.suppliersController.isArchived
                            ? Icons.unarchive_outlined
                            : Icons.archive_outlined,
                        color: AppColors.primary40,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text('Archive'),
                    ],
                  )),
              PopupMenuItem<OperationType>(
                value: OperationType.debts,
                child: Row(
                  children: const [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.amber,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Debt'),
                  ],
                ),
              ),
              PopupMenuItem<OperationType>(
                  value: OperationType.registers,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.gray,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Registers'),
                    ],
                  )),
            ],
          )
        ],
        childrenBottomAppbar: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Address: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary40),
                ),
                Text(
                  controller.supplier.address,
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.primary0,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phone Number: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary40),
                ),
                Text(
                  controller.supplier.phoneNumber,
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.primary0,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Bills: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary40),
                ),
                Text(
                  "${controller.supplier.invoicesCount}",
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.primary0,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Debts: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary40),
                ),
                Text(
                  "${controller.supplier.debts}",
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.primary0,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Paid: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary40),
                ),
                Text(
                  "${controller.supplier.invoicesTotal}",
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.primary0,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
        isShowDetails: controller.isShowDetails,
        onTapImage: () {
          controller.isShowDetails=!controller.isShowDetails;
          controller.update();
        },
      ),
    );
  }
}

