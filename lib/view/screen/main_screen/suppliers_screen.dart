import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/suppliers_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/view/widget/shared/empty.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/view/widget/shared/search_appbar.dart';
import 'package:repository/view/widget/shared/sort_dialog.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class SuppliersScreen extends GetView<SuppliersController> {
  const SuppliersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuppliersController>(
        builder: (controller) => Scaffold(
        appBar: AppBar(
          title: !controller.isSearchMode
              ? const Text(
            'Suppliers',
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
              child: PopupMenuButton<OperationType>(
                tooltip: "Operation",
                onSelected: (value) async {
                  switch (value) {
                    case OperationType.sort:
                      {
                        HelperDesignFunctions.showAwesomeDialog(context,
                            btnOkOnPress: () async {
                              await controller.sort(controller.allSuppliers);
                            },
                            btnCancelOnPress: () {},
                            body: SortDialog<SuppliersController>(
                              title: "Sort Suppliers",
                              ascending: controller.ascending,
                              onAscending: (isAscending) {
                                controller.ascending = isAscending;
                                controller.update();
                              },
                              sortItems: controller.sortItems,
                            ));
                        break;
                      }
                    default:
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<OperationType>(
                    value: OperationType.sort,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.filter_list,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text('Sort'),
                      ],
                    ),
                  ),
                  PopupMenuItem<OperationType>(
                      value: OperationType.archive,
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
                  controller: controller.tabController,
                  children: List.generate(controller.sortItems.length, (index) => Text(index.toString()),),
                )),
          ],
          bottom: controller.isSearchMode
              ? TabBar(
            isScrollable: true,
            onTap: controller.onFilterTab,
            controller: controller.tabController,
            tabs: List.generate(
                controller.sortItems.length,
                    (index) => Tab(
                  child: Text(
                    controller.sortItems[index].label,
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
            await controller.createSupplier(context);
          },
          child: const Icon(Icons.add, color: AppColors.black),
        ),
        body: InkWell(
          splashColor: AppColors.transparent,
                highlightColor: AppColors.transparent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: HandleRequest(
                    statusView: controller.statusView,
                    child: controller.suppliers.isNotEmpty
                        ? SlidableAutoCloseBehavior(
                            closeWhenOpened: true,
                            child: ListView.builder(
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller.suppliers.length,
                              itemBuilder: (context, index) => Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.25,
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (c) async {
                                        await controller.showSheetUpdateSupplier(
                                            context,
                                            supplier:
                                                controller.suppliers[index]);
                                      },
                                      foregroundColor: AppColors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      backgroundColor: AppColors.success50,
                                      icon: Icons.edit_outlined,
                                    ),
                                  ],
                                ),
                                startActionPane: ActionPane(
                                  extentRatio: 0.25,
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (c) async {
                                        await controller.showDialogDeleteSupplier(
                                            context,
                                            supplier:
                                                controller.suppliers[index]);
                                      },
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      backgroundColor: AppColors.danger50,
                                      icon: Icons.delete_outlined,
                                    ),
                                  ],
                                ),
                                child: Card(
                                  child: ListTile(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      onTap: () {
                                        Get.toNamed(
                                            AppPagesRoutes.supplierDetailsScreen,
                                            arguments: {
                                              AppSharedKeys.passId:
                                                  controller.suppliers[index].id
                                            });
                                      },
                                      contentPadding: const EdgeInsets.only(
                                          top: 10, bottom: 10, right: 10),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: CircleAvatar(
                                                radius: 45,
                                                backgroundColor:
                                                    AppColors.primary0,
                                                child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl: controller.suppliers[index].photo,
                                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) => CircleAvatar(
                                                      radius: 42,
                                                      backgroundColor: AppColors.whiteSecondary,
                                                      child: Text('${controller.suppliers[index].name[0]}${controller.suppliers[index].name[1]}',
                                                          style: const TextStyle(
                                                              fontSize: 40,
                                                              fontWeight: FontWeight.bold,
                                                              color: AppColors.black
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller
                                                      .suppliers[index].name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          fontSize: 22,
                                                          letterSpacing: 1),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextIcon(
                                                  text: controller
                                                      .suppliers[index]
                                                      .phoneNumber,
                                                  icon: Icons.phone,
                                                ),
                                                TextIcon(
                                                  text: controller
                                                      .suppliers[index].address,
                                                  icon: Icons.location_on,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.event_available,
                                                    color: AppColors.primary70,
                                                    size: 20,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    ' ${controller.suppliers[index].invoicesTotal} \$',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .format_indent_decrease_sharp,
                                                    color: AppColors.primary70,
                                                    size: 20,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    ' ${controller.suppliers[index].debts} \$',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    AppAssets.invoiceIconSvg,
                                                    height: 20,
                                                    width: 20,
                                                    fit: BoxFit.fill,
                                                    color: AppColors.primary70,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    ' ${controller.suppliers[index].invoicesCount}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          )
                        : Empty(
                            imagePath: AppAssets.endOfList,
                            text: "No any Supplier",
                            height: 200,
                            fontSize: 24,
                          ),
                  ),
        )));
  }
}
