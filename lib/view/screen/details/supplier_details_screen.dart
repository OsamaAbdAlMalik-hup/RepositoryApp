import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/supplier_details_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/title_section.dart';

class SupplierDetailsScreen extends GetView<SupplierDetailsController> {
  const SupplierDetailsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupplierDetailsController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(
            "${controller.supplier.name} supplier",
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
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary50,
                            child: CircleAvatar(
                                radius: 45,
                                backgroundColor: AppColors.white,
                                backgroundImage:
                                    FileImage(File(controller.supplier.photo))))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.supplier.name,
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
                                  color: AppColors.primary50,
                                  size: 18,
                                ),
                                Text(
                                  controller.supplier.phoneNumber,
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
                                  color: AppColors.primary50,
                                  size: 18,
                                ),
                                Text(
                                  controller.supplier.address,
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
              const SizedBox(
                height: 10,
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
                              controller.supplier.details.purchases.length
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )),
                            const Text(
                              "All purchases",
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
                              '${controller.supplier.debts} \$',
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
                              controller
                                  .supplier.details.purchasesInvoices.length
                                  .toString(),
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
                title: "Purchases Bills",
                onPressed: () {
                  Get.toNamed(AppPagesRoutes.invoicesScreen,
                      arguments: {AppSharedKeys.passFilter: "supplier"});
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
                        color: AppColors.primary30),
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
                            color: AppColors.black90,
                            borderRadius: BorderRadius.vertical(
                              top: const Radius.circular(15),
                              bottom: controller
                                      .supplier.details.purchasesInvoices.isEmpty
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
                                    color: AppColors.primary30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Date",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Debts",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                      ...List.generate(
                          controller.supplier.details.purchasesInvoices.length,
                          (index) => TableRow(
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary0,
                                  ),
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            AppPagesRoutes.invoiceDetailsScreen,
                                            arguments: {
                                              AppSharedKeys.passId: controller
                                                  .supplier
                                                  .details
                                                  .purchasesInvoices[index]
                                                  .id,
                                              AppSharedKeys.passInvoiceType:
                                                  InvoiceType.purchases
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          elevation: 0,
                                          fixedSize: const Size(60, 15)),
                                      child: Text(controller.supplier.details
                                          .purchasesInvoices[index].number
                                          .toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller.supplier.details
                                          .purchasesInvoices[index].date),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller.supplier.details
                                          .purchasesInvoices[index].remained
                                          .toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller.supplier.details
                                          .purchasesInvoices[index].totalPrice
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
                title: "Purchases",
                onPressed: () {
                  // Get.toNamed(AppPagesRoutes.productsScreen,arguments: {AppSharedKeys.passFilter:"supplier"});
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
                        color: AppColors.primary30),
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
                            color: AppColors.black90,
                            borderRadius: BorderRadius.vertical(
                              top: const Radius.circular(15),
                              bottom:
                                  controller.supplier.details.purchases.isEmpty
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
                                    color: AppColors.primary30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Count",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "purchase Price",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                      ...List.generate(
                          controller.supplier.details.purchases.length,
                          (index) => TableRow(
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary0,
                                  ),
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed(
                                            AppPagesRoutes.productDetailsScreen,
                                            arguments: {
                                              AppSharedKeys.passId: controller.supplier.details.purchases[index].productId
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          elevation: 0,
                                          fixedSize: const Size(60, 15)),
                                      child: Text(controller
                                          .supplier
                                          .details
                                          .purchases[index]
                                          .productName),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller.supplier.details
                                          .purchases[index].amount
                                          .toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text((controller
                                          .supplier
                                          .details
                                          .purchases[index]
                                          .totalPurchasePrice / controller
                                          .supplier
                                          .details
                                          .purchases[index]
                                          .amount)
                                          .toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text((controller
                                          .supplier
                                          .details
                                          .purchases[index]
                                          .totalPurchasePrice / controller
                                          .supplier
                                          .details
                                          .purchases[index]
                                          .amount)
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

