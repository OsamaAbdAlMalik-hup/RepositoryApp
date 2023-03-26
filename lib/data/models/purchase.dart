import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/purchases_invoice.dart';

class Purchase {
  int id;
  double amount;
  int productId;
  int supplierId;
  String productName;
  double totalpurchasePrice;
  double totalPurchasePrice;
  PurchaseDetails details;

  Purchase(
      {this.id = 0,
      this.productId = 0,
      this.productName = '',
      this.supplierId = 0,
      this.amount = 0,
      this.totalpurchasePrice = 0,
      this.totalPurchasePrice = 0,
      required this.details});

  static List<Purchase> jsonToList(List<dynamic> purchasesMap) {
    List<Purchase> purchases = [];
    for (Map purchase in purchasesMap) {
      purchases.add(Purchase(
          id: purchase.containsKey(AppResponseKeys.id)
              ? purchase[AppResponseKeys.id]
              : 0,
          amount: purchase.containsKey(AppResponseKeys.amount)
              ? double.parse(purchase[AppResponseKeys.amount].toString())
              : 0,
          totalPurchasePrice:
          purchase.containsKey(AppResponseKeys.totalPurchasePrice)
              ? double.parse(purchase[AppResponseKeys.totalPurchasePrice].toString())
              : 0,
          productName: purchase.containsKey(AppResponseKeys.product) &&
                  purchase[AppResponseKeys.product]
                      .containsKey(AppResponseKeys.name)
              ? purchase[AppResponseKeys.product][AppResponseKeys.name]
              : '',
          supplierId: purchase.containsKey(AppResponseKeys.supplierId)
              ? purchase[AppResponseKeys.supplierId]
              : 0,
          productId: purchase.containsKey(AppResponseKeys.product) &&
              purchase[AppResponseKeys.product]
                  .containsKey(AppResponseKeys.id)
              ? purchase[AppResponseKeys.product][AppResponseKeys.id]
              : 0,
          details: PurchaseDetails(product: Product(details: ProductDetails(), stocktaking: ProductStocktaking()), purchasesInvoice: PurchasesInvoice(details: PurchasesInvoiceDetails()))));
    }
    return purchases;
  }
}

class PurchaseDetails {
  Product product;
  PurchasesInvoice purchasesInvoice;

  PurchaseDetails({
    required this.product,
    required this.purchasesInvoice,
  });
}

// TODO FIX DETAILS OF SALES AND PURCHASES