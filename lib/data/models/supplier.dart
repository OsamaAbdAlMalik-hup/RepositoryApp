import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/data/models/purchases_invoice.dart';
import 'package:repository/data/models/purchase.dart';

class Supplier {
  int id;
  String name;
  String phoneNumber;
  String address;
  String photo;
  int invoicesCount;
  double debts;
  double invoicesTotal;
  SupplierDetails details;
  SupplierStocktaking stocktaking;

  Supplier(
      {this.id = 0,
      this.name = '',
      this.phoneNumber = '',
      this.address = '',
      this.photo = '',
      this.invoicesCount = 0,
      this.debts = 0,
      this.invoicesTotal = 0,
      required this.details,
      required this.stocktaking});

  static List<Supplier> jsonToList(List<dynamic> suppliersMap) {
    List<Supplier> suppliers = [];
    for (var supplier in suppliersMap) {
      suppliers.add(Supplier(
          id: supplier.containsKey(AppResponseKeys.id)
              ? supplier[AppResponseKeys.id]
              : 0,
          name: supplier.containsKey(AppResponseKeys.name)
              ? supplier[AppResponseKeys.name]
              : '',
          phoneNumber: supplier.containsKey(AppResponseKeys.phoneNumber)
              ? supplier[AppResponseKeys.phoneNumber]
              : '',
          address: supplier.containsKey(AppResponseKeys.address)
              ? supplier[AppResponseKeys.address]
              : '',
          photo: supplier.containsKey(AppResponseKeys.photo)
              ? supplier[AppResponseKeys.photo]
              : '',
          invoicesCount: supplier.containsKey(AppResponseKeys.invoicesCount)
              ? supplier[AppResponseKeys.invoicesCount]
              : 0,
          debts: supplier.containsKey(AppResponseKeys.debts)
              ? double.parse(supplier[AppResponseKeys.debts].toString())
              : 0,
          invoicesTotal: supplier.containsKey(AppResponseKeys.invoicesTotal)
              ? double.parse(supplier[AppResponseKeys.invoicesTotal].toString())
              : 0,
          details: supplier.containsKey(AppResponseKeys.detailsCln)
              ? SupplierDetails.jsonTo(supplier[AppResponseKeys.detailsCln])
              : SupplierDetails(),
          stocktaking: supplier.containsKey(AppResponseKeys.stocktaking)
              ? SupplierStocktaking.jsonTo(supplier[AppResponseKeys.stocktaking])
              : SupplierStocktaking(),
      ));
    }
    return suppliers;
  }
}

class SupplierDetails {
  List<PurchasesInvoice> purchasesInvoices;
  List<Purchase> purchases;

  SupplierDetails(
      {this.purchasesInvoices=const [],
      this.purchases=const [],});

  static SupplierDetails jsonTo(Map clientDetailsMap) {
    return SupplierDetails(
      purchases: clientDetailsMap.containsKey(AppResponseKeys.purchases)
          ? Purchase.jsonToList(clientDetailsMap[AppResponseKeys.purchases])
          : [],
      purchasesInvoices: clientDetailsMap.containsKey(AppResponseKeys.purchasesInvoices)
          ? PurchasesInvoice.jsonToList(clientDetailsMap[AppResponseKeys.purchasesInvoices])
          : [],
    );
  }

}

class SupplierStocktaking {
  int invoicesCount;
  double paid, debts;
  double purchasesAmount, invoicesTotal;

  SupplierStocktaking(
      {this.invoicesCount = 0,
      this.paid = 0,
      this.debts = 0,
      this.purchasesAmount = 0,
      this.invoicesTotal = 0});

  static SupplierStocktaking jsonTo(Map clientStocktakingMap) {
    return SupplierStocktaking(
      purchasesAmount: clientStocktakingMap.containsKey(AppResponseKeys.purchasesAmount)
          ? double.parse(clientStocktakingMap[AppResponseKeys.purchasesAmount].toString())
          : 0,
      invoicesTotal: clientStocktakingMap.containsKey(AppResponseKeys.invoicesTotal)
          ? double.parse(clientStocktakingMap[AppResponseKeys.invoicesTotal].toString())
          : 0,
      paid: clientStocktakingMap.containsKey(AppResponseKeys.paid)
          ? double.parse(clientStocktakingMap[AppResponseKeys.paid].toString())
          : 0,
      invoicesCount: clientStocktakingMap.containsKey(AppResponseKeys.invoicesCount)
          ? clientStocktakingMap[AppResponseKeys.invoicesCount]
          : 0,
      debts: clientStocktakingMap.containsKey(AppResponseKeys.debts)
          ? double.parse(clientStocktakingMap[AppResponseKeys.debts].toString())
          : 0,
    );
  }
}
