import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/product_details_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/view/widget/shared/nested_scroll_view_page.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class ProductDetailsScreen extends GetView<ProductDetailsController> {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsController>(
      builder: (controller) => NestedScrollViewPage(
        title: "${HelperLogicFunctions.upperFirstChar(controller.product.name)} Product",
        statusView: controller.statusView,
        imageUrl: controller.product.photo,
        tabBar: TabBar(
          controller: controller.tabController,
          tabs: [
            Tab(
                child: Text(
              "Purchases",
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
            controller.product.details.purchases.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.product.details.purchases.length,
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
                                    controller.product.details.purchases[index]
                                        .supplierName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 22, letterSpacing: 1),
                                  ),
                                  TextIcon(
                                    text:
                                        " ${controller.product.details.purchases[index].invoiceNumber}",
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
                                        "${controller.product.details.purchases[index].amount}",
                                    icon: Icons.upload,
                                  ),
                                  TextIcon(
                                    text:
                                        " ${controller.product.details.purchases[index].totalPurchasePrice} \$",
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
                            .copyWith(color: AppColors.primary70, fontSize: 24),
                      )
                    ],
                  ),
            controller.product.details.sales.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.product.details.sales.length,
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
                                    controller.product.details.sales[index]
                                        .clientName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 22, letterSpacing: 1),
                                  ),
                                  TextIcon(
                                    text:
                                        " ${controller.product.details.sales[index].invoiceNumber}",
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
                                        "${controller.product.details.sales[index].amount}",
                                    icon: Icons.upload,
                                  ),
                                  TextIcon(
                                    text:
                                        " ${controller.product.details.sales[index].totalSalePrice} \$",
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
              controller.productsController.mainController
                  .individualStocktaking(context,
                      stocktakingType: StocktakingType.product,
                      enabledSelect: false,
                      item: controller.product);
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
                    controller.productsController.showSheetUpdateProduct(
                      context,
                      product: controller.product,
                      onSuccess: () async {
                        await controller.getProduct();
                      },
                    );
                    break;
                  }
                case OperationType.delete:
                  {
                    controller.productsController.showDialogDeleteProduct(
                      context,
                      product: controller.product,
                      onSuccess: () async {
                        Get.back();
                      },
                    );
                    break;
                  }
                case OperationType.registers:
                  {
                    controller.getProductRegisters(context: context);
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
                  "Category: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary40),
                ),
                Text(
                  controller.product.categoryName,
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
                  "Products amount: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary40),
                ),
                Text(
                  "${controller.product.amount} ${controller.product.measuringUnit}",
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
                  "Purchases Price: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary40),
                ),
                Text(
                  "${controller.product.purchasePrice} \$",
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
                  "Sales Price: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.primary40),
                ),
                Text(
                  "${controller.product.salePrice} \$",
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
