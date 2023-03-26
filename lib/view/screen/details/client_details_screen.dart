import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/client_details_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/title_section.dart';

class ClientDetailsScreen extends GetView<ClientDetailsController> {
  const ClientDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientDetailsController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(
            "${controller.client.name} Client",
          ),
          actions: [
            IconButton(
              onPressed: () {
                controller.clientsController.mainController
                    .individualStocktaking(context,
                        stocktakingType: StocktakingType.client,
                        enabledSelect: false,
                        item: controller.client);
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
                      controller.clientsController.mainController.showDialogMeetDebt(
                          context,
                          controller.client.debts,
                          controller.meetDebtClient
                      );
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
                          color: AppColors.red,
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
                              ?Icons.unarchive_outlined
                              :Icons.archive_outlined,
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
        ),
        body: HandleRequest(
          statusView: controller.statusView,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary30,
                            child: CircleAvatar(
                                radius: 45,
                                backgroundColor: AppColors.primary0,
                                backgroundImage:
                                    FileImage(File(controller.client.photo))))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.client.name,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                Text(
                                  controller.client.phoneNumber,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.gray,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                Text(
                                  controller.client.address,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.gray,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                                child: Text(
                              controller.client.invoicesTotal.toString(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )),
                            const Text(
                              "All Paid",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )),
                    const VerticalDivider(
                      width: 5,
                      color: AppColors.black,
                      thickness: 1,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                                child: Text(
                              '${controller.client.debts} \$',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )),
                            const Text(
                              "All Debts",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )),
                    const VerticalDivider(
                      width: 5,
                      color: AppColors.black,
                      thickness: 1,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                                child: Text(
                              controller.client.invoicesCount.toString(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )),
                            const Text(
                              "All Bills",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 2,
                height: 20,
              ),
              TitleSection(
                title: "Sales Bills",
                onPressed: () {
                  Get.toNamed(AppPagesRoutes.invoicesScreen,
                      arguments: {AppSharedKeys.passFilter: "clients"});
                },
              ),
              SizedBox(
                height: 0.01 * Get.height,
              ),
              Scrollbar(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(
                        width: 2,
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primaryAccent200),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FractionColumnWidth(0.2),
                      1: FractionColumnWidth(0.3),
                      2: FractionColumnWidth(0.2),
                      3: FractionColumnWidth(0.3),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(
                            color: AppColors.blackAccentT,
                            borderRadius: BorderRadius.vertical(
                              top: const Radius.circular(15),
                              bottom: controller
                                      .client.details.salesInvoices.isEmpty
                                  ? const Radius.circular(15)
                                  : const Radius.circular(0),
                            ),
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "#",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Date",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Debts",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                      ...List.generate(
                          controller.client.details.salesInvoices.length,
                          (index) => TableRow(
                                  decoration: const BoxDecoration(
                                    color: AppColors.whiteSecondary,
                                  ),
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            AppPagesRoutes.invoiceDetailsScreen,
                                            arguments: {
                                              AppSharedKeys.passId: controller
                                                  .client
                                                  .details
                                                  .salesInvoices[index]
                                                  .id,
                                              AppSharedKeys.passInvoiceType:
                                                  InvoiceType.sales
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          elevation: 0,
                                          fixedSize: const Size(60, 15)),
                                      child: Text(controller.client.details
                                          .salesInvoices[index].number
                                          .toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller.client.details
                                          .salesInvoices[index].date),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller.client.details
                                          .salesInvoices[index].remainder
                                          .toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller.client.details
                                          .salesInvoices[index].totalPrice
                                          .toString()),
                                    ),
                                  ]))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 0.05 * Get.height,
              ),
              TitleSection(
                title: "Sales",
                onPressed: () {
                  // Get.toNamed(AppPagesRoutes.invoicesScreen,arguments: {AppSharedKeys.passFilter:"clients"});
                },
              ),
              SizedBox(
                height: 0.01 * Get.height,
              ),
              Scrollbar(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(
                        width: 2,
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primaryAccent200),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FractionColumnWidth(0.25),
                      1: FractionColumnWidth(0.2),
                      2: FractionColumnWidth(0.25),
                      3: FractionColumnWidth(0.3),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(
                            color: AppColors.blackAccentT,
                            borderRadius: BorderRadius.vertical(
                              top: const Radius.circular(15),
                              bottom: controller.client.details.sales.isEmpty
                                  ? const Radius.circular(15)
                                  : const Radius.circular(0),
                            ),
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Name",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Count",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Sale Price",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                      ...List.generate(
                          controller.client.details.sales.length,
                          (index) => TableRow(
                                  decoration: const BoxDecoration(
                                    color: AppColors.whiteSecondary,
                                  ),
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            AppPagesRoutes.productDetailsScreen,
                                            arguments: {
                                              AppSharedKeys.passId: controller
                                                  .client
                                                  .details
                                                  .sales[index]
                                                  .productId
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          elevation: 0,
                                          fixedSize: const Size(60, 15)),
                                      child: Text(controller.client.details
                                          .sales[index].productName),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller
                                          .client.details.sales[index].amount
                                          .toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text((controller.client.details
                                                  .sales[index].totalSalePrice /
                                              controller.client.details
                                                  .sales[index].amount)
                                          .toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text((controller.client.details
                                              .sales[index].totalSalePrice)
                                          .toString()),
                                    ),
                                  ]))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 0.01 * Get.height,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
