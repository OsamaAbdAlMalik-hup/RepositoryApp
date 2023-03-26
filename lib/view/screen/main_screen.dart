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
            Visibility(
              visible: controller.isSearchMode,
              child: SearchAppbar(
                hintText: "Search By name",
                controller: controller.searchFieldController,
                onChanged: (value) {
                  // controller.search(value);
                },
                onBackIconPressed: () {
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
                  HelperDesignFunctions.showAwesomeDialog(context,
                      body: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Shortcut Creation",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Divider(
                              thickness: 2,
                              height: 20,
                            ),
                            GridView(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
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
                                              height: 30,
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
                                              height: 30,
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
                                          size: 30,
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
                                          height: 30,
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
                                          height: 30,
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
                                          height: 30,
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
                                          height: 30,
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
                                          height: 30,
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
                                          height: 30,
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
                            ),

                          ],
                        ),
                      ));
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
                          selectedIndex:
                              controller.selectedBottomNavigationBarItem,
                          onDestinationSelected: (index) async {
                            await controller.onNavBarChange(index);
                          },
                          animationDuration: const Duration(milliseconds: 750),
                          destinations: bottomNavigationBarItems)
                    ],
                  ),
                )),
        body: WillPopScope(
          onWillPop: () async {
            bool canExit = controller.lastPressedGoBack != null &&
                DateTime.now().difference(controller.lastPressedGoBack!) > const Duration(seconds: 2);
            if(canExit) {
              return true;
            } else{
              Get.showSnackbar(const GetSnackBar(title: "Click back again to Exit",));
              return false;
            }
          },
          child: HandleRequest(
            statusView: controller.statusView,
            child: bottomNavigationBarPages[
                controller.selectedBottomNavigationBarItem],
          ),
        ),
      ),
    );
  }
}

/*
        leading: InkWell(
          onTap: () {
            controller.scaffoldKey.currentState!.openDrawer();
            // controller.test(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              AppAssets.logoIconSvg,
              height: 40,
              width: 40,
              fit: BoxFit.fill,
              color: AppColors.primary,
            ),
          ),
        ),

        BottomNavigationBar(
          selectedItemColor: AppColors.primaryDeepAccent,
          unselectedItemColor: AppColors.gray,
          currentIndex: controller.selectedBottomNavigationBarItem,
          onTap: (index) async {
            await controller.changeNavigationBar(index);
          },
          items: bottomNavigationBarItems,
        ),

 */

/*
ActionChip(
                                            label: const Text('Push'),
                                            avatar: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                SvgPicture.asset(
                                                  AppAssets.moneyIconSvg,
                                                  height: 28,
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
                                            padding: const EdgeInsets.all(8)
                                                .copyWith(left: 20),
                                            onPressed: () async {
                                              Get.back();
                                              await controller
                                                  .showSheetCreateCacheMoney(
                                                      context,
                                                      isPush: true);
                                            },
                                          ),
                                          ActionChip(
                                            label: const Text('Pull'),
                                            avatar: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                SvgPicture.asset(
                                                  AppAssets.moneyIconSvg,
                                                  height: 28,
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
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                right: 8,
                                                left: 20),
                                            onPressed: () async {
                                              Get.back();
                                              await controller
                                                  .showSheetCreateCacheMoney(
                                                      context,
                                                      isPush: false);
                                            },
                                          ),
                                          ActionChip(
                                            label: const Text('Expense'),
                                            avatar: const Icon(
                                              Icons.clean_hands,
                                              color: AppColors.primary60,
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            onPressed: () async {
                                              Get.back();
                                              await controller.showSheetCreateExpense(context);
                                            },
                                          ),
 */
