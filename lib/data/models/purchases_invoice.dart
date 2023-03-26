import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/data/models/purchase.dart';

class PurchasesInvoice {
  int id;
  int number;
  double totalPrice;
  double paid;
  double remained;
  int supplierId;
  String supplierName;
  String date;
  PurchasesInvoiceDetails details;

  PurchasesInvoice(
      {this.id = 0,
      this.number = 0,
      this.totalPrice = 0,
      this.paid = 0,
      this.remained = 0,
      this.supplierName = '',
      this.supplierId = 0,
      this.date = '',
      required this.details});

  static List<PurchasesInvoice> jsonToList(List<dynamic> purchasesInvoicesMap) {
    List<PurchasesInvoice> purchasesInvoices = [];
    for (Map purchasesInvoice in purchasesInvoicesMap) {
      purchasesInvoices.add(PurchasesInvoice(
          id: purchasesInvoice.containsKey(AppResponseKeys.id)
              ? purchasesInvoice[AppResponseKeys.id]
              : 0,
          number: purchasesInvoice.containsKey(AppResponseKeys.number)
              ? purchasesInvoice[AppResponseKeys.number]
              : 0,
          totalPrice: purchasesInvoice.containsKey(AppResponseKeys.totalPrice)
              ? double.parse(purchasesInvoice[AppResponseKeys.totalPrice].toString())
              : 0,
          paid: purchasesInvoice.containsKey(AppResponseKeys.paid)
              ? double.parse(purchasesInvoice[AppResponseKeys.paid].toString())
              : 0,
          remained: purchasesInvoice.containsKey(AppResponseKeys.remained)
              ? double.parse(purchasesInvoice[AppResponseKeys.remained].toString())
              : 0,
          supplierName: purchasesInvoice.containsKey(AppResponseKeys.supplier)
              ? purchasesInvoice[AppResponseKeys.supplier][AppResponseKeys.name]
              : '',
          supplierId: purchasesInvoice.containsKey(AppResponseKeys.supplierId)
              ? purchasesInvoice[AppResponseKeys.supplierId]
              : 0,
          date: purchasesInvoice.containsKey(AppResponseKeys.date)
              ? purchasesInvoice[AppResponseKeys.date]
              : '',
          details: PurchasesInvoiceDetails(
            purchases: purchasesInvoice.containsKey(AppResponseKeys.purchases)
                ? Purchase.jsonToList(purchasesInvoice[AppResponseKeys.purchases])
                : [],
          )));
    }
    return purchasesInvoices;
  }
}

class PurchasesInvoiceDetails {
  List<Purchase> purchases;

  PurchasesInvoiceDetails({this.purchases = const []});
}
