
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/categories_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:repository/view/widget/shared/empty.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/search_appbar.dart';
import 'package:repository/view/widget/shared/sort_dialog.dart';

class CategoriesScreen extends GetView<CategoriesController> {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: !controller.isSearchMode
              ? const Text(
                  'Categories',
                )
              : null,
          actions: [
            Visibility(
              visible: !controller.isSearchMode,
              child: IconButton(
                onPressed: () {
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
                onPressed: () {
                  HelperDesignFunctions.showAlertDialog(context,
                      btnOkOnPress: () async {
                        await controller.sort(controller.allCategories);
                      },
                      title: "Sort Category",
                      children: [
                        SortDialog<CategoriesController>(
                          ascending: controller.ascending,
                          onChange: (sortItems,isAscending) {
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
                controller: controller.mainController.searchFieldController,
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
                )),
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
            await controller.createCategory(context);
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
              child: controller.categories.isNotEmpty
                  ? GridView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 1),
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 3),
                                spreadRadius: 0,
                                blurRadius: 3,
                                color: AppColors.gray)
                          ],
                          color: AppColors.primary5,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Get.toNamed(AppPagesRoutes.categoryDetailsScreen,
                                arguments: {
                                  AppSharedKeys.passId:
                                      controller.categories[index].id
                                });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned.fill(
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(0, 2),
                                          spreadRadius: 0,
                                          blurRadius: 2,
                                          color: AppColors.gray)
                                    ],
                                  ),
                                  child: Hero(
                                    tag: controller.categories[index].id,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: controller.categories[index].photo,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 36,
                                        backgroundColor: AppColors.primary0,
                                        child: Text(
                                            '${controller.categories[index].name[0]}${controller.categories[index].name[1]}',
                                            style: const TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.black)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      gradient: const LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            AppColors.black60,
                                            AppColors.black40,
                                          ])),
                                ),
                              ),
                              Positioned.fill(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      controller.categories[index].name,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          color: AppColors.primary0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.productsIconSvg,
                                          height: 20,
                                          color: AppColors.primary20,
                                        ),
                                        Text(
                                          ' ${controller.categories[index].productsAmount}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: AppColors.primary0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(Icons.trending_up,
                                            color: AppColors.primary20),
                                        Text(
                                          ' ${controller.categories[index].salesAmount}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: AppColors.primary0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(Icons.trending_down,
                                            color: AppColors.primary20),
                                        Text(
                                          ' ${controller.categories[index].purchasesAmount}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: AppColors.primary0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Empty(
                      imagePath: AppAssets.noOrder,
                      text: "No any Category",
                      height: 200,
                      fontSize: 24,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
