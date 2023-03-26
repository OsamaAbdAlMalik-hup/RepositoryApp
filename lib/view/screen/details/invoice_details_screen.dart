import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/invoice_details_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/title_section.dart';

class InvoiceDetailsScreen extends GetView<InvoiceDetailsController> {
  const InvoiceDetailsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceDetailsController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(
            "${controller.isPurchase ? 'Purchases' : "Sales"} invoice",
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.account_balance_wallet_outlined,
              ),
            ),
            PopupMenuButton<OperationType>(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tooltip: "Operation",
              onSelected: (value) async {
                switch (value) {
                  case OperationType.update:{
                    Get.toNamed(
                        AppPagesRoutes.operationOnInvoiceScreen,
                        arguments: {AppSharedKeys.passInvoiceType: controller.invoiceType,
                          AppSharedKeys.passOperationType: OperationType.update,
                          AppSharedKeys.passId: controller.invoiceType==InvoiceType.sales? controller.saleInvoice.id:controller.purchasesInvoice.id,
                        });
                    break;
                  }
                  case OperationType.delete:{
                    controller.invoicesController.showDialogDeleteInvoice(context,
                      invoice: controller.invoiceType==InvoiceType.sales ? controller.saleInvoice:controller.purchasesInvoice,
                      invoiceType: controller.invoiceType,
                      onSuccess: () async {
                        Get.back();
                      },
                    );
                    break;
                  }
                  case OperationType.archive:
                  case OperationType.debts:
                  case OperationType.create:
                  case OperationType.sort:
                  case OperationType.registers:
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
                        color: AppColors.green,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem<OperationType>(
                    value: OperationType.archive,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.archive_outlined,
                          color: AppColors.primary60,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text('Archive'),
                      ],
                    )),
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
                          backgroundColor: AppColors.primary,
                          radius: 55,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.whiteSecondary,
                            child: SvgPicture.asset(
                              AppAssets.invoiceIconSvg,
                              height: 60,
                              color: AppColors.primary,
                              width: 60,
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "# ${controller.isPurchase ? controller.purchasesInvoice.number : controller.saleInvoice.number}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                Text(
                                  ' ${controller.isPurchase ? controller.purchasesInvoice.supplierName : controller.saleInvoice.clientName}',
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
                                  Icons.date_range,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                Text(
                                  ' ${controller.isPurchase ? controller.purchasesInvoice.date : controller.saleInvoice.date}',
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
                              ' ${controller.isPurchase ? controller.purchasesInvoice.totalPrice : controller.saleInvoice.totalPrice} \$',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )),
                            const Text(
                              "Total",
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
                              ' ${controller.isPurchase ? controller.purchasesInvoice.totalPrice - controller.purchasesInvoice.remained : controller.saleInvoice.totalPrice - controller.saleInvoice.remainder} \$',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )),
                            const Text(
                              "Paid",
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
                              ' ${controller.isPurchase ? controller.purchasesInvoice.remained : controller.saleInvoice.remainder} \$',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )),
                            const Text(
                              "Debt",
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
                title: controller.isPurchase ? 'Purchases' : 'Sales',
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
                              bottom: controller.isEmpty
                                  ? const Radius.circular(15)
                                  : const Radius.circular(0),
                            ),
                          ),
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Name",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Padding(
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
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                controller.isPurchase
                                    ? 'Purchase Price'
                                    : 'Sales Price',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryAccent200,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Padding(
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
                          controller.isPurchase
                              ? controller
                                  .purchasesInvoice.details.purchases.length
                              : controller.saleInvoice.details.sales.length,
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
                                              AppSharedKeys.passId:
                                                  controller.isPurchase
                                                      ? controller.purchasesInvoice.details.purchases[index].productId
                                                      : controller.saleInvoice.details.sales[index].productId,
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
                                      child: Text(
                                        controller.isPurchase
                                            ? controller.purchasesInvoice.details.purchases[index].productName
                                            : controller.saleInvoice.details.sales[index].productName,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        controller.isPurchase
                                            ? controller.purchasesInvoice.details
                                                .purchases[index].amount
                                                .toString()
                                            : controller.saleInvoice.details
                                                .sales[index].amount
                                                .toString(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        controller.isPurchase
                                            ? controller.purchasesInvoice.details.purchases[index].details.product.purchasePrice.toString()
                                            : (controller.saleInvoice.details.sales[index].totalSalePrice/controller.saleInvoice.details.sales[index].amount).toString(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        controller.isPurchase
                                            ? (controller
                                                        .purchasesInvoice
                                                        .details
                                                        .purchases[index]
                                                        .details
                                                        .product
                                                        .purchasePrice *
                                                    controller
                                                        .purchasesInvoice
                                                        .details
                                                        .purchases[index]
                                                        .amount)
                                                .toString()
                                            : (controller.saleInvoice.details.sales[index].totalSalePrice).toString(),
                                      ),
                                    ),
                                  ]))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

