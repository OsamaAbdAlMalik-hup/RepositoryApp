import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/data/models/sale.dart';

class SaleInvoice {
  int id;
  int number;
  double totalPrice;
  double paid;
  double remained;
  String date;
  int clientId;
  String clientName;
  int moneyOperationId;
  SaleInvoiceDetails details;

  SaleInvoice(
      {this.id = 0,
      this.number = 0,
      this.totalPrice = 0,
      this.paid = 0,
      this.remained = 0,
      this.clientName = '',
      this.clientId = 0,
      this.moneyOperationId = 0,
      this.date = '',
      required this.details});

  static List<SaleInvoice> jsonToList(List<dynamic> salesInvoicesMap) {
    List<SaleInvoice> salesInvoices = [];
    for (Map saleInvoice in salesInvoicesMap) {
      salesInvoices.add(SaleInvoice(
          id: saleInvoice.containsKey(AppResponseKeys.id)
              ? saleInvoice[AppResponseKeys.id]
              : 0,
          number: saleInvoice.containsKey(AppResponseKeys.number)
              ? saleInvoice[AppResponseKeys.number]
              : 0,
          totalPrice: saleInvoice.containsKey(AppResponseKeys.totalPrice)
              ? double.parse(saleInvoice[AppResponseKeys.totalPrice].toString())
              : 0,
          paid: saleInvoice.containsKey(AppResponseKeys.paid)
              ? double.parse(saleInvoice[AppResponseKeys.paid].toString())
              : 0,
          remained: saleInvoice.containsKey(AppResponseKeys.remained)
              ? double.parse(saleInvoice[AppResponseKeys.remained].toString())
              : 0,
          clientName: HelperLogicFunctions.getNestedVale(map: saleInvoice, firstKey: AppResponseKeys.client, secondKey: AppResponseKeys.name , defaultVal: ''),
          clientId: HelperLogicFunctions.getNestedVale(map: saleInvoice, firstKey: AppResponseKeys.client, secondKey: AppResponseKeys.id, defaultVal: 0),
          date: saleInvoice.containsKey(AppResponseKeys.date)
              ? saleInvoice[AppResponseKeys.date]
              : '',
          moneyOperationId: 0,
          details: SaleInvoiceDetails(
            sales: saleInvoice.containsKey(AppResponseKeys.sales)
                ? Sale.jsonToList(saleInvoice[AppResponseKeys.sales])
                : [],
          )));
    }
    return salesInvoices;
  }
}

class SaleInvoiceDetails {
  List<Sale> sales;

  SaleInvoiceDetails({this.sales=const []});
}
