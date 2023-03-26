import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/core/helper/logic_functions.dart';
import 'package:repository/data/models/purchase.dart';
import 'package:repository/data/models/sale.dart';

class Product {
  int id;
  String name;
  double purchasePrice;
  double salePrice;
  double amount;
  String photo;
  String measuringUnit;
  int categoryId;
  String categoryName;
  ProductDetails details;
  ProductStocktaking stocktaking;

  Product(
      {this.id=0,
      this.name='',
      this.purchasePrice=0,
      this.salePrice=0,
      this.amount=0,
      this.categoryName='',
      this.categoryId=0,
      this.photo='',
      this.measuringUnit="Kg",
      required this.details,
      required this.stocktaking});

  static List<Product> jsonToList(List<dynamic> productsMap) {
    List<Product> products = [];

    for (Map product in productsMap) {
      products.add(Product(
        id: product.containsKey(AppResponseKeys.id)
            ? product[AppResponseKeys.id]
            : 0,
        name: product.containsKey(AppResponseKeys.name)
            ? product[AppResponseKeys.name]
            : '',
        amount: product.containsKey(AppResponseKeys.amount)
            ? double.parse(product[AppResponseKeys.amount].toString())
            : 0,
        purchasePrice: product.containsKey(AppResponseKeys.purchasePrice)
            ? double.parse(product[AppResponseKeys.purchasePrice].toString())
            : 0,
        salePrice: product.containsKey(AppResponseKeys.salePrice)
            ? double.parse(product[AppResponseKeys.salePrice].toString())
            : 0,
        photo: product.containsKey(AppResponseKeys.photo)
            ? product[AppResponseKeys.photo]
            : '',
        measuringUnit: HelperLogicFunctions.getVale(map: product,
            key: AppResponseKeys.measuringUnit,
            defaultVal: ''
        ),
        categoryName: HelperLogicFunctions.getNestedVale(
            map: product,
            firstKey: AppResponseKeys.category,
            secondKey: AppResponseKeys.name,
            defaultVal: ''),
        categoryId: HelperLogicFunctions.getNestedVale(
            map: product,
            firstKey: AppResponseKeys.category,
            secondKey: AppResponseKeys.id,
            defaultVal: 0),
        details: product.containsKey(AppResponseKeys.detailsCln)
            ? ProductDetails.jsonTo(product[AppResponseKeys.detailsCln])
            : ProductDetails(),
        stocktaking:  product.containsKey(AppResponseKeys.stocktaking)
            ? ProductStocktaking.jsonTo(product[AppResponseKeys.stocktaking])
            : ProductStocktaking(),
      ));
    }
    return products;
  }
}

class ProductDetails {
  List<Sale> sales;
  List<Purchase> purchases;

  ProductDetails(
      {this.sales=const [], this.purchases=const []});
  static ProductDetails jsonTo(Map productDetailsMap) {
    return ProductDetails(
      purchases: productDetailsMap.containsKey(AppResponseKeys.purchases)
          ? Purchase.jsonToList(productDetailsMap[AppResponseKeys.purchases])
          : [],
      sales: productDetailsMap.containsKey(AppResponseKeys.sales)
          ? Sale.jsonToList(productDetailsMap[AppResponseKeys.sales])
          : [],
    );
  }

}

class ProductStocktaking {
  double salesAmount, salesTotalPrice;
  double purchasesAmount, purchaseTotalPrice;
  double profit, expectedProfit;

  ProductStocktaking({
    this.salesAmount = 0,
    this.salesTotalPrice = 0,
    this.purchasesAmount = 0,
    this.purchaseTotalPrice = 0,
    this.expectedProfit = 0,
    this.profit = 0,
  });
  static ProductStocktaking jsonTo(Map productStocktakingMap) {
    return ProductStocktaking(
      purchaseTotalPrice: productStocktakingMap.containsKey(AppResponseKeys.purchasesTotalPrice)
          ? double.parse(productStocktakingMap[AppResponseKeys.purchasesTotalPrice].toString())
          : 0,
      purchasesAmount: productStocktakingMap.containsKey(AppResponseKeys.purchasesAmount)
          ? double.parse(productStocktakingMap[AppResponseKeys.purchasesAmount].toString())
          : 0,
      salesTotalPrice: productStocktakingMap.containsKey(AppResponseKeys.salesTotalPrice)
          ? double.parse(productStocktakingMap[AppResponseKeys.salesTotalPrice].toString())
          : 0,
      salesAmount: productStocktakingMap.containsKey(AppResponseKeys.salesAmount)
          ? double.parse(productStocktakingMap[AppResponseKeys.salesAmount].toString())
          : 0,
      expectedProfit: productStocktakingMap.containsKey(AppResponseKeys.expectedProfits)
          ? double.parse(productStocktakingMap[AppResponseKeys.expectedProfits].toString())
          : 0,
      profit: productStocktakingMap.containsKey(AppResponseKeys.profits)
          ? double.parse(productStocktakingMap[AppResponseKeys.profits].toString())
          : 0,
    );
  }

}
