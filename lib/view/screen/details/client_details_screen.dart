import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/client_details_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/view/widget/shared/nested_scroll_view_page.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class ClientDetailsScreen extends GetView<ClientDetailsController> {
  const ClientDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientDetailsController>(
      builder: (controller) => NestedScrollViewPage(
        title:
            "${HelperLogicFunctions.upperFirstChar(controller.client.name)} Client",
        statusView: controller.statusView,
        expandedHeight: 0.9 * Get.height,
        imageUrl: controller.client.photo,
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
              "Sales",
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
            controller.client.details.salesInvoices.isNotEmpty
                ? ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: controller.client.details.salesInvoices.length,
                    itemBuilder: (context, index) => Card(
                            child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Get.toNamed(AppPagesRoutes.invoiceDetailsScreen,
                                arguments: {
                                  AppSharedKeys.passId: controller
                                      .client.details.salesInvoices[index].id,
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
                                            '#${controller.client.details.salesInvoices[index].number}',
                                          ),
                                          Text(
                                            controller.client.details
                                                .salesInvoices[index].date,
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
                                            controller.client.name
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
                                                    .client
                                                    .details
                                                    .salesInvoices[index]
                                                    .totalPrice
                                                    .toString(),
                                                color: AppColors.black,
                                                icon: Icons
                                                    .monetization_on_rounded,
                                              ),
                                              TextIcon(
                                                text: controller
                                                    .client
                                                    .details
                                                    .salesInvoices[index]
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
            controller.client.details.sales.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.client.details.sales.length,
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
                                        .client.details.sales[index].clientName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 22, letterSpacing: 1),
                                  ),
                                  TextIcon(
                                    text:
                                        " ${controller.client.details.sales[index].invoiceNumber}",
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
                                        "${controller.client.details.sales[index].amount}",
                                    icon: Icons.upload,
                                  ),
                                  TextIcon(
                                    text:
                                        " ${controller.client.details.sales[index].totalSalePrice} \$",
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
              controller.clientsController.mainController.individualStocktaking(
                  context,
                  stocktakingType: StocktakingType.client,
                  enabledSelect: false,
                  item: controller.client);
            },
            icon: const Icon(
              Icons.featured_play_list_outlined,
            ),
          ),
          PopupMenuButton<OperationType>(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tooltip: "Operation",
            onSelected: (value) async {
              switch (value) {
                case OperationType.update:
                  {
                    controller.clientsController.showSheetUpdateClient(
                      context,
                      client: controller.client,
                      onSuccess: () async {
                        await controller.getClient();
                      },
                    );
                    break;
                  }
                case OperationType.delete:
                  {
                    controller.clientsController.showDialogDeleteClient(
                      context,
                      client: controller.client,
                      onSuccess: () async {
                        Get.back();
                      },
                    );
                    break;
                  }
                case OperationType.debts:
                  {
                    controller.clientsController.mainController
                        .showDialogMeetDebt(context, controller.client.debts,
                            controller.meetDebtClient);
                    break;
                  }
                case OperationType.archive:
                  {
                    controller.archiveClient();
                    break;
                  }
                case OperationType.registers:
                  {
                    controller.getClientRegisters(context: context);
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
                        controller.clientsController.isArchived
                            ? Icons.unarchive_outlined
                            : Icons.archive_outlined,
                        color: AppColors.primary60,
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
                      .copyWith(color: AppColors.primary60),
                ),
                Text(
                  controller.client.address,
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.black,
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
                      .copyWith(color: AppColors.primary60),
                ),
                Text(
                  controller.client.phoneNumber,
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.black,
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
                      .copyWith(color: AppColors.primary60),
                ),
                Text(
                  "${controller.client.invoicesCount}",
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.black,
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
                      .copyWith(color: AppColors.primary60),
                ),
                Text(
                  "${controller.client.debts}",
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.black,
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
                      .copyWith(color: AppColors.primary60),
                ),
                Text(
                  "${controller.client.invoicesTotal}",
                  style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.black,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
