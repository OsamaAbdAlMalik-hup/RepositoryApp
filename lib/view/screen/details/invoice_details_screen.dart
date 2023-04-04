import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repository/controller/screens/details/invoice_details_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class InvoiceDetailsScreen extends GetView<InvoiceDetailsController> {
  const InvoiceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceDetailsController>(
      builder: (controller) => Scaffold(
        body: HandleRequest(
          statusView: controller.statusView,
          child: SafeArea(
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 0.35 * Get.height,
                  pinned: true,
                  floating: true,
                  primary: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    stretchModes: const [
                      StretchMode.zoomBackground,
                    ],
                    background: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const SizedBox(
                          height: kToolbarHeight,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primary0,
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  color: AppColors.gray)
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "# ${controller.isPurchase ? controller.purchasesInvoice.number : controller.saleInvoice.number}",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: AppColors.primary50,
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
                                    color: AppColors.primary50,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: AppColors.primary60),
                                    ),
                                    Text(
                                      ' ${controller.isPurchase ? controller.purchasesInvoice.totalPrice : controller.saleInvoice.totalPrice}',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Paid: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: AppColors.primary60),
                                    ),
                                    Text(
                                      ' ${controller.isPurchase ? controller.purchasesInvoice.paid : controller.saleInvoice.paid}',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Debt: ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: AppColors.primary60),
                                    ),
                                    Text(
                                      ' ${controller.isPurchase ? controller.purchasesInvoice.remained : controller.saleInvoice.remained}',
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
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Expanded(
                      child: Container(
                        color: AppColors.primary0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.arrow_back)),
                                Text(
                                  "${controller.isPurchase ? 'Purchases' : "Sales"} invoice",
                                  style: GoogleFonts.oswald(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                    color: AppColors.primary70,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.invoicesController.mainController
                                        .showDialogMeetDebt(
                                            context,
                                            controller.invoiceType ==
                                                    InvoiceType.purchases
                                                ? controller
                                                    .purchasesInvoice.remained
                                                : controller
                                                    .saleInvoice.remained,
                                            controller.meetDebtInvoice);
                                  },
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
                                      case OperationType.update:
                                        {
                                          Get.toNamed(
                                              AppPagesRoutes
                                                  .operationOnInvoiceScreen,
                                              arguments: {
                                                AppSharedKeys.passInvoiceType:
                                                    controller.invoiceType,
                                                AppSharedKeys.passOperationType:
                                                    OperationType.update,
                                                AppSharedKeys.passId: controller
                                                            .invoiceType ==
                                                        InvoiceType.sales
                                                    ? controller.saleInvoice.id
                                                    : controller
                                                        .purchasesInvoice.id,
                                              });
                                          break;
                                        }
                                      case OperationType.delete:
                                        {
                                          controller.invoicesController
                                              .showDialogDeleteInvoice(
                                            context,
                                            invoice: controller.invoiceType ==
                                                    InvoiceType.sales
                                                ? controller.saleInvoice
                                                : controller.purchasesInvoice,
                                            invoiceType: controller.invoiceType,
                                            onSuccess: () async {
                                              Get.back();
                                            },
                                          );
                                          break;
                                        }
                                      case OperationType.archive:
                                        {
                                          await controller.invoicesController
                                              .archiveInvoice(
                                            invoice: controller.invoiceType ==
                                                    InvoiceType.purchases
                                                ? controller.purchasesInvoice
                                                : controller.saleInvoice,
                                            invoiceType: controller.invoiceType,
                                            onSuccess: () {
                                              Get.back();
                                            },
                                          );
                                          break;
                                        }
                                      case OperationType.registers:
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
                                            color: AppColors.success50,
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
                                              color: AppColors.danger50,
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
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
              body: Container(
                margin: const EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, left: 15),
                      child: Text(controller.isPurchase ? 'Purchases' : 'Sales',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    (controller.isPurchase && controller.purchasesInvoice.details.purchases.isNotEmpty)
                    ||(!controller.isPurchase && controller.saleInvoice.details.sales.isNotEmpty)
                        ? ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shrinkWrap: true,
                            itemCount: controller.isPurchase
                                ? controller.purchasesInvoice.details.purchases.length
                            : controller.saleInvoice.details.sales.length,
                            itemBuilder: (context, index) => Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  Get.toNamed(
                                      AppPagesRoutes.productDetailsScreen,
                                      arguments: {
                                        AppSharedKeys.passId: controller.isPurchase
                                              ?controller.purchasesInvoice.details.purchases[index].productId
                                            :controller.saleInvoice.details.sales[index].productId
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.isPurchase
                                                ?controller.purchasesInvoice.details.purchases[index].productName
                                              :controller.saleInvoice.details.sales[index].productName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    fontSize: 22,
                                                    letterSpacing: 1),
                                          ),
                                          TextIcon(
                                            text:
                                                " ${controller.isPurchase
                                                        ?controller.purchasesInvoice.details.purchases[index].amount
                                                      :controller.saleInvoice.details.sales[index].amount}",
                                            icon: Icons.trending_down,
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
                                                "${controller.isPurchase
                                                    ?controller.purchasesInvoice.details.purchases[index].totalPurchasePrice / controller.purchasesInvoice.details.purchases[index].amount
                                                    :controller.saleInvoice.details.sales[index].totalSalePrice / controller.saleInvoice.details.sales[index].amount} \$",
                                            icon: Icons.upload,
                                          ),
                                          TextIcon(
                                            text:
                                                " ${controller.isPurchase
                                                        ?controller.purchasesInvoice.details.purchases[index].totalPurchasePrice
                                                      :controller.saleInvoice.details.sales[index].totalSalePrice} \$",
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
                                "No any Purchase",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.primary70,
                                        fontSize: 24),
                              )
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
