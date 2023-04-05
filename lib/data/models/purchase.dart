
import 'package:repository/core/constant/app_response_keys.dart';

class Purchase {
  int id;
  double amount;
  int productId;
  int supplierId;
  int invoiceNumber;
  String productName;
  String supplierName;
  double totalPurchasePrice;

  Purchase(
      {this.id = 0,
      this.productId = 0,
      this.invoiceNumber = 0,
      this.productName = '',
      this.supplierName = '',
      this.supplierId = 0,
      this.amount = 0,
      this.totalPurchasePrice = 0});

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
          supplierName: purchase.containsKey(AppResponseKeys.supplier) &&
                  purchase[AppResponseKeys.supplier]
                      .containsKey(AppResponseKeys.name)
              ? purchase[AppResponseKeys.supplier][AppResponseKeys.name]
              : '',
          supplierId: purchase.containsKey(AppResponseKeys.supplierId)
              ? purchase[AppResponseKeys.supplierId]
              : 0,
          productId: purchase.containsKey(AppResponseKeys.product) &&
              purchase[AppResponseKeys.product]
                  .containsKey(AppResponseKeys.id)
              ? purchase[AppResponseKeys.product][AppResponseKeys.id]
              : 0
      )
      );
    }
    return purchases;
  }
}

