
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/clients_controller.dart';
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

class ClientsScreen extends GetView<ClientsController> {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientsController>(
        builder: (controller) => Scaffold(
            appBar: AppBar(
              title: !controller.isSearchMode
                  ? const Text(
                      'Clients',
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
                            await controller.sort(controller.allClients);
                          },
                          title: "Sort Clients",
                          children: [
                            SortDialog<ClientsController>(
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
                      children: List.generate(controller.searchItem.length, (index) => Text(index.toString()),),
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
                await controller.createClient(context);
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
                  child: controller.clients.isNotEmpty
                      ? SlidableAutoCloseBehavior(
                          closeWhenOpened: true,
                          child: ListView.builder(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.clients.length,
                            itemBuilder: (context, index) => Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.25,
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (c) {
                                      controller.showSheetUpdateClient(context,
                                          client: controller.clients[index]);
                                    },
                                    foregroundColor: AppColors.white,
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
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
                                      await controller.showDialogDeleteClient(
                                          context,
                                          client: controller.clients[index]);
                                    },
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                    backgroundColor: AppColors.danger50,
                                    icon: Icons.delete_outlined,
                                  ),
                                ],
                              ),
                              child: Card(
                                child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    onTap: () {
                                      Get.toNamed(
                                          AppPagesRoutes.clientDetailsScreen,
                                          arguments: {
                                            AppSharedKeys.passId:
                                                controller.clients[index].id
                                          });
                                    },
                                    contentPadding:
                                        const EdgeInsets.all(10).copyWith(left: 0),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundImage: CachedNetworkImageProvider(
                                              controller.clients[index].photo,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.clients[index].name,
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
                                                    .clients[index].phoneNumber,
                                                icon: Icons.phone,
                                              ),
                                              TextIcon(
                                                text: controller
                                                    .clients[index].address,
                                                icon: Icons.location_on,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding:
                                          const EdgeInsets.only(top: 15, left: 15),
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
                                                  ' ${controller.clients[index].invoicesTotal} \$',
                                                  overflow: TextOverflow.ellipsis,
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
                                                  ' ${controller.clients[index].debts} \$',
                                                  overflow: TextOverflow.ellipsis,
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
                                                  ' ${controller.clients[index].invoicesCount}',
                                                  overflow: TextOverflow.ellipsis,
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
                          text: "No any Client",
                          height: 200,
                          fontSize: 24,
                        ),
                ),
              ),
            )));
  }
}