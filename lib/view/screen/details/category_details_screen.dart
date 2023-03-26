
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/category_details_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/title_section.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 2),
                                  spreadRadius: 0,
                                  blurRadius: 2,
                                  color: AppColors.gray)
                            ],
                          ),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
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
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.category.name,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "This category so old",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.gray,
                                    fontWeight: FontWeight.w400),
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
                              Text(
                                "${controller.category.productsAmount} ",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "products",
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
                              Text(
                                "${controller.category.salesAmount} ",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "sales",
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
                              Text(
                                "${controller.category.purchasesAmount} ",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "buys",
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
                  title: "Products",
                  onPressed: () {
                    Get.toNamed(AppPagesRoutes.productsScreen, arguments: {
                      AppSharedKeys.passId: controller.categoryId,
                      AppSharedKeys.passFilter: 'category'
                    });
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
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                            decoration: BoxDecoration(
                              color: AppColors.blackAccentT,
                              borderRadius: BorderRadius.vertical(
                                top: const Radius.circular(15),
                                bottom:
                                    controller.category.details.products.isEmpty
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
                                  "Amount",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryAccent200,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Sales Price",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryAccent200,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Bays Price",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryAccent200,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                        ...List.generate(
                            controller.category.details.products.length,
                            (index) => TableRow(
                                    decoration: BoxDecoration(
                                        color: AppColors.whiteSecondary,
                                        borderRadius: index ==
                                                controller.category.details
                                                        .products.length -
                                                    1
                                            ? const BorderRadius.vertical(
                                                bottom: Radius.circular(15))
                                            : null),
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.toNamed(
                                              AppPagesRoutes
                                                  .productDetailsScreen,
                                              arguments: {
                                                AppSharedKeys.passId: controller
                                                    .category
                                                    .details
                                                    .products[index]
                                                    .id
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
                                        child: Text(controller.category.details
                                            .products[index].name,style: Theme.of(context).textTheme.bodyMedium,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(controller.category.details
                                            .products[index].amount
                                            .toString()),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${controller.category.details.products[index].salePrice} \$"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${controller.category.details.products[index].purchasePrice} \$"),
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
                  onPressed: () {},
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
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
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
                                bottom:
                                    controller.category.details.sales.isEmpty
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
                                  "Amount",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryAccent200,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Sales Price",
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
                            controller.category.details.sales.length,
                            (index) => TableRow(
                                    decoration: const BoxDecoration(
                                      color: AppColors.whiteSecondary,
                                    ),
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.toNamed(
                                              AppPagesRoutes
                                                  .productDetailsScreen,
                                              arguments: {
                                                AppSharedKeys.passId: controller
                                                    .category
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
                                        child: Text(controller.category.details
                                            .sales[index].productName,style: Theme.of(context).textTheme.bodyMedium,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(controller.category.details
                                            .sales[index].amount
                                            .toString()),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${controller.category.details.sales[index].totalSalePrice / controller.category.details.sales[index].amount} \$"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${controller.category.details.sales[index].totalSalePrice} \$"),
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
                  onPressed: () {},
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
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
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
                                bottom: controller
                                        .category.details.purchases.isEmpty
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
                                  "Amount",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primaryAccent200,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Purchase Price",
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
                            controller.category.details.purchases.length,
                            (index) => TableRow(
                                    decoration: const BoxDecoration(
                                      color: AppColors.whiteSecondary,
                                    ),
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.toNamed(
                                              AppPagesRoutes
                                                  .productDetailsScreen,
                                              arguments: {
                                                AppSharedKeys.passId: controller
                                                    .category
                                                    .details
                                                    .purchases[index]
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
                                        child: Text(controller.category.details
                                            .purchases[index].productName,style: Theme.of(context).textTheme.bodyMedium,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(controller.category.details
                                            .purchases[index].amount
                                            .toString()),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${controller.category.details.purchases[index].details.product.purchasePrice} \$"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${controller.category.details.purchases[index].details.product.purchasePrice * controller.category.details.purchases[index].amount} \$"),
                                      ),
                                    ]))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.05 * Get.height,
                ),
              ],
            ),
          )),
    );
  }
}
