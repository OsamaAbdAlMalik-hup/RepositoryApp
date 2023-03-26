

import 'package:get/get.dart';
import 'package:repository/controller/screens/registration_controller.dart';
import 'package:repository/controller/screens/details/category_details_controller.dart';
import 'package:repository/controller/screens/details/client_details_controller.dart';
import 'package:repository/controller/screens/details/invoice_details_controller.dart';
import 'package:repository/controller/screens/details/product_details_controller.dart';
import 'package:repository/controller/screens/details/supplier_details_controller.dart';
import 'package:repository/controller/screens/main_controller.dart';
import 'package:repository/controller/screens/main_screen/categories_controller.dart';
import 'package:repository/controller/screens/main_screen/clients_controller.dart';
import 'package:repository/controller/screens/main_screen/invoices_controller.dart';
import 'package:repository/controller/screens/main_screen/mone_box_controller.dart';
import 'package:repository/controller/screens/main_screen/operation_invoice_controller.dart';
import 'package:repository/controller/screens/main_screen/products_controller.dart';
import 'package:repository/controller/screens/main_screen/suppliers_controller.dart';
import 'package:repository/controller/screens/stocktaking_screen/individual_stocktaking_controller.dart';
import 'package:repository/core/middleware/start_middleware.dart';
import 'package:repository/view/screen/registration_screen.dart';
import 'package:repository/view/screen/details/supplier_details_screen.dart';
import 'package:repository/view/screen/main_screen.dart';
import 'package:repository/view/screen/main_screen/categories_screen.dart';
import 'package:repository/view/screen/main_screen/clients_screen.dart';
import 'package:repository/view/screen/main_screen/operation_invoice_screen.dart';
import 'package:repository/view/screen/details/category_details_screen.dart';
import 'package:repository/view/screen/details/client_details_screen.dart';
import 'package:repository/view/screen/details/invoice_details_screen.dart';
import 'package:repository/view/screen/details/product_details_screen.dart';
import 'package:repository/view/screen/main_screen/invoices_screen.dart';
import 'package:repository/view/screen/main_screen/money_box_screen.dart';
import 'package:repository/view/screen/main_screen/products_screen.dart';
import 'package:repository/view/screen/main_screen/suppliers_screen.dart';
import 'package:repository/view/screen/stocktaking_screen/individual_stocktaking_screen.dart';


abstract class AppPagesRoutes{

  // Auth
  static const String onBoarding = "/onBoarding";
  static const String registration = "/";


  // Tabs Screens
  static const String mainScreen = "/mainScreen";

  static const String categoriesScreen = "/categoriesScreen";
  static const String productsScreen = "/productsScreen";
  static const String clientsScreen = "/clientsScreen";
  static const String suppliersScreen = "/suppliersScreen";
  static const String invoicesScreen = "/invoicesScreen";
  static const String moneyBoxScreen = "/moneyBoxStatusScreen";

  // Details Screens
  static const String categoryDetailsScreen = "/categoryDetailsScreen";
  static const String productDetailsScreen = "/productDetailsScreen";
  static const String clientDetailsScreen = "/clientDetailsScreen";
  static const String supplierDetailsScreen = "/supplierDetailsScreen";
  static const String invoiceDetailsScreen = "/invoiceDetailsScreen";
  static const String operationOnInvoiceScreen = "/operationOnInvoiceScreen";
  static const String individualStocktaking = "/individualStocktaking";


  static List<GetPage<dynamic>> appPages = [
    // Auth Screens
    GetPage(
      name: registration,
      page: () => const RegistrationScreen(),
      binding: BindingsBuilder(
            () => {Get.put(RegistrationController())},
      ),
      middlewares: [StartMiddleWare()],
      transition: Transition.leftToRight,
    ),

    // Main Screen
    GetPage(
        name: mainScreen,
        page: () => const MainScreen(),
        binding: BindingsBuilder(
          () => {Get.put(MainController())},
        ),
      transition: Transition.leftToRight,
    ),

    // Tabs Screens
    GetPage(
        name: categoriesScreen,
        page: () => const CategoriesScreen(),
        binding: BindingsBuilder(
          () => {Get.put(CategoriesController())},
        ),
        transition: Transition.leftToRight,
    ),
    GetPage(
      name: productsScreen,
      page: () => const ProductsScreen(),
      binding: BindingsBuilder(
        () => {Get.put(ProductsController())},
      ),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: clientsScreen,
      page: () => const ClientsScreen(),
      binding: BindingsBuilder(
        () => {Get.put(ClientsController())},
      ),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: suppliersScreen,
      page: () => const SuppliersScreen(),
      binding: BindingsBuilder(
        () => {Get.put(SuppliersController())},
      ),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: invoicesScreen,
      page: () =>  const InvoicesScreen(),
      binding: BindingsBuilder(
        () => {Get.put(InvoicesController())},
      ),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: moneyBoxScreen,
      page: () => const MoneyBoxScreen(),
      binding: BindingsBuilder(
        () => {Get.put(MoneyBoxController())},
      ),
      transition: Transition.leftToRight,
    ),

    // Details Screens
    GetPage(
      name: categoryDetailsScreen,
      page: () => const CategoryDetailsScreen(),
      binding: BindingsBuilder(
        () {
          if(Get.previousRoute!=categoriesScreen){
            Get.put(CategoriesController());
          }
          Get.put(CategoryDetailsController());
        },
      ),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: productDetailsScreen,
      page: () => const ProductDetailsScreen(),
      binding: BindingsBuilder(
        () {
          if(Get.previousRoute!=productsScreen){
            Get.put(ProductsController());
          }
          Get.put(ProductDetailsController());
        },
      ),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: clientDetailsScreen,
      page: () => const ClientDetailsScreen(),
      binding: BindingsBuilder(
        () {
          if(Get.previousRoute!=clientsScreen){
            Get.put(ClientsController());
          }
          Get.put(ClientDetailsController());
        },
      ),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: supplierDetailsScreen,
      page: () => const SupplierDetailsScreen(),
      binding: BindingsBuilder(
        () {
          if(Get.previousRoute!=suppliersScreen){
            Get.put(SuppliersController());
          }
          Get.put(SupplierDetailsController());
        },
      ),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: invoiceDetailsScreen,
      page: () => const InvoiceDetailsScreen(),
      binding: BindingsBuilder(
        () {
          if(Get.previousRoute!=invoicesScreen){
            Get.put(InvoicesController());
          }
          Get.put(InvoiceDetailsController());
        },
      ),
      transition: Transition.leftToRight,
    ),

    GetPage(
      name: operationOnInvoiceScreen,
      page: () => const OperationsInvoiceScreen(),
      binding: BindingsBuilder(
        () {
          if(Get.previousRoute == mainScreen){
            Get.put(InvoicesController());
          }
          Get.put(OperationsInvoiceController());
        },
      ),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: individualStocktaking,
      page: () => const IndividualStocktakingScreen(),
      binding: BindingsBuilder(
        () => {Get.put(IndividualStocktakingController())},
      ),
      transition: Transition.leftToRight,
    ),
  ];
}


