
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:repository/controller/screens/main_screen/operation_invoice_controller.dart';
import 'package:repository/core/constant/app_colors.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/constant/app_pages_routes.dart';
import 'package:repository/core/helper/design_functions.dart';
import 'package:repository/core/helper/validator_functions.dart';
import 'package:repository/data/models/client.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/supplier.dart';
import 'package:repository/view/widget/shared/handle_request.dart';
import 'package:repository/view/widget/shared/text_icon.dart';

class OperationsInvoiceScreen extends GetView<OperationsInvoiceController> {
  const OperationsInvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            controller.getTitle(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.remained =
                double.parse(controller.totalFieldController.text);
            if (controller.selectedPairProducts.isNotEmpty) {
              HelperDesignFunctions.showAlertDialog(context,
                  btnOkOnPress: () {
                    if (controller.operationType == OperationType.create) {
                      controller.createInvoice();
                    } else {
                      controller.updateInvoice();
                    }
                  },
                  title: "Sort Invoices",
                  children: [
                    GetBuilder<OperationsInvoiceController>(
                      builder: (controller) => Form(
                        key: controller.formKeySaveInvoice,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary50),
                                ),
                                Text(
                                  "${controller.totalFieldController.text} \$",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Reminder",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary50),
                                ),
                                Text(
                                  "${controller.remained} \$",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Paid Money',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  double paid = 0;

                                  if (value != '' && GetUtils.isNum(value)) {
                                    paid = double.parse(value);
                                  }
                                  double total = double.parse(
                                      controller.totalFieldController.text);
                                  controller.remained = total - paid;
                                  controller.update();
                                },
                                controller: controller.paidMoneyFieldController,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  String? message = Validate.valid(text!,
                                      type: Validate.positiveNum,
                                      maxVal: double.parse(controller
                                          .totalFieldController.text));
                                  if (message == null &&
                                      controller.invoiceType !=
                                          InvoiceType.sales &&
                                      double.parse(text) >
                                          controller
                                              .mainController.totalMoneyBox) {
                                    return 'Money not enough to buy ${controller.mainController.totalMoneyBox} \$';
                                  }
                                  return message;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]
              );
            } else {
              HelperDesignFunctions.showErrorSnackBar(
                  message: "you must add sales");
            }
          },
          child: const Icon(Icons.save, color: AppColors.black),
        ),
        body: GetBuilder<OperationsInvoiceController>(
          builder: (controller) => HandleRequest(
            statusView: controller.statusView,
            child: Padding(
              padding: const EdgeInsets.all(15).copyWith(bottom: 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'invoice date',
                            ),
                            keyboardType: TextInputType.number,
                            controller:
                                controller.mainController.dateFieldController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            readOnly: true,
                            onTap: () async {
                              String? date =
                                  await HelperDesignFunctions.choseDate(context);
                              if (date != null) {
                                controller.mainController.dateFieldController
                                    .text = date;
                                controller.update();
                              }
                            },
                            validator: (text) {
                              return Validate.valid(text!);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Total',
                            ),
                            keyboardType: TextInputType.number,
                            controller: controller.totalFieldController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            readOnly: true,
                            enabled: false,
                            validator: (text) {
                              return Validate.valid(text!);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: controller.invoiceType == InvoiceType.sales,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<Client>(
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                itemBuilder: (context, item, isSelected) =>
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      child: Card(
                                        color: AppColors.primary0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )
                                ),
                              ),
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                    labelText: "Chose Client",
                                ),
                              ),
                              itemAsString: (item) => item.name,
                              compareFn: (item1, item2) => true,
                              selectedItem: controller.mainController.selectedClient,
                              items: controller.mainController.clients,
                              onChanged: (value) {
                                controller.mainController.selectedClient = value!;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () {
                                  controller.mainController.showSheetCreateClientOrSupplier(context, isClient: true);
                                }, icon: const Icon(Icons.add)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.invoiceType == InvoiceType.purchases,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<Supplier>(
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                itemBuilder: (context, item, isSelected) =>
                                    Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                        child: Card(
                                          color: AppColors.primary0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              item.name,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                    ),
                              ),
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Chose Suppler",
                                ),
                              ),
                              itemAsString: (item) => item.name,
                              compareFn: (item1, item2) => true,
                              selectedItem: controller.mainController.selectedSupplier,
                              items: controller.mainController.suppliers,
                              onChanged: (value) {
                                controller.mainController.selectedSupplier =
                                value!;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () {
                                  controller.mainController.showSheetCreateClientOrSupplier(context, isClient: false);
                                }, icon: const Icon(Icons.add)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<Product>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, item, isSelected) =>
                                  Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      child: Card(
                                        color: AppColors.primary0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )
                                  ),
                            ),
                            dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Chose Product",
                              ),
                            ),
                            itemAsString: (item) => item.name,
                            compareFn: (item1, item2) => true,
                            onChanged: (value) {
                              controller.selectedProduct = value!;
                              controller.paidMoneyFieldController.clear();
                              controller.mainController.totalPriceFieldController.clear();
                              HelperDesignFunctions.showAlertDialog(context,
                                  btnOkOnPress: () {
                                    controller.addProduct(value);
                                  },
                                  title: "Adding ${controller.invoiceType == InvoiceType.sales ? 'Sale' : 'Purchase'}",
                                  children: [
                                    Form(
                                      key: controller.formKeyAddProduct,
                                      child: Column(
                                        children: [
                                          Text(
                                            controller.selectedProduct.name,
                                            style: const TextStyle(
                                                color: AppColors.primary50,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${controller.selectedProduct.salePrice} \$",
                                                      style: const TextStyle(
                                                          color: AppColors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "${controller.invoiceType == InvoiceType.sales ? 'Sale' : 'Purchase'} Price",
                                                      style: const TextStyle(
                                                          color: AppColors.gray,
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const VerticalDivider(
                                                  thickness: 3,
                                                  width: 10,
                                                  color: AppColors.black,
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${controller.selectedProduct.amount}",
                                                      style: const TextStyle(
                                                          color: AppColors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Text(
                                                      "Available",
                                                      style: TextStyle(
                                                          color: AppColors.gray,
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                labelText:
                                                '${controller.invoiceType == InvoiceType.sales ? 'Sale' : 'Purchase'} Amount',
                                                border: const OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10)),
                                                )),
                                            autofocus: true,
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: controller.mainController
                                                .totalPriceFieldController,
                                            validator: (text) {
                                              String? message = Validate.valid(
                                                  text!,
                                                  type: Validate.positiveNum,
                                                  maxVal:
                                                  controller.invoiceType ==
                                                      InvoiceType.sales
                                                      ? controller
                                                      .selectedProduct
                                                      .amount
                                                      : double.infinity);
                                              if (message == null &&
                                                  controller.invoiceType !=
                                                      InvoiceType.sales &&
                                                  double.parse(text) >
                                                      controller.mainController
                                                          .totalMoneyBox) {
                                                return 'Money not enough to buy ${controller.mainController.totalMoneyBox} \$';
                                              }
                                              return message;
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ]
                              );
                            },
                            items: controller.unselectedProducts,
                            selectedItem: controller.selectedProduct,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () {
                                controller.mainController.showSheetCreateProduct(context);
                              }, icon: const Icon(Icons.add)),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: controller.selectedPairProducts.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        startActionPane: ActionPane(
                          extentRatio: 0.25,
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (c) async {
                                HelperDesignFunctions.showAlertDialog(context,
                                    btnOkOnPress: () async {
                                      controller.deleteProduct(index);
                                    },
                                    title: "Delete Product",
                                    subTitle: "Are you sure from delete ${controller.selectedPairProducts[index].first.name}  !",
                                    okText: "Delete",
                                    dialogType: "delete",
                                );
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
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
                              onPressed: (c) {
                                controller.mainController.totalPriceFieldController.text =
                                    controller.selectedPairProducts[index].second.toString();
                                HelperDesignFunctions.showAlertDialog(context,
                                    btnOkOnPress: () {
                                      controller.updateProduct(index);
                                    },
                                    title: "Update ${controller.invoiceType == InvoiceType.sales ? 'Sale' : 'Purchase'}",
                                    children: [
                                      Form(
                                        key: controller.formKeyUpdateProduct,
                                        child: Column(
                                          children: [
                                            Text(
                                              controller.selectedPairProducts[index].first.name,
                                              style: const TextStyle(
                                                  color: AppColors.primary50,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        controller.invoiceType ==
                                                            InvoiceType.sales
                                                            ? "${controller.selectedPairProducts[index].first.salePrice} \$"
                                                            : "${controller.selectedPairProducts[index].first.purchasePrice} \$",
                                                        style: const TextStyle(
                                                            color: AppColors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${controller.invoiceType == InvoiceType.sales ? 'Sale' : 'Purchase'} Price",
                                                        style: const TextStyle(
                                                            color: AppColors.gray,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const VerticalDivider(
                                                    thickness: 3,
                                                    width: 10,
                                                    color: AppColors.black,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "${controller.selectedPairProducts[index].first.amount}",
                                                        style: const TextStyle(
                                                            color: AppColors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Text(
                                                        "Available",
                                                        style: TextStyle(
                                                            color: AppColors.gray,
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                  labelText: 'Sale Amount',
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)),
                                                  )),
                                              autofocus: true,
                                              keyboardType: TextInputType.number,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: controller.mainController
                                                  .totalPriceFieldController,
                                              validator: (text) {
                                                String? message = Validate.valid(
                                                    text!,
                                                    type: Validate.positiveNum,
                                                    maxVal: controller
                                                        .invoiceType ==
                                                        InvoiceType.sales
                                                        ? controller
                                                        .selectedPairProducts[
                                                    index]
                                                        .first
                                                        .amount
                                                        : double.infinity);
                                                if (message == null &&
                                                    controller.invoiceType !=
                                                        InvoiceType.sales &&
                                                    double.parse(text) >
                                                        controller.mainController
                                                            .totalMoneyBox) {
                                                  return 'Money not enough to buy ${controller.mainController.totalMoneyBox} \$';
                                                }
                                                return message;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                );
                              },
                              foregroundColor: AppColors.white,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                              backgroundColor: AppColors.success50,
                              icon: Icons.edit_outlined,
                            ),
                          ],
                        ),
                        child: Card(
                            child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Get.toNamed(AppPagesRoutes.invoiceDetailsScreen);
                          },
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '#${index + 1}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            controller.selectedPairProducts[index]
                                                .second
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      )),
                                  const VerticalDivider(thickness: 1),
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.selectedPairProducts[index]
                                                .first.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    fontSize: 18,
                                                    letterSpacing: 1),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextIcon(
                                                text: (controller.invoiceType ==
                                                            InvoiceType.sales
                                                        ? controller
                                                            .selectedPairProducts[
                                                                index]
                                                            .first
                                                            .salePrice
                                                        : controller
                                                            .selectedPairProducts[
                                                                index]
                                                            .first
                                                            .purchasePrice)
                                                    .toString(),
                                                color: AppColors.black,
                                                icon: Icons.money_off,
                                              ),
                                              TextIcon(
                                                text: (controller.invoiceType ==
                                                            InvoiceType.sales
                                                        ? controller
                                                                .selectedPairProducts[
                                                                    index]
                                                                .first
                                                                .salePrice *
                                                            controller
                                                                .selectedPairProducts[
                                                                    index]
                                                                .second
                                                        : controller
                                                                .selectedPairProducts[
                                                                    index]
                                                                .first
                                                                .purchasePrice *
                                                            controller
                                                                .selectedPairProducts[
                                                                    index]
                                                                .second)
                                                    .toString(),
                                                color: AppColors.black,
                                                icon:
                                                    Icons.monetization_on_rounded,
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
                      );
                    },
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
