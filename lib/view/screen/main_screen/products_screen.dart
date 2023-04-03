import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/products_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/view/widget/shared/empty.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/search_appbar.dart';
import 'package:repository/view/widget/shared/sort_dialog.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: !controller.isSearchMode
                    ? const Text(
                        'Product',
                      )
                    : null,
                actions: [
                  Visibility(
                    visible: !controller.isSearchMode,
                    child: IconButton(
                      onPressed: () async {
                        controller.isSearchMode = true;
                        controller.update();
                      },
                      icon: const Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !controller.isSearchMode,
                    child: IconButton(
                      onPressed: () async {
                        HelperDesignFunctions.showAlertDialog(context,
                            btnOkOnPress: () async {
                          await controller.sort(controller.allProducts);
                        }, title: "Sort Product", children: [
                          SortDialog<ProductsController>(
                            ascending: controller.ascending,
                            onChange: (sortItems, isAscending) {
                              controller.ascending = isAscending;
                              controller.sortItems = sortItems;
                              controller.update();
                            },
                            sortItems: controller.sortItems,
                          )
                        ]);
                      },
                      icon: const Icon(
                        Icons.sort_by_alpha,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.isSearchMode,
                    child: SearchAppbar(
                      hintText: "Search By any Filter",
                      controller:
                          controller.mainController.searchFieldController,
                      onChanged: (value) {
                        controller.search(value);
                      },
                      onBackIconPressed: () {
                        controller.isSearchMode = false;
                        controller.update();
                      },
                      onSearchIconPressed: () {},
                    ),
                  ),
                  Visibility(
                      visible: false,
                      child: TabBarView(
                        controller: controller.filterTabController,
                        children: List.generate(
                          controller.searchItem.length,
                          (index) => Text(index.toString()),
                        ),
                      ))
                ],
                bottom: controller.isSearchMode
                    ? TabBar(
                        isScrollable: true,
                        onTap: (value) {
                          controller.filterTabIndex=value;
                        },
                        controller: controller.filterTabController,
                        tabs: List.generate(
                            controller.searchItem.length,
                            (index) => Tab(
                                  child: Text(
                                    controller.searchItem[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: AppColors.primary60),
                                  ),
                                )),
                      )
                    : null,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await controller.createProduct(context);
                },
                child: const Icon(Icons.add, color: AppColors.black),
              ),
              body: WillPopScope(
                onWillPop: () async {
                  if (controller.isSearchMode) {
                    controller.isSearchMode = false;
                    controller.update();
                    return false;
                  }
                  return true;
                },
                child: InkWell(
                  splashColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: HandleRequest(
                    statusView: controller.statusView,
                    child: controller.products.isNotEmpty
                        ? SlidableAutoCloseBehavior(
                            closeWhenOpened: true,
                            child: ListView.builder(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              itemCount: controller.products.length,
                              itemBuilder: (context, index) => Slidable(
                                startActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  extentRatio: 0.25,
                                  children: [
                                    SlidableAction(
                                      onPressed: (c) async {
                                        controller.showDialogDeleteProduct(
                                            context,
                                            product:
                                                controller.products[index]);
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      backgroundColor: AppColors.danger50,
                                      icon: Icons.delete_outlined,
                                    ),
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  extentRatio: 0.25,
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (c) async {
                                        controller.showSheetUpdateProduct(
                                            context,
                                            product:
                                                controller.products[index]);
                                      },
                                      foregroundColor: AppColors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      backgroundColor: AppColors.success50,
                                      icon: Icons.edit_outlined,
                                    ),
                                  ],
                                ),
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Get.toNamed(
                                          AppPagesRoutes.productDetailsScreen,
                                          arguments: {
                                            AppSharedKeys.passId:
                                                controller.products[index].id
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: CircleAvatar(
                                                radius: 38,
                                                backgroundColor:
                                                    AppColors.primary0,
                                                child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl: controller
                                                        .products[index].photo,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            CircleAvatar(
                                                      radius: 35,
                                                      backgroundColor:
                                                          AppColors.primary0,
                                                      child: Text(
                                                          '${controller.products[index].name[0]}${controller.products[index].name[1]}',
                                                          style: const TextStyle(
                                                              fontSize: 40,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .black)),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller
                                                        .products[index].name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                            fontSize: 22,
                                                            letterSpacing: 1),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextIcon(
                                                        text:
                                                            " ${controller.products[index].salePrice} \$",
                                                        icon: Icons.upload,
                                                      ),
                                                      TextIcon(
                                                        text:
                                                            " ${controller.products[index].purchasePrice} \$",
                                                        icon: Icons.download,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextIcon(
                                                        text:
                                                            " ${controller.products[index].amount}",
                                                        icon:
                                                            Icons.trending_down,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            AppAssets
                                                                .categoriesIconSvg,
                                                            color: AppColors
                                                                .primary70,
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            '  ${controller.products[index].categoryName}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                  ),
                ),
              ),
            ));
  }
}

class SortItem {
  String label;
  IconData icon;
  bool isSelected;

  SortItem({required this.label, required this.icon, required this.isSelected});
}

/*
void get(BuildContext context) {
    HelperDesignFunctions.showAwesomeDialog(context, btnOkOnPress: () async {
      await controller.sort(controller.allProducts);
    },
        btnCancelOnPress: () {},
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<ProductsController>(
            builder: (controller) => Column(
              children: [
                Text(
                  "Sort Products",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  children: [
                    FilterChip(
                      padding: EdgeInsets.zero,
                      selectedColor: AppColors.primary0,
                      backgroundColor: AppColors.primary0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      label: const Icon(Icons.text_rotation_angledown),
                      onSelected: (value) {
                        controller.ascending = true;
                        controller.update();
                      },
                      selected: controller.ascending,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FilterChip(
                      padding: EdgeInsets.zero,
                      selectedColor: AppColors.primary0,
                      backgroundColor: AppColors.primary0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      label: const Icon(Icons.text_rotation_angleup),
                      onSelected: (value) {
                        controller.ascending = false;
                        controller.update();
                      },
                      selected: !controller.ascending,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        controller.selectTypeFilter(ProductFilterType.name);
                      },
                      child: SizedBox(
                        width: 70,
                        child: Column(
                          children: [
                            Icon(
                              Icons.text_fields,
                              color: controller.byName
                                  ? AppColors.primary60
                                  : AppColors.black,
                            ),
                            Text(
                              "name",
                              style: TextStyle(
                                  color: controller.byName
                                      ? AppColors.primary60
                                      : AppColors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        controller.selectTypeFilter(ProductFilterType.category);
                      },
                      child: SizedBox(
                        width: 70,
                        child: Column(
                          children: [
                            Icon(
                              Icons.category,
                              color: controller.byCategory
                                  ? AppColors.primary60
                                  : AppColors.black,
                            ),
                            Text(
                              "category",
                              style: TextStyle(
                                  color: controller.byCategory
                                      ? AppColors.primary60
                                      : AppColors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        controller.selectTypeFilter(ProductFilterType.benefit);
                      },
                      child: SizedBox(
                        width: 70,
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_chart,
                              color: controller.byProfit
                                  ? AppColors.primary60
                                  : AppColors.black,
                            ),
                            Text(
                              "profit",
                              style: TextStyle(
                                  color: controller.byProfit
                                      ? AppColors.primary60
                                      : AppColors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        controller
                            .selectTypeFilter(ProductFilterType.productsAmount);
                      },
                      child: SizedBox(
                        width: 70,
                        child: Column(
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: controller.byProductsAmount
                                  ? AppColors.primary60
                                  : AppColors.black,
                            ),
                            Text(
                              "product amount",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: controller.byProductsAmount
                                      ? AppColors.primary60
                                      : AppColors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        controller
                            .selectTypeFilter(ProductFilterType.salePrice);
                      },
                      child: SizedBox(
                        width: 70,
                        child: Column(
                          children: [
                            Icon(
                              Icons.text_fields,
                              color: controller.bySalesPrice
                                  ? AppColors.primary60
                                  : AppColors.black,
                            ),
                            Text(
                              "selling price",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: controller.bySalesPrice
                                      ? AppColors.primary60
                                      : AppColors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        controller
                            .selectTypeFilter(ProductFilterType.purchasePrice);
                      },
                      child: SizedBox(
                        width: 70,
                        child: Column(
                          children: [
                            Icon(
                              Icons.text_fields,
                              color: controller.byPurchasesPrice
                                  ? AppColors.primary60
                                  : AppColors.black,
                            ),
                            Text(
                              "purchase price",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: controller.byPurchasesPrice
                                      ? AppColors.primary60
                                      : AppColors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  ChoiceChip(
                                              label: const Text("Name"),
                                              selected: controller.byName,
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: AppColors.primary),
                                              onSelected: (value) {
                                                controller.selectTypeFilter(
                                                    ProductFilterType.name);
                                              },
                                              backgroundColor:
                                              AppColors.whiteSecondary,
                                              selectedColor:
                                              AppColors.primaryAccent200,
                                            ),
                                            ChoiceChip(
                                              label: const Text("Category"),
                                              selected: controller.byCategory,
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: AppColors.primary),
                                              onSelected: (value) {
                                                controller.selectTypeFilter(
                                                    ProductFilterType.category);
                                              },
                                              backgroundColor:
                                              AppColors.whiteSecondary,
                                              selectedColor:
                                              AppColors.primaryAccent200,
                                            ),
                                            ChoiceChip(
                                              label: const Text("Profit"),
                                              selected: controller.byProfit,
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: AppColors.primary),
                                              onSelected: (value) {
                                                controller.selectTypeFilter(ProductFilterType.benefit);
                                              },
                                              backgroundColor:
                                              AppColors.whiteSecondary,
                                              selectedColor:
                                              AppColors.primaryAccent200,
                                            ),
                                            ChoiceChip(
                                              label:
                                              const Text("Product Amount"),
                                              selected:
                                              controller.byProductsAmount,
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: AppColors.primary),
                                              onSelected: (value) {
                                                controller.selectTypeFilter(
                                                    ProductFilterType
                                                        .productsAmount);
                                              },
                                              backgroundColor:
                                              AppColors.whiteSecondary,
                                              selectedColor:
                                              AppColors.primaryAccent200,
                                            ),
                                            ChoiceChip(
                                              label: const Text("Sales Price"),
                                              selected: controller.bySalesPrice,
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: AppColors.primary),
                                              onSelected: (value) {
                                                controller.selectTypeFilter(
                                                    ProductFilterType
                                                        .salePrice);
                                              },
                                              backgroundColor:
                                              AppColors.whiteSecondary,
                                              selectedColor:
                                              AppColors.primaryAccent200,
                                            ),
                                            ChoiceChip(
                                              label:
                                              const Text("Purchase Price"),
                                              selected:
                                              controller.byPurchasesPrice,
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: AppColors.primary),
                                              onSelected: (value) {
                                                controller.selectTypeFilter(
                                                    ProductFilterType
                                                        .purchasePrice);
                                              },
                                              backgroundColor:
                                              AppColors.whiteSecondary,
                                              selectedColor:
                                              AppColors.primaryAccent200,
                                            ),
                                            ChoiceChip(
                                              label: const Text("Create At"),
                                              selected: controller.byCreateAt,
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: AppColors.primary),
                                              onSelected: (value) {
                                                controller.selectTypeFilter(
                                                    ProductFilterType.createAt);
                                              },
                                              backgroundColor:
                                              AppColors.whiteSecondary,
                                              selectedColor:
                                              AppColors.primaryAccent200,
                                            ),
                                            ChoiceChip(
                                              label: const Text("Update At"),
                                              selected: controller.byUpdateAt,
                                              side: const BorderSide(
                                                  width: 2,
                                                  color: AppColors.primary),
                                              onSelected: (value) {
                                                controller.selectTypeFilter(
                                                    ProductFilterType.updateAt);
                                              },
                                              backgroundColor:
                                              AppColors.whiteSecondary,
                                              selectedColor:
                                              AppColors.primaryAccent200,
                                            ),
 */
