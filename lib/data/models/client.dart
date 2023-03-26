import 'package:repository/core/constant/app_response_keys.dart';
import 'package:repository/data/models/sale_invoice.dart';
import 'package:repository/data/models/sale.dart';

class Client {
  int id;
  String name;
  String phoneNumber;
  String address;
  String photo;
  int invoicesCount;
  double debts;
  double invoicesTotal;
  ClientDetails details;
  ClientStocktaking stocktaking;

  Client(
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

  static List<Client> jsonToList(List<dynamic> clientsMap) {
    List<Client> clients = [];
    for (var client in clientsMap) {
      clients.add(Client(
        id: client.containsKey(AppResponseKeys.id)
            ? client[AppResponseKeys.id]
            : 0,
        name: client.containsKey(AppResponseKeys.name)
            ? client[AppResponseKeys.name]
            : '',
        phoneNumber: client.containsKey(AppResponseKeys.phoneNumber)
            ? client[AppResponseKeys.phoneNumber]
            : '',
        address: client.containsKey(AppResponseKeys.address)
            ? client[AppResponseKeys.address]
            : '',
        photo: client.containsKey(AppResponseKeys.photo)
            ? client[AppResponseKeys.photo]
            : '',
        invoicesCount: client.containsKey(AppResponseKeys.invoicesCount)
            ? client[AppResponseKeys.invoicesCount]
            : 0,
        debts: client.containsKey(AppResponseKeys.debts)
            ? double.parse(client[AppResponseKeys.debts].toString())
            : 0,
        invoicesTotal: client.containsKey(AppResponseKeys.invoicesTotal)
            ? double.parse(client[AppResponseKeys.invoicesTotal].toString())
            : 0,
        details: client.containsKey(AppResponseKeys.detailsCln)
            ? ClientDetails.jsonTo(client[AppResponseKeys.detailsCln])
            : ClientDetails(),
        stocktaking: client.containsKey(AppResponseKeys.stocktaking)
            ? ClientStocktaking.jsonTo(client[AppResponseKeys.stocktaking])
            : ClientStocktaking(),
      ));
    }
    return clients;
  }
}

class ClientDetails {
  List<SaleInvoice> salesInvoices;
  List<Sale> sales;

  ClientDetails(
      {this.salesInvoices = const [],
      this.sales = const [],});

  static ClientDetails jsonTo(Map clientDetailsMap) {
    return ClientDetails(
      sales: clientDetailsMap.containsKey(AppResponseKeys.sales)
          ? Sale.jsonToList(clientDetailsMap[AppResponseKeys.sales])
          : [],
      salesInvoices: clientDetailsMap.containsKey(AppResponseKeys.salesInvoices)
          ? SaleInvoice.jsonToList(clientDetailsMap[AppResponseKeys.salesInvoices])
          : [],
    );
  }

}

class ClientStocktaking {
  int invoicesCount;
  double paid, debts;
  double salesAmount, invoicesTotal;

  ClientStocktaking(
      {this.invoicesCount = 0,
      this.paid = 0,
      this.debts = 0,
      this.salesAmount = 0,
      this.invoicesTotal = 0});

  static ClientStocktaking jsonTo(Map clientStocktakingMap) {
    return ClientStocktaking(
      salesAmount: clientStocktakingMap.containsKey(AppResponseKeys.salesAmount)
          ? double.parse(clientStocktakingMap[AppResponseKeys.salesAmount].toString())
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
