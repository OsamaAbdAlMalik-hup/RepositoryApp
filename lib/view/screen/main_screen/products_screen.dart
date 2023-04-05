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
                      onBackIconPressed: () async {
                        controller.isSearchMode = false;
                        controller.mainController.searchFieldController.clear();
                        await controller.search('');
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
                        onTap: (index) {
                          controller.mainController.onTapFilter(index,controller.search);
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
                    controller.mainController.searchFieldController.clear();
                    await controller.search('');
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
                                                backgroundImage: CachedNetworkImageProvider(
                                                  controller.products[index].photo,

                                                ),
                                            ),
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
