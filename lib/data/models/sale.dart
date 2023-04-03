import 'package:repository/core/constant/app_response_keys.dart';

class Sale {
  int id;
  double amount;
  double totalSalePrice;
  double totalPurchasePrice;
  int invoiceNumber;
  int productId;
  int clientId;
  String productName;
  String clientName;

  int saleInvoiceId;

  Sale(
      { this.id=0,
       this.amount=0,
       this.totalSalePrice=0,
       this.totalPurchasePrice=0,
       this.productName='',
       this.clientName='',
       this.invoiceNumber=0,
       this.productId=0,
       this.clientId=0,
       this.saleInvoiceId=0});

  static List<Sale> jsonToList(List<dynamic> salesMap) {
    List<Sale> sales = [];
    for (Map sale in salesMap) {
      sales.add(Sale(
        id: sale.containsKey(AppResponseKeys.id)
            ? sale[AppResponseKeys.id]
            : 0,
        amount: sale.containsKey(AppResponseKeys.amount)
            ? double.parse(sale[AppResponseKeys.amount].toString())
            : 0,
        totalPurchasePrice: sale.containsKey(AppResponseKeys.totalPurchasePrice)
            ? double.parse(sale[AppResponseKeys.totalPurchasePrice].toString())
            : 0,
        totalSalePrice: sale.containsKey(AppResponseKeys.totalSalePrice)
            ? double.parse(sale[AppResponseKeys.totalSalePrice].toString())
            : 0,
        productName: sale.containsKey(AppResponseKeys.product) && sale[AppResponseKeys.product].containsKey(AppResponseKeys.name)
            ? sale[AppResponseKeys.product][AppResponseKeys.name]
            : '',
        clientName: sale.containsKey(AppResponseKeys.client) && sale[AppResponseKeys.client].containsKey(AppResponseKeys.name)
            ? sale[AppResponseKeys.client][AppResponseKeys.name]
            : '',
        invoiceNumber: sale.containsKey(AppResponseKeys.salesInvoice) && sale[AppResponseKeys.salesInvoice].containsKey(AppResponseKeys.number)
            ? sale[AppResponseKeys.salesInvoice][AppResponseKeys.number]
            : 0,
        productId: sale.containsKey(AppResponseKeys.product) && sale[AppResponseKeys.product].containsKey(AppResponseKeys.id)
            ? sale[AppResponseKeys.product][AppResponseKeys.id]
            : 0,
        clientId: sale.containsKey(AppResponseKeys.client) && sale[AppResponseKeys.client].containsKey(AppResponseKeys.id)
            ? sale[AppResponseKeys.client][AppResponseKeys.id]
            : 0,
        saleInvoiceId: sale.containsKey(AppResponseKeys.salesInvoice) && sale[AppResponseKeys.salesInvoice].containsKey(AppResponseKeys.id)
            ? sale[AppResponseKeys.id]
            : 0,
      ));
    }
    return sales;
  }
}
