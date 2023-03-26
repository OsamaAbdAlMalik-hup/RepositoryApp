
abstract class AppResponseKeys{

  // Subscribed Keys
    static const String id="id";
    static const String name="name";
    static const String photo="photo";
    static const String detailsCln="details";
    static const String totalPrice="total_price";
    static const String amount="amount";
    static const String type="type";
    static const String typeMoney="type_money";
    static const String typeOperation="type_operation";
    static const String date="date";
    static const String createdAt="created_at";
    static const String updatedAt="updated_at";
    static const String deletedAt="deleted_at";
    static const String data='data';
    static const String success='success';
    static const String message='message';

  // User && Repository Keys
    static const String user="user";
    static const String userId="user_id";
    static const String email="email";
    static const String rememberToken="remember_token";
    static const String isAdmin="is_admin";
    static const String codeCln="code";

  // Product && Category Keys
    static const String category="category";
    static const String products="products";
    static const String product="product";
    static const String productId="product_id";
    static const String measuringUnit="measuring_unit";
    static const String purchasePrice="purchase_price";
    static const String salePrice="sale_price";

  // Sales && Purchases Keys
    static const String sales="sales";
    static const String purchases="purchases";
    static const String totalPurchasePrice="total_purchase_price";
    static const String totalSalePrice="total_sale_price";


  // Client && Supplier Keys
    static const String supplier="supplier";
    static const String client="client";
    static const String clientId="client_id";
    static const String supplierId="supplier_id";
    static const String phoneNumber ="phone_number";
    static const String address="address";
    static const String invoicesCount="invoices_count";
    static const String paid="paid";
    static const String debts="debts";
    static const String invoicesTotal="invoices_total";


  // Invoices Keys
    static const String salesInvoices="sales_invoices";
    static const String salesInvoice="sale_invoice";
    static const String purchasesInvoice="purchase_invoice";
    static const String purchasesInvoices="purchases_invoices";
    static const String invoiceId="invoice_id";
    static const String number="number";
    static const String remained="remained";
    static const String isFinished="is_finished";


  // Stocktaking Keys
    static const String stocktaking="stocktaking";
    static const String productsAmount="products_amount";
    static const String salesAmount="sales_amount";
    static const String purchasesAmount="purchases_amount";
    static const String purchasesTotalPrice="purchases_total_price";
    static const String salesTotalPrice="sales_total_price";
    static const String expectedProfits="expected_profits";
    static const String profits="profits";
    static const String addCash="add_cash";
    static const String expenses="expenses";
    static const String debtsClients="debts_clients";
    static const String debtsSuppliers="debts_suppliers";
    static const String debtsExpenses="debts_expenses";
    static const String withdrawalCash="withdrawal_cash";
    static const String mostSaleProducts="most_selling_products";
    static const String leastAmountProducts="less_amount_products";
    static const String mostPopularSuppliers="most_popular_suppliers";
    static const String mostPopularClients="most_popular_clients";
    static const String leastExpenses="least_expenses";
    static const String leastPurchasesInvoices="latest_purchase_invoices";
    static const String leastSalesInvoices="latest_sale_invoices";


}