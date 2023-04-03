import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/category_details_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/view/widget/shared/empty.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/section_tabs.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class CategoryDetailsScreen extends GetView<CategoryDetailsController> {
  const CategoryDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryDetailsController>(
      builder: (controller) => Scaffold(
          appBar: AppBar(
            title: Text(
              "${controller.category.name} Category",
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.categoriesController.mainController
                      .individualStocktaking(context,
                      stocktakingType: StocktakingType.category,
                      enabledSelect: false,
                      item: controller.category);
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
                        controller.categoriesController
                            .showDialogUpdateCategory(
                          context,
                          category: controller.category,
                          onSuccess: () async {
                            await controller.getCategory();
                          },
                        );
                        break;
                      }
                    case OperationType.delete:
                      {
                        controller.categoriesController
                            .showDialogDeleteCategory(
                          context,
                          category: controller.category,
                          onSuccess: () async {
                            Get.back();
                          },
                        );
                        break;
                      }
                    case OperationType.registers:
                      {
                        controller.getCategoryRegisters(context: context);
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
          ),
          body: HandleRequest(
              statusView: controller.statusView,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
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
                        Center(
                          child: Hero(
                            tag: controller.category.id,
                            child: Container(
                              height: 0.8 * Get.width,
                              width: 0.8 * Get.width,
                              clipBehavior: Clip.hardEdge,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: controller.category.photo,
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  radius: 36,
                                  backgroundColor: AppColors.primary0,
                                  child: Text(
                                      '${controller.category.name[0]}${controller.category.name[1]}',
                                      style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black)),
                                ),
                              ),
                            ),
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
                                    .copyWith(color: AppColors.primary60),
                              ),
                              Text(
                                "${controller.category.productsAmount}",
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
                                "Sales amount: ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: AppColors.primary60),
                              ),
                              Text(
                                "${controller.category.salesAmount}",
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
                                "Purchases amount: ",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: AppColors.primary60),
                              ),
                              Text(
                                "${controller.category.purchasesAmount}",
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
                  SectionTabs(
                    title: "Recently",
                    tabsTitles: const [
                      "Products",
                      "Purchases",
                      "Sales",
                    ],
                    tabViewHeight: 0.7 * Get.width,
                    controller: controller.tabController,
                    onArrowPressed: null,
                    onTab: (index) {

                    },
                    tabs: [
                      controller.category.details.products.isNotEmpty
                          ? ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                        controller.category.details.products.length,
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
                                    AppSharedKeys.passId: controller
                                        .category.details.products[index].id
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
                                        controller.category.details
                                            .products[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                            fontSize: 22,
                                            letterSpacing: 1),
                                      ),
                                      TextIcon(
                                        text:
                                        " ${controller.category.details.products[index].amount}",
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
                                        " ${controller.category.details.products[index].salePrice} \$",
                                        icon: Icons.upload,
                                      ),
                                      TextIcon(
                                        text:
                                        " ${controller.category.details.products[index].purchasePrice} \$",
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
                          : Empty(
                        imagePath: AppAssets.noOrder,
                        text: "No any Product",
                        height: 200,
                        fontSize: 24,
                      ),
                      controller.category.details.purchases.isNotEmpty
                          ? ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                        controller.category.details.purchases.length,
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
                                    AppSharedKeys.passId: controller
                                        .category.details.purchases[index].productId
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
                                        controller.category.details
                                            .purchases[index].productName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                            fontSize: 22,
                                            letterSpacing: 1),
                                      ),
                                      TextIcon(
                                        text:
                                        " ${controller.category.details.purchases[index].amount}",
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
                                        "${controller.category.details.purchases[index].totalPurchasePrice / controller.category.details.purchases[index].amount} \$",
                                        icon: Icons.upload,
                                      ),
                                      TextIcon(
                                        text:
                                        " ${controller.category.details.purchases[index].totalPurchasePrice} \$",
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
                          : Empty(
                        imagePath: AppAssets.noOrder,
                        text: "No any Purchase",
                        height: 200,
                        fontSize: 24,
                      ),
                      controller.category.details.sales.isNotEmpty
                          ? ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                        controller.category.details.sales.length,
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
                                    AppSharedKeys.passId: controller
                                        .category.details.sales[index].productId
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
                                        controller.category.details
                                            .sales[index].productName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                            fontSize: 22,
                                            letterSpacing: 1),
                                      ),
                                      TextIcon(
                                        text:
                                        " ${controller.category.details.sales[index].amount}",
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
                                        "${controller.category.details.sales[index].totalSalePrice / controller.category.details.sales[index].amount} \$",
                                        icon: Icons.upload,
                                      ),
                                      TextIcon(
                                        text:
                                        " ${controller.category.details.sales[index].totalSalePrice} \$",
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
                          : Empty(
                        imagePath: AppAssets.noOrder,
                        text: "No any Sale",
                        height: 200,
                        fontSize: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ),
    );
  }
}
