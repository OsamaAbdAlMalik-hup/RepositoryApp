
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/data/models/client.dart';
import 'package:repository/data/models/expense.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/purchases_invoice.dart';
import 'package:repository/data/models/sale_invoice.dart';
import 'package:repository/data/models/supplier.dart';

class Monitoring {
  List<SaleInvoice> leastSalesInvoices;
  List<PurchasesInvoice> leastPurchasesInvoices;
  List<Expense> leastExpenses;
  List<Client> mostPopularClients;
  List<Supplier> mostPopularSuppliers;
  List<Product> mostSaleProducts;
  List<Product> leastAmountProducts;

  Monitoring({
    this.leastSalesInvoices= const [],
    this.leastPurchasesInvoices= const [],
    this.leastExpenses= const [],
    this.mostPopularClients= const [],
    this.mostPopularSuppliers= const [],
    this.mostSaleProducts= const [],
    this.leastAmountProducts= const [],
  });

  static Monitoring jsonToMonitoring(Map monitoringMap) {
    return Monitoring(
      leastSalesInvoices: SaleInvoice.jsonToList(
        HelperLogicFunctions.getVale(map: monitoringMap, key: AppResponseKeys.leastSalesInvoices, defaultVal: [])
      ),
      leastPurchasesInvoices: PurchasesInvoice.jsonToList(
        HelperLogicFunctions.getVale(map: monitoringMap, key: AppResponseKeys.leastPurchasesInvoices, defaultVal: [])
      ),
      leastExpenses: Expense.jsonToList(
        HelperLogicFunctions.getVale(map: monitoringMap, key: AppResponseKeys.leastExpenses, defaultVal: []),
      ),
      mostSaleProducts: Product.jsonToList(
        HelperLogicFunctions.getVale(map: monitoringMap, key: AppResponseKeys.mostSaleProducts, defaultVal: []),
      ),
      leastAmountProducts: Product.jsonToList(
        HelperLogicFunctions.getVale(map: monitoringMap, key: AppResponseKeys.leastAmountProducts, defaultVal: {}),
      ),
      mostPopularSuppliers: Supplier.jsonToList(HelperLogicFunctions.getVale(map: monitoringMap, key: AppResponseKeys.mostPopularSuppliers, defaultVal: []),),
      mostPopularClients: Client.jsonToList(HelperLogicFunctions.getVale(map: monitoringMap, key: AppResponseKeys.mostPopularClients, defaultVal: []),)
    );
  }
}
