import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/view/widget/shared/title_section.dart';

class StocktakingPage extends GetView<MainController> {
  const StocktakingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO fix exception NotificationListener
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        return controller.onNotification(notification);
      },
      child: GetBuilder<MainController>(
          builder: (controller) => ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                controller: controller.stockingScrollController,
                physics: const PageScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,),
                    child: Text(
                        "Individual Stocktaking",
                        style: Theme.of(context).textTheme.titleLarge
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            controller.individualStocktaking(context, stocktakingType: StocktakingType.category);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 0.2 * Get.width,
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary5,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 2),
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          color: AppColors.gray),
                                    ]),
                                child: SvgPicture.asset(
                                  AppAssets.categoriesIconSvg,
                                  color: AppColors.primary70,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Category",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            controller.individualStocktaking(context,
                                stocktakingType: StocktakingType.product);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 0.2 * Get.width,
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary5,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 2),
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          color: AppColors.gray),
                                    ]),
                                child: SvgPicture.asset(
                                  AppAssets.productsIconSvg,
                                  color: AppColors.primary70,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Product",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            controller.individualStocktaking(context,
                                stocktakingType: StocktakingType.client);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 0.2 * Get.width,
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary5,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 2),
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          color: AppColors.gray),
                                    ]),
                                child: SvgPicture.asset(
                                  AppAssets.clientsIconSvg,
                                  color: AppColors.primary70,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Client",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            controller.individualStocktaking(context,
                                stocktakingType: StocktakingType.supplier);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 0.2 * Get.width,
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary5,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 2),
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          color: AppColors.gray),
                                    ]),
                                child: SvgPicture.asset(
                                  AppAssets.suppliersIconSvg,
                                  color: AppColors.primary70,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Supplier",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 20),
                    child: TitleSection(
                      title: "Full Stocktaking",
                      onPressed: () {
                        Get.toNamed(AppPagesRoutes.moneyBoxScreen, arguments: {
                          AppSharedKeys.passFilter: PublicFilterType.date
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: AppColors.primary5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            await controller.choseDateRange(context);
                            await controller.getFullStocktaking();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(controller.startDate),
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward),
                      Material(
                        color: AppColors.primary5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            await controller.choseDateRange(context);
                            await controller.getFullStocktaking();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(controller.endDate),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    margin: const EdgeInsets.only(top: 10),
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
                          "Debts and Profit:",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.primary70),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 15),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Expenses Debts: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.debtsExpenses} \$",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Suppliers Debts: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.debtsSuppliers} \$",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Clients Debts: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.debtsClients} \$",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const Divider(
                                  thickness: 1, color: AppColors.gray),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Expected Profit: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.expectedProfits} \$",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profit: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.profits} \$",
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
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.primary70),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 15),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Sales: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.salesTotalPrice} \$",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Purchase: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.purchasesTotalPrice} \$",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pushed: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.addCash} \$",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pulled: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.withdrawalCash} \$",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Expenses: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.expenses} \$",
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
                          "Amounts:",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: AppColors.primary70),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 15),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Sales: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.salesAmount}",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Purchase: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.gray),
                                  ),
                                  Text(
                                    "${controller.fullStocktaking.purchasesAmount}",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
    );
  }
}
