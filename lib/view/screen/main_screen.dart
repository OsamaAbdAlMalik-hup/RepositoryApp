
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/data/static/home_data.dart';
import 'package:repository/view/widget/home/drawer.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/search_appbar.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) => Scaffold(
        key: controller.scaffoldKey,
        drawer: const DrawerContentHome(),
        appBar: AppBar(
          title: !controller.isSearchMode
              ? const Text(
                  'Repo',
                )
              : null,
          leading: Visibility(
            visible: !controller.isSearchMode,
            child: IconButton(
                onPressed: () {
                  controller.scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu)),
          ),
          actions: [
            // TODO Enable Life Search
            Visibility(
              visible: controller.isSearchMode,
              child: SearchAppbar(
                hintText: "Search By name",
                controller: controller.searchFieldController,
                onChanged: (value) {
                  // controller.search(value);
                },
                onBackIconPressed: () async {
                  controller.isSearchMode = false;
                  controller.update();
                },
                onSearchIconPressed: () {},
              ),
            ),
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
                  HelperDesignFunctions.showFormDialog(context,
                      title: "Shortcut Creation",
                      hasButtonsAction: false,
                      children: [
                        GridView(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 30
                          ),
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async {
                                Get.back();
                                controller.showSheetCreateCacheMoney(context, isPush: true);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: AppColors.primary90)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.moneyIconSvg,
                                          height: 45,
                                          color: AppColors.primary60,
                                        ),
                                        const Positioned(
                                            left: -15,
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: AppColors.primary60,
                                              size: 20,
                                            )),
                                      ],
                                    ),
                                    const Text(
                                      "Push",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColors.primary90),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async {
                                Get.back();
                                controller.showSheetCreateCacheMoney(context, isPush: false);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: AppColors.primary90)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.moneyIconSvg,
                                          height: 45,
                                          color: AppColors.primary60,
                                        ),
                                        const Positioned(
                                            left: -15,
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: AppColors.primary60,
                                              size: 20,
                                            )),
                                      ],
                                    ),
                                    const Text(
                                      "Pull",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.primary90),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async{
                                Get.back();
                                controller.showSheetCreateExpense(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: AppColors.primary90)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Icon(
                                      Icons.clean_hands,
                                      color: AppColors.primary60,
                                      size: 45,
                                    ),
                                    Text(
                                      "Expense",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.primary90),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async{
                                Get.back();
                                Get.toNamed(
                                    AppPagesRoutes
                                        .operationOnInvoiceScreen,
                                    arguments: {
                                      AppSharedKeys.passInvoiceType: InvoiceType.sales,
                                      AppSharedKeys.passOperationType: OperationType.create
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: AppColors.primary90)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      height: 45,
                                      AppAssets.invoiceIconSvg,
                                      color: AppColors.primary60,
                                    ),
                                    const Text(
                                      "Sales",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.primary90),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async{
                                Get.back();
                                Get.toNamed(
                                    AppPagesRoutes
                                        .operationOnInvoiceScreen,
                                    arguments: {
                                      AppSharedKeys.passInvoiceType: InvoiceType.purchases,
                                      AppSharedKeys.passOperationType: OperationType.create
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: AppColors.primary90)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      height: 45,
                                      AppAssets.invoiceIconSvg,
                                      color: AppColors.primary60,
                                    ),
                                    const Text(
                                      "Purchase",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.primary90),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async{
                                Get.back();
                                controller.showDialogCreateCategory(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: AppColors.primary90)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      height: 45,
                                      AppAssets.categoriesIconSvg,
                                      color: AppColors.primary60,
                                    ),
                                    const Text(
                                      "Category",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.primary90),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async{
                                Get.back();
                                controller.showSheetCreateProduct(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: AppColors.primary90)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      height: 45,
                                      AppAssets.productsIconSvg,
                                      color: AppColors.primary60,
                                    ),
                                    const Text(
                                      "Product",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.primary90),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async{
                                Get.back();
                                controller.showSheetCreateClientOrSupplier(context,isClient: true);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: AppColors.primary90)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      height: 45,
                                      AppAssets.clientsIconSvg,
                                      color: AppColors.primary60,
                                    ),
                                    const Text(
                                      "Client",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.primary90),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async{
                                Get.back();
                                controller.showSheetCreateClientOrSupplier(context,isClient: false);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: AppColors.primary90)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      height: 45,
                                      AppAssets.suppliersIconSvg,
                                      color: AppColors.primary60,
                                    ),
                                    const Text(
                                      "Supplier",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.primary90),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ]
                  );
                },
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: GetBuilder<MainController>(
            builder: (controller) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: controller.isVisibleNav ? 60 : 0,
                  child: Wrap(
                    children: [
                      NavigationBar(
                          selectedIndex: controller.selectedBottomNavigationBarItem,
                          onDestinationSelected: (index) async {
                            await controller.onNavBarChange(index);
                          },
                          animationDuration: const Duration(milliseconds: 750),
                          destinations: bottomNavigationBarItems
                      )
                    ],
                  ),
                )),
        body: WillPopScope(
          onWillPop: controller.alertExit,
          child: HandleRequest(
            statusView: controller.statusView,
            child: bottomNavigationBarPages[controller.selectedBottomNavigationBarItem],
          ),
        ),
      ),
    );
  }
}
