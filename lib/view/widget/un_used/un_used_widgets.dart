

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'package:repository/core/constant/app_assets.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/view/widget/shared/title_section.dart';

List columns=[];
List products=[];

class Notification extends StatelessWidget {
  const Notification({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                    width: 1, color: AppColors.primaryAccent),
                borderRadius:
                const BorderRadius.all(Radius.circular(10))),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: AppColors.primaryAccent,
            )),
        Positioned(
            left: -3,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.red,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.red,
                        blurRadius: 1,
                        offset: Offset(1, 1)),
                    BoxShadow(
                        color: AppColors.red,
                        blurRadius: 1,
                        offset: Offset(-1, 1)),
                    BoxShadow(
                        color: AppColors.red,
                        blurRadius: 1,
                        offset: Offset(-1, -1)),
                    BoxShadow(
                        color: AppColors.red,
                        blurRadius: 1,
                        offset: Offset(1, -1)),
                  ]),
            ))
      ],
    );
  }
}

class Tables extends StatelessWidget {
  const Tables({Key? key}) : super(key: key);

  Widget oldTable() {
    return LazyDataTable(
      columns: 6,
      rows: 50,
      tableTheme: const LazyDataTableTheme(
        columnHeaderColor: AppColors.blackAccentT,
        alternateColumnHeaderColor: AppColors.blackAccent,
        cellColor: AppColors.whiteSecondary,
        rowHeaderColor: AppColors.blackAccentT,
        alternateRowHeaderColor: AppColors.blackAccent,
        cornerColor: AppColors.blackAccentT,
        alternateColumn: true,
        cellBorder: Border.fromBorderSide(
            BorderSide(color: AppColors.primaryAccent200)),
        rowHeaderBorder: Border.fromBorderSide(
            BorderSide(color: AppColors.primaryAccent200)),
        columnHeaderBorder: Border.fromBorderSide(
            BorderSide(color: AppColors.primaryAccent200)),
        cornerBorder: Border.fromBorderSide(
            BorderSide(color: AppColors.primaryAccent200)),
        alternateCellBorder: Border.fromBorderSide(
            BorderSide(color: AppColors.primaryAccent200)),
        alternateRowHeaderBorder: Border.fromBorderSide(
            BorderSide(color: AppColors.primaryAccent200)),
        alternateColumnHeaderBorder: Border.fromBorderSide(
            BorderSide(color: AppColors.primaryAccent200)),
      ),
      tableDimensions: const LazyDataTableDimensions(
          cellHeight: 40,
          cellWidth: 150,
          topHeaderHeight: 40,
          leftHeaderWidth: 40),
      topLeftCornerWidget: const Center(
        child: Text(
          "#",
          style: TextStyle(
              fontSize: 20,
              color: AppColors.primaryAccent200,
              fontWeight: FontWeight.bold),
        ),
      ),
      topHeaderBuilder: (columnIndex) {
        return Center(
          child: Text(
            columns[columnIndex],
            style: const TextStyle(
                fontSize: 20,
                color: AppColors.primaryAccent200,
                fontWeight: FontWeight.bold),
          ),
        );
      },
      leftHeaderBuilder: (rowIndex) {
        return Center(
          child: Text(
            '$rowIndex',
            style: const TextStyle(
                fontSize: 20,
                color: AppColors.primaryAccent200,
                fontWeight: FontWeight.bold),
          ),
        );
      },
      dataCellBuilder: (rowIndex, columnIndex) {
        if (columnIndex == 0) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppPagesRoutes.productDetailsScreen);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                  fixedSize: const Size(150, 40)),
              child: Text(
                '${products[rowIndex]['Name']}',
                style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
        if (columnIndex == 1) {
          return Center(
              child: Text(
                '${products[rowIndex]['Sale price']}',
                style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold),
              ));
        }
        if (columnIndex == 2) {
          return Center(
              child: Text(
                '${products[rowIndex]['Buys price']}',
                style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold),
              ));
        }
        if (columnIndex == 3) {
          return Center(
              child: Text(
                '${products[rowIndex]['Amount']}',
                style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold),
              ));
        }
        if (columnIndex == 4) {
          return Center(
              child: Text(
                '${products[rowIndex]['Sales Count']}',
                style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold),
              ));
        }
        return Center(
            child: Text(
              '${products[rowIndex]['Buys Count']}',
              style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold),
            ));
      },
    );
  }

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
                      color: AppColors.primaryAccent200),
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
                              color: AppColors.primaryDeep,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Name",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryDeep,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Sale Price",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryDeep,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Bay Price",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryDeep,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Sales Count",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryDeep,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Bays Count",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryDeep,
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
                              AppAssets.screen10,
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
                        color: AppColors.primaryAccent200),
                    dataRowColor:
                    MaterialStateProperty.all(AppColors.whiteSecondary),
                    headingTextStyle: const TextStyle(
                        fontSize: 20,
                        color: AppColors.red,
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

/*
  void individualStocktakingOld(BuildContext context,
      {required StocktakingType stocktakingType,
      bool enabledSelect = true,
      dynamic item}) async {
    startDate = HelperDesignFunctions.formatDate(
        DateTime.now().subtract(const Duration(days: 30)));
    endDate = HelperDesignFunctions.formatDate(DateTime.now());
    String type = 'Category';
    List items = [];
    switch (stocktakingType) {
      case StocktakingType.category:
        {
          // categories = await mainApiController.getCategoriesNames();
          items = categories;
          selectedItem = categories.take(1);
          type = 'Category';
          break;
        }
      case StocktakingType.product:
        {
          // products = await mainApiController.getProductsNames();
          items = products;
          selectedItem = products.take(1);
          type = 'Product';
          break;
        }
      case StocktakingType.client:
        {
          // clients = await mainApiController.getClientsNames();
          items = clients;
          selectedItem = clients.take(1).first;
          type = 'Client';
          break;
        }
      case StocktakingType.supplier:
        {
          // suppliers = await mainApiController.getSuppliersNames();
          items = suppliers;
          selectedItem = suppliers.take(1);
          type = 'Supplier';
          break;
        }
    }
    if (enabledSelect) {
      selectedItem = items.take(1);
    } else {
      selectedItem = item;
    }
    HelperLogicFunctions.printNote(type);
    // showAwesomeDialog(context,
    //     btnOkOnPress: (){
    //       Get.toNamed(AppPagesRoutes.individualStocktaking,
    //           arguments: {
    //             AppSharedKeys.passStocktakingType:stocktakingType,
    //             AppSharedKeys.passId:selectedItem.id,
    //             AppSharedKeys.passFromDate:startDate,
    //             AppSharedKeys.passToDate:endDate,
    //           }
    //       );
    //     },
    //     btnCancelOnPress: () {},
    //     body: GetBuilder<MainController>(
    //       builder: (controller) => Container(
    //         height: 0.3 * Get.height,
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           children: [
    //             Text(
    //               "$type Stocktaking",
    //               style: const TextStyle(
    //                   color: AppColors.black,
    //                   fontSize: 25,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //             const SizedBox(height: 15),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     const Text(
    //                       ' From: ',
    //                       style: TextStyle(fontSize: 14,color: AppColors.gray, fontWeight: FontWeight.bold),
    //                     ),
    //                     ActionChip(
    //                       label: Text(controller.startDate),
    //                       labelStyle: const TextStyle(fontSize: 16, color: AppColors.primary),
    //                       side: const BorderSide(color: AppColors.primary, width: 2),
    //                       backgroundColor: AppColors.whiteSecondary,
    //                       onPressed: () async{
    //                         String? date=await choseDate(context);
    //                         if(date!=null){
    //                           controller.startDate=date;
    //                           controller.update();
    //                         }
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     const Text(
    //                       ' To: ',
    //                       style: TextStyle(fontSize: 14,color: AppColors.gray, fontWeight: FontWeight.bold),
    //                     ),
    //                     ActionChip(
    //                       label: Text(controller.endDate),
    //                       labelStyle:
    //                       const TextStyle(fontSize: 16, color: AppColors.primary),
    //                       side: const BorderSide(color: AppColors.primary, width: 2),
    //                       backgroundColor: AppColors.whiteSecondary,
    //                       onPressed: () async{
    //                         String? date=await choseDate(context);
    //                         if(date!=null){
    //                           controller.endDate=date;
    //                           controller.update();
    //                         }
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             const SizedBox(height: 15),
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: DropdownSearch<dynamic>(
    //                 enabled: enabledSelect,
    //                 popupProps: PopupProps.menu(
    //                   showSearchBox: true,
    //                   itemBuilder: (context, item, isSelected) =>
    //                       Container(
    //                         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    //                         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //                         decoration: BoxDecoration(
    //                             color: AppColors.primaryAccent201,
    //                             borderRadius: BorderRadius.circular(10)
    //                         ),
    //                         child: Text(
    //                           item.name,
    //                           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    //                         ),
    //                       ),
    //
    //                 ),
    //                 dropdownDecoratorProps: DropDownDecoratorProps(
    //                   dropdownSearchDecoration: InputDecoration(
    //                       labelText: type,
    //                       border: const OutlineInputBorder(
    //                           borderSide: BorderSide(
    //                               color: Colors.blue, width: 2))),
    //                 ),
    //                 items: items,
    //                 selectedItem: selectedItem,
    //                 dropdownBuilder: (context, selectedItem) => Text(
    //                     selectedItem != null ? selectedItem.name : "Chose"),
    //                 compareFn: (item1, item2) => true,
    //                 itemAsString: (item) => item.name,
    //                 onChanged: (value) {
    //                   selectedItem = value;
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),));
  }

 */
