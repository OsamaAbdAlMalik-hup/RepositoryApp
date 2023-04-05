
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/constant/app_shared_keys.dart';
import 'package:repository/view/widget/shared/empty.dart';
import 'package:repository/view/widget/shared/section_tabs.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class MonitoringPage extends GetView<MainController> {
  const MonitoringPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        builder: (controller) => NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            return controller.onNotification(notification);
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            children: [
              SectionTabs(
                title: "Least Invoices",
                tabsTitles: const [
                  "Purchases",
                  "Sales",
                  "Expenses",
                ],
                tabViewHeight: controller.invoicesHeight,
                controller: controller.tabLatestInvoiceController,
                onArrowPressed: controller.onArrowLatestInvoiceTabPressed,
                onTab: controller.onLatestInvoiceTabChange,
                tabs: [
                  controller.monitoring.leastPurchasesInvoices.isNotEmpty?
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemCount: controller.monitoring.leastPurchasesInvoices.length,
                    itemBuilder: (context, index) => Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: IntrinsicHeight(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              Get.toNamed(AppPagesRoutes.invoiceDetailsScreen,arguments: {AppSharedKeys.passId:controller.monitoring.leastPurchasesInvoices[index].id,AppSharedKeys.passInvoiceType:InvoiceType.purchases});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "# ${controller.monitoring.leastPurchasesInvoices[index].number}",
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          Text(
                                            controller.monitoring.leastPurchasesInvoices[index].date,
                                            style: Theme.of(
                                                context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      )),
                                  const VerticalDivider(thickness: 1),
                                  Expanded(
                                      flex: 5,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.monitoring.leastPurchasesInvoices[index].supplierName,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: AppColors.black,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              TextIcon(
                                                text: controller.monitoring.leastPurchasesInvoices[index].totalPrice.toString(),
                                                color: AppColors.black,
                                                icon: Icons
                                                    .monetization_on_rounded,
                                              ),
                                              TextIcon(
                                                text: controller.monitoring.leastPurchasesInvoices[index].remained.toString(),
                                                color: AppColors.black,
                                                icon: Icons.money_off,
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ):
                  Empty(
                    imagePath: AppAssets.noInvoices,
                    text: "No any purchases invoice",
                  ),
                  controller.monitoring.leastSalesInvoices.isNotEmpty?
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemCount: controller.monitoring.leastSalesInvoices.length,
                    itemBuilder: (context, index) => Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: IntrinsicHeight(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              Get.toNamed(AppPagesRoutes.invoiceDetailsScreen,arguments: {AppSharedKeys.passId:controller.monitoring.leastSalesInvoices[index].id,AppSharedKeys.passInvoiceType:InvoiceType.sales});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "# ${controller.monitoring.leastSalesInvoices[index].number}",
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          Text(
                                            controller.monitoring.leastSalesInvoices[index].date,
                                            style: Theme.of(
                                                context)
                                                .textTheme
                                                .bodySmall,),
                                        ],
                                      )),
                                  const VerticalDivider(thickness: 1),
                                  Expanded(
                                      flex: 5,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.monitoring.leastSalesInvoices[index].clientName,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: AppColors.black,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              TextIcon(
                                                text: controller.monitoring.leastSalesInvoices[index].totalPrice.toString(),
                                                color: AppColors.black,
                                                icon: Icons
                                                    .monetization_on_rounded,
                                              ),
                                              TextIcon(
                                                text: controller.monitoring.leastSalesInvoices[index].remained.toString(),
                                                color: AppColors.black,
                                                icon: Icons.money_off,
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ):
                  Empty(
                    imagePath: AppAssets.noInvoices,
                    text: "No any sales invoice",
                  ),
                  controller.monitoring.leastExpenses.isNotEmpty?
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemCount: controller.monitoring.leastExpenses.length,
                    itemBuilder: (context, index) => Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                          },
                          child: Padding(
                            padding:
                            const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Icon(
                                    size: 28,
                                    Icons.clean_hands,
                                    color: AppColors.primary70,
                                  ),
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              controller.monitoring.leastExpenses[index].name,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${controller.monitoring.leastExpenses[index].totalPrice} \$",
                                              style: const TextStyle(
                                                  color: AppColors.primary80,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                const Icon(
                                                  Icons.date_range,
                                                  color: AppColors.primary70,
                                                  size: 18,
                                                ),
                                                Text(
                                                  " ${controller.monitoring.leastExpenses[index].date}",
                                                  style: const TextStyle(
                                                      color: AppColors.gray,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        )),
                  ):
                  Empty(
                    imagePath: AppAssets.noExpenses,
                    text: "No any expense",
                  ),
                ],
              ),
              // TODO Change design and data of it
              SectionTabs(
                title: "Popular People",
                tabsTitles: const [
                  "Clients",
                  "Suppliers",
                ],
                tabViewHeight: 0.6 * Get.width,
                controller: controller.tabPopularPeopleController,
                onArrowPressed: controller.onArrowPopularPeopleTabPressed,
                onTab: controller.onPopularPeopleTabChange,
                tabs: [
                  controller.monitoring.mostPopularClients.isNotEmpty?
                  ListView.builder(
                    itemCount: controller.monitoring.mostPopularClients.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Get.toNamed(AppPagesRoutes.clientDetailsScreen,arguments: {AppSharedKeys.passId:controller.monitoring.mostPopularClients[index].id});
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Column(
                          children: [
                            Container(
                                height: 150,
                                width: 150,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary10,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 3),
                                          spreadRadius: 0,
                                          blurRadius: 5,
                                          color: AppColors.gray),
                                    ]),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: controller.monitoring.mostPopularClients[index].photo,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => CircleAvatar(
                                    radius: 42,
                                    backgroundColor: AppColors.primary10,
                                    child: Text('${controller.monitoring.mostPopularClients[index].name[0]}${controller.monitoring.mostPopularClients[index].name[1]}',
                                        style:const TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: AppColors.primary60)),
                                  ),
                                )
                            ),
                            SizedBox(
                              height: 0.01 * Get.height,
                            ),
                            Text(
                              controller.monitoring.mostPopularClients[index].name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ):
                  Empty(
                    imagePath: AppAssets.endOfList,
                    text: "No any Supplier",
                  ),
                  controller.monitoring.mostPopularSuppliers.isNotEmpty?
                  ListView.builder(
                    itemCount: controller.monitoring.mostPopularSuppliers.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(AppPagesRoutes.supplierDetailsScreen,arguments: {AppSharedKeys.passId:controller.monitoring.mostPopularSuppliers[index].id});
                        },
                        child: Column(
                          children: [
                            Container(
                                height: 150,
                                width: 150,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary20,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 3),
                                          spreadRadius: 0,
                                          blurRadius: 5,
                                          color: AppColors.gray),
                                    ]),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: controller.monitoring.mostPopularSuppliers[index].photo,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => CircleAvatar(
                                    radius: 42,
                                    backgroundColor: AppColors.primary0,
                                    child: Text('${controller.monitoring.mostPopularSuppliers[index].name[0]}${controller.monitoring.mostPopularSuppliers[index].name[1]}',
                                        style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.black
                                        )
                                    ),
                            ),),
                            ),
                            SizedBox(
                              height: 0.01 * Get.height,
                            ),
                            Text(
                              controller.monitoring.mostPopularSuppliers[index].name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ):
                  Empty(
                    imagePath: AppAssets.endOfList,
                    text: "No any Client",
                  ),
                ],
              ),
              SectionTabs(
                title: "Products",
                tabsTitles: const [
                  "Most Benefit",
                  "Least Amount",
                ],
                tabViewHeight: 0.8 * Get.width,
                controller: controller.tabProductsController,
                onArrowPressed: controller.onArrowProductsTabPressed,
                onTab: controller.onProductsTabChange,
                tabs: [
                  controller.monitoring.mostSaleProducts.isNotEmpty?
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: controller.monitoring.mostSaleProducts.isEmpty?0:0.3 * Get.height,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15 ),
                      itemCount: controller.monitoring.mostSaleProducts.length,
                      itemBuilder: (context, index) => SizedBox(
                        width: 0.6 * Get.width,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Get.toNamed(AppPagesRoutes.productDetailsScreen,arguments: {AppSharedKeys.passId:controller.monitoring.leastAmountProducts[index].id});
                            },
                            child: Column(
                              children: [
                                Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      height: 0.2 * Get.height,
                                      width: 0.6 * Get.width,
                                      imageUrl: controller.monitoring.mostSaleProducts[index].photo,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => CircleAvatar(
                                        radius: 42,
                                        backgroundColor: AppColors.primary10,
                                        child: Text('${controller.monitoring.mostSaleProducts[index].name[0]}${controller.monitoring.mostSaleProducts[index].name[1]}',
                                            style:const TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: AppColors.primary60)),
                                      ),
                                    )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.monitoring.mostSaleProducts[index].name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(controller.monitoring.mostSaleProducts[index].categoryName),
                                          TextIcon(
                                            text: (controller.monitoring.mostSaleProducts[index].salePrice
                                                -controller.monitoring.mostSaleProducts[index].purchasePrice).toString(),
                                            icon: Icons.trending_up,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ):
                  Empty(
                    imagePath: AppAssets.noOrder,
                    text: "No any Product",
                  ),
                  controller.monitoring.leastAmountProducts.isNotEmpty?
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: controller.monitoring.leastAmountProducts.isEmpty?0
                        :controller.monitoring.leastAmountProducts.length<=2?0.25 * Get.height
                        :0.55 * Get.height,
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.monitoring.leastAmountProducts.length,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8),
                        itemBuilder: (context, index) => Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Get.toNamed(AppPagesRoutes.productDetailsScreen,arguments: {AppSharedKeys.passId:controller.monitoring.mostSaleProducts[index].id});
                            },
                            child: Column(
                              children: [
                                Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: controller.monitoring.leastAmountProducts[index].photo,
                                      height: 0.15 * Get.height,
                                      width: 0.5 * Get.width,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => CircleAvatar(
                                        radius: 42,
                                        backgroundColor: AppColors.primary10,
                                        child: Text('${controller.monitoring.mostPopularClients[index].name[0]}${controller.monitoring.mostPopularClients[index].name[1]}',
                                            style:const TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: AppColors.primary60)),
                                      ),
                                    )
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.monitoring.leastAmountProducts[index].name,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 0.01 * Get.height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextIcon(
                                            text: controller.monitoring.leastAmountProducts[index].amount.toString(),
                                            icon: Icons.do_not_disturb_on_total_silence,
                                          ),
                                          Text(
                                            controller.monitoring.leastAmountProducts[index].categoryName,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.gray,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ):
                  Empty(
                    imagePath: AppAssets.noOrder,
                    text: "No any Product",
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}

