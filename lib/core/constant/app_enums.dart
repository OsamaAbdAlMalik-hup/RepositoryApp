
// FilterType Enum
  enum PublicFilterType {
    amount, date, salesInvoices,purchasesInvoices, expenses,
    invoicesCount, profit
  }
  enum ViewModeType {
    defaultMode, filerMode, archiveMode
  }
  enum UsersFilterType {
    name, createAt,updateAt,
    phoneNumber, address, invoicesCount,debt,paid
  }
  enum InvoiceFilterType {
    name,date, createAt,updateAt,
    number, total, remainder
  }
  enum ProductFilterType{
    name,date, createAt,updateAt,
    productsAmount,salesAmount,purchasesAmount,
    salePrice,purchasePrice,benefit,
    category,
  }

  enum InvoiceType{
    sales,purchases
  }
  enum StocktakingType{
    category,product,client,supplier
  }
  enum OperationType {
    create,update, delete, archive ,debts,registers, sort
  }
  enum StatusView {
    none ,
    loading ,
    noContent,
    serverFailure,
  }

  abstract class StatusCodeRequest{
    static const int ok = 200;
    static const int badRequest = 400;
    static const int unauthorised= 401;
  }
  abstract class MoneyType{
    static const String addCashMoney='add_cash';
    static const String withdrawalCash='withdrawal_cash';
    static const String expenseMoney='expenses';
    static const String salesMoney='sales';
    static const String purchasesMoney='purchases';
  }
  abstract class Units{
    static const String kg = 'Kg';
    static const String litter = 'Litter';
    static const String meter = 'Meter';
    static const String piece = 'Piece';
  }
