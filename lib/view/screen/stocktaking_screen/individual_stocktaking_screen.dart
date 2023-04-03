
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/stocktaking_screen/individual_stocktaking_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/title_section.dart';

class IndividualStocktakingScreen extends GetView<IndividualStocktakingController> {
  const IndividualStocktakingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualStocktakingController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('${controller.title} Stocktaking',),
        ),
        body: HandleRequest(
          statusView: controller.statusView,
          child: ListView(
            padding: const EdgeInsets.all(15).copyWith(bottom: 0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionChip(
                    label: Row(
                      children: [
                        const Text(
                          'From: ',
                          style: TextStyle(color: AppColors.gray),
                        ),
                        Text(controller.mainController.startDate),
                      ],
                    ),
                    onPressed: () async {
                      await controller.mainController.choseDateRange(context);
                      await controller.stocktaking();
                    },
                  ),
                  ActionChip(
                    label: Row(
                      children: [
                        const Text(
                          'To: ',
                          style: TextStyle(color: AppColors.gray),
                        ),
                        Text(controller.mainController.endDate),
                      ],
                    ),
                    onPressed: () async {
                      await controller.mainController.choseDateRange(context);
                      await controller.stocktaking();
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: TitleSection(
                  title: "Information of ${controller.name}",
                  onPressed: () {
                    Get.toNamed(controller.targetPage,
                        arguments: {AppSharedKeys.passId: controller.id});
                  },
                ),
              ),
              Visibility(
                visible: controller.stocktakingType == StocktakingType.category ||
                    controller.stocktakingType == StocktakingType.product,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                          blurRadius: 2,
                          color: AppColors.gray)
                    ],
                    color: AppColors.primary10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amounts:",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.primary70
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin:
                            const EdgeInsets.only(left: 20, top: 10, bottom: 15),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Purchase: ",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray
                                  ),
                                ),
                                Text(
                                  "${controller.isCategory ? controller.categoryStocktaking.purchasesAmount : controller.productStocktaking.purchasesAmount}",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sales: ",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray
                                  ),
                                ),
                                Text(
                                  "${controller.isCategory ? controller.categoryStocktaking.salesAmount : controller.productStocktaking.salesAmount}",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Total Money:",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.primary70
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin:
                            const EdgeInsets.only(left: 20, top: 10, bottom: 15),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sales: ",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray
                                  ),
                                ),
                                Text(
                                  "${controller.isCategory ? controller.categoryStocktaking.salesTotalPrice : controller.productStocktaking.salesTotalPrice} \$",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Purchase: ",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray
                                  ),
                                ),
                                Text(
                                  "${controller.isCategory ? controller.categoryStocktaking.purchasesTotalPrice : controller.productStocktaking.purchaseTotalPrice} \$",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Profit:",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.primary70
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin:
                        const EdgeInsets.only(left: 20, top: 10, bottom: 15),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Actual: ",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray
                                  ),
                                ),
                                Text(
                                  "${controller.isCategory ? controller.categoryStocktaking.profits : controller.productStocktaking.profit} \$",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Expected:",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray
                                  ),
                                ),
                                Text(
                                  "${controller.isCategory ? controller.categoryStocktaking.expectedProfits : controller.productStocktaking.expectedProfit} \$",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: controller.stocktakingType == StocktakingType.client ||
                    controller.stocktakingType == StocktakingType.supplier,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                          blurRadius: 2,
                          color: AppColors.gray)
                    ],
                    color: AppColors.primary10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amounts:",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.primary70
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin:
                            const EdgeInsets.only(left: 20, top: 10, bottom: 15),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Invoices: ",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray
                                  ),
                                ),
                                Text(
                                  "${controller.isSupplier ? controller.supplierStocktaking.invoicesCount : controller.clientStocktaking.invoicesCount}",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            controller.isSupplier
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Purchases: ",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: AppColors.gray
                                        ),
                                      ),
                                      Text(
                                        "${controller.supplierStocktaking.purchasesAmount}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Sales: ",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: AppColors.gray
                                        ),
                                      ),
                                      Text(
                                        "${controller.clientStocktaking.salesAmount}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      Text(
                        "Total Money:",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.primary70
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        margin:
                            const EdgeInsets.only(left: 20, top: 10, bottom: 15),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            controller.isSupplier
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Purchases: ",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: AppColors.gray
                                        ),
                                      ),
                                      Text(
                                        "${controller.supplierStocktaking.invoicesTotal} \$",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Sales: ",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: AppColors.gray
                                        ),
                                      ),
                                      Text(
                                        "${controller.clientStocktaking.invoicesTotal} \$",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Paid:",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray
                                  ),
                                ),
                                Text(
                                  "${controller.isSupplier ? controller.supplierStocktaking.paid : controller.clientStocktaking.paid} \$",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "debts: ",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.gray
                                  ),
                                ),
                                Text(
                                  "${controller.isSupplier ? controller.supplierStocktaking.debts : controller.clientStocktaking.debts} \$",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

