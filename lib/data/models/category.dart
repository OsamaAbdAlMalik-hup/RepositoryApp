import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/data/models/purchase.dart';
import 'package:repository/data/models/product.dart';
import 'package:repository/data/models/sale.dart';

class Category {
  int id;
  String name;
  String photo;
  double productsAmount;
  double salesAmount;
  double purchasesAmount;
  CategoryDetails details;
  CategoryStocktaking stocktaking;

  Category(
      {this.id = 0,
      this.name = '',
      this.photo = '',
      this.productsAmount = 0,
      this.salesAmount = 0,
      this.purchasesAmount = 0,
      required this.details,
      required this.stocktaking});

  static List<Category> jsonToList(List<dynamic> categoriesMap) {
    List<Category> categories = [];
    for (var category in categoriesMap) {
      categories.add(Category(
        id: category.containsKey(AppResponseKeys.id)
            ? category[AppResponseKeys.id]
            : 0,
        name: category.containsKey(AppResponseKeys.name)
            ? category[AppResponseKeys.name]
            : '',
        photo: category.containsKey(AppResponseKeys.photo)
            ? category[AppResponseKeys.photo]
            : '',
        productsAmount: category.containsKey(AppResponseKeys.productsAmount)
            ? double.parse(category[AppResponseKeys.productsAmount].toString())
            : 0,
        salesAmount: category.containsKey(AppResponseKeys.salesAmount)
            ? double.parse(category[AppResponseKeys.salesAmount].toString())
            : 0,
        purchasesAmount: category.containsKey(AppResponseKeys.purchasesAmount)
            ? double.parse(category[AppResponseKeys.purchasesAmount].toString())
            : 0,
        details: category.containsKey(AppResponseKeys.detailsCln)
            ? CategoryDetails.jsonTo(category[AppResponseKeys.detailsCln])
            : CategoryDetails(),
        stocktaking: category.containsKey(AppResponseKeys.stocktaking)
            ? CategoryStocktaking.jsonTo(category[AppResponseKeys.stocktaking])
            : CategoryStocktaking(),
      ));
    }
    return categories;
  }
}

class CategoryDetails {
  List<Product> products;
  List<Sale> sales;
  List<Purchase> purchases;

  CategoryDetails(
      {this.products = const [],
      this.sales = const [],
      this.purchases = const []});
  static CategoryDetails jsonTo(Map categoryDetailsMap) {
    return CategoryDetails(
      products: categoryDetailsMap.containsKey(AppResponseKeys.products)
          ? Product.jsonToList(categoryDetailsMap[AppResponseKeys.products])
          : [],
      sales: categoryDetailsMap.containsKey(AppResponseKeys.sales)
          ? Sale.jsonToList(categoryDetailsMap[AppResponseKeys.sales])
          : [],
      purchases: categoryDetailsMap.containsKey(AppResponseKeys.purchases)
          ? Purchase.jsonToList(categoryDetailsMap[AppResponseKeys.purchases])
          : [],

    );
  }

}

class CategoryStocktaking {
  double salesAmount, salesTotalPrice;
  double purchasesAmount, purchasesTotalPrice;
  double profits, expectedProfits;

  CategoryStocktaking({
    this.salesAmount = 0,
    this.salesTotalPrice = 0,
    this.purchasesAmount = 0,
    this.purchasesTotalPrice = 0,
    this.profits = 0,
    this.expectedProfits = 0,
  });

  static CategoryStocktaking jsonTo(Map categoryStocktakingMap) {
    return CategoryStocktaking(
      salesTotalPrice: categoryStocktakingMap.containsKey(AppResponseKeys.salesTotalPrice)
          ? double.parse(categoryStocktakingMap[AppResponseKeys.salesTotalPrice].toString())
          : 0,
      salesAmount: categoryStocktakingMap.containsKey(AppResponseKeys.salesAmount)
          ? double.parse(categoryStocktakingMap[AppResponseKeys.salesAmount].toString())
          : 0,
      purchasesTotalPrice: categoryStocktakingMap.containsKey(AppResponseKeys.purchasesTotalPrice)
          ? double.parse(categoryStocktakingMap[AppResponseKeys.purchasesTotalPrice].toString())
          : 0,
      purchasesAmount: categoryStocktakingMap.containsKey(AppResponseKeys.purchasesAmount)
          ? double.parse(categoryStocktakingMap[AppResponseKeys.purchasesAmount].toString())
          : 0,
      expectedProfits: categoryStocktakingMap.containsKey(AppResponseKeys.expectedProfits)
          ? double.parse(categoryStocktakingMap[AppResponseKeys.expectedProfits].toString())
          : 0,
      profits: categoryStocktakingMap.containsKey(AppResponseKeys.profits)
          ? double.parse(categoryStocktakingMap[AppResponseKeys.profits].toString())
          : 0,
    );
  }
}
