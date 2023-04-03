
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/details/product_details_controller.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/view/widget/shared/empty.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/section_tabs.dart';
import 'package:repository/view/widget/shared/text_icon.dart';
import 'package:repository/view/widget/shared/title_section.dart';

class ProductDetailsScreen extends GetView<ProductDetailsController> {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsController>(
        builder: (controller) => Scaffold(
              appBar: AppBar(
                title: Text(
                  "${controller.product.name} Product",
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      controller.productsController.mainController
                          .individualStocktaking(context,
                              stocktakingType: StocktakingType.product,
                              enabledSelect: false,
                              item: controller.product);
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
                            controller.productsController
                                .showSheetUpdateProduct(
                              context,
                              product: controller.product,
                              onSuccess: () async {
                                await controller.getProduct();
                              },
                            );
                            break;
                          }
                        case OperationType.delete:
                          {
                            controller.productsController
                                .showDialogDeleteProduct(
                              context,
                              product: controller.product,
                              onSuccess: () async {
                                Get.back();
                              },
                            );
                            break;
                          }
                        case OperationType.registers:
                          {
                            controller.getProductRegisters(context: context);
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
                      padding: const EdgeInsets.only(top: 8, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: controller.product.photo,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 35,
                                backgroundColor: AppColors.primary0,
                                child: Text(
                                    '${controller.product.name[0]}${controller.product.name[1]}',
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black)),
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
                                    controller.product.name,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Sale price: ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.gray,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        "${controller.product.salePrice} \$",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.primary50,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Buy price: ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.gray,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        "${controller.product.purchasePrice} \$",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.primary50,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${controller.product.amount}",
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Icons.event_available,
                                        color: AppColors.primary50,
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    "Amount",
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${controller.product.details.sales.length} ",
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Icons.trending_up,
                                        color: AppColors.primary50,
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    "Sales",
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${controller.product.details.purchases.length}",
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Icons.trending_down,
                                        color: AppColors.primary50,
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    "Buys",
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
                              tag: controller.product.id,
                              child: Container(
                                height: 0.8 * Get.width,
                                width: 0.8 * Get.width,
                                clipBehavior: Clip.hardEdge,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: controller.product.photo,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    radius: 36,
                                    backgroundColor: AppColors.primary0,
                                    child: Text(
                                        '${controller.product.name[0]}${controller.product.name[1]}',
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
                                  "${controller.product.amount}",
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
                                  "${controller.product.salePrice}",
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
                                  "${controller.product.purchasePrice}",
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
                        "Purchases",
                        "Sales",
                      ],
                      tabViewHeight: 0.7 * Get.width,
                      controller: controller.tabController,
                      onArrowPressed: null,
                      onTab: (index) {},
                      tabs: [
                        controller.product.details.purchases.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.product.details.purchases.length,
                                itemBuilder: (context, index) => Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {},
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
                                                controller
                                                    .product
                                                    .details
                                                    .purchases[index]
                                                    .supplierName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        fontSize: 22,
                                                        letterSpacing: 1),
                                              ),
                                              TextIcon(
                                                text: " ${controller.product.details.purchases[index].invoiceNumber}",
                                                icon: Icons.numbers,
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
                                                text: "${controller.product.details.purchases[index].amount}",
                                                icon: Icons.upload,
                                              ),
                                              TextIcon(
                                                text: " ${controller.product.details.purchases[index].totalPurchasePrice} \$",
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
                        controller.product.details.sales.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    controller.product.details.sales.length,
                                itemBuilder: (context, index) => Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {},
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
                                                controller.product.details
                                                    .sales[index].clientName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        fontSize: 22,
                                                        letterSpacing: 1),
                                              ),
                                              TextIcon(
                                                text:
                                                    " ${controller.product.details.sales[index].invoiceNumber}",
                                                icon: Icons.numbers,
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
                                                    "${controller.product.details.sales[index].amount}",
                                                icon: Icons.upload,
                                              ),
                                              TextIcon(
                                                text: " ${controller.product.details.sales[index].totalSalePrice} \$",
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
            ));
  }
}

class Tables extends StatelessWidget {
  const Tables({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 0.05 * Get.height,
        ),
        TitleSection(
          title: "Products",
        ),
        SizedBox(
          height: 0.01 * Get.height,
        ),
        Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 2 * Get.width,
                child: Table(
                  border: TableBorder.all(
                      width: 2,
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary30),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FractionColumnWidth(0.1),
                    1: FractionColumnWidth(0.1),
                    2: FractionColumnWidth(0.1),
                    3: FractionColumnWidth(0.1),
                    4: FractionColumnWidth(0.1),
                    5: FractionColumnWidth(0.1),
                  },
                  children: [
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Photo",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primary80,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Name",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primary80,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Sale Price",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primary80,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Bay Price",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primary80,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Sales Count",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primary80,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Bays Count",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primary80,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                    ...List.generate(
                        3,
                        (index) => TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  AppAssets.screen0,
                                  height: 0.08 * Get.height,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Oil"),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("250"),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("200"),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("105"),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("280"),
                              ),
                            ]))
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 0.05 * Get.height,
        ),
        TitleSection(
          title: "Latest Products",
        ),
        SizedBox(
          height: 0.01 * Get.height,
        ),
        Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 2 * Get.width,
                child: DataTable(
                    border: TableBorder.all(
                        width: 2,
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary30),
                    dataRowColor: MaterialStateProperty.all(AppColors.primary0),
                    headingTextStyle: const TextStyle(
                        fontSize: 20,
                        color: AppColors.danger50,
                        fontWeight: FontWeight.bold),
                    sortColumnIndex: 0,
                    sortAscending: false,
                    columns: const [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Sales")),
                      DataColumn(label: Text("Buys")),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text("Pizza")),
                        DataCell(Text("124")),
                        DataCell(Text("189")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Aizza")),
                        DataCell(Text("124")),
                        DataCell(Text("189")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Sizza")),
                        DataCell(Text("124")),
                        DataCell(Text("189")),
                      ])
                    ]),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 0.05 * Get.height,
        ),
      ],
    );
  }
}
