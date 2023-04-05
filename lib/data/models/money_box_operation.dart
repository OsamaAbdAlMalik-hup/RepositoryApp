
import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/constant/app_enums.dart';
import 'package:repository/core/helper/logic_functions.dart';

class MoneyBoxOperation {
  int id;
  double totalPrice;
  String typeMoney;
  bool isFinished;
  int invoiceNumber;
  String date;

  MoneyBoxOperation(
      { this.id=0,
       this.totalPrice=0,
       this.typeMoney='add_cash',
       this.date='',
      this.isFinished = true,
      this.invoiceNumber = 0});

  static List<MoneyBoxOperation> jsonToList(List<dynamic> moneyBoxOperationsMap) {

    List<MoneyBoxOperation> moneyBoxOperations = [];
    for (Map operation in moneyBoxOperationsMap) {
      moneyBoxOperations.add(MoneyBoxOperation(
        id: operation.containsKey(AppResponseKeys.id)
            ? operation[AppResponseKeys.id]
            : 0,
        totalPrice: operation.containsKey(AppResponseKeys.totalPrice)
            ? double.parse(operation[AppResponseKeys.totalPrice].toString())
            : 0,
        typeMoney: operation.containsKey(AppResponseKeys.typeMoney)
            ? operation[AppResponseKeys.typeMoney]
            : MoneyType.addCashMoney,
        date: operation.containsKey(AppResponseKeys.date)
            ? operation[AppResponseKeys.date]
            : '',
        isFinished: operation.containsKey(AppResponseKeys.isFinished)
            ? operation[AppResponseKeys.isFinished] == 1
            : false,
          invoiceNumber: HelperLogicFunctions.getNestedVale(
              map: operation,
              firstKey: AppResponseKeys.salesInvoice,
              secondKey: AppResponseKeys.number,
              defaultVal: HelperLogicFunctions.getNestedVale(
                  map: operation,
                  firstKey: AppResponseKeys.purchasesInvoice,
                  secondKey: AppResponseKeys.number,
                  defaultVal: 00000
              )
          )
        )
      );
    }
    return moneyBoxOperations;
  }
}

class FullStocktaking {
  double salesAmount,
      purchasesAmount,
      salesTotalPrice,
      purchasesTotalPrice,
      profits,
      expectedProfits,
      addCash,
      withdrawalCash,
      expenses,
      debtsClients,
      debtsSuppliers,
      debtsExpenses;

  FullStocktaking(
      {this.salesAmount=0,
       this.purchasesAmount=0,
       this.salesTotalPrice=0,
       this.purchasesTotalPrice=0,
       this.profits=0,
       this.expectedProfits=0,
       this.addCash=0,
       this.withdrawalCash=0,
       this.expenses=0,
       this.debtsClients=0,
       this.debtsSuppliers=0,
       this.debtsExpenses=0});

  static FullStocktaking jsonTo(Map fullStockingMap) {
    return FullStocktaking(
        salesAmount: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.salesAmount,
            defaultVal: 0.0),
        purchasesAmount: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.purchasesAmount,
            defaultVal: 0.0),
        salesTotalPrice: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.salesTotalPrice,
            defaultVal: 0.0),
        purchasesTotalPrice: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.purchasesTotalPrice,
            defaultVal: 0.0),
        profits: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.profits,
            defaultVal: 0.0),
        expectedProfits: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.expectedProfits,
            defaultVal: 0.0),
        addCash: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.addCash,
            defaultVal: 0.0),
        withdrawalCash: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.withdrawalCash,
            defaultVal: 0.0),
        expenses: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.expenses,
            defaultVal: 0.0),
        debtsClients: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.debtsClients,
            defaultVal: 0.0),
        debtsSuppliers: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.debtsSuppliers,
            defaultVal: 0.0),
        debtsExpenses: HelperLogicFunctions.getVale(
            map: fullStockingMap,
            key: AppResponseKeys.debtsExpenses,
            defaultVal: 0.0));
  }

}
