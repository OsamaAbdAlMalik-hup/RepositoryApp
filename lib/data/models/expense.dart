import 'package:repository/core/constant/app_response_keys.dart';

class Expense {
  int id;
  String name;
  String details;
  double totalPrice;
  double paid;
  double remainder;
  String date;

  Expense(
      {this.id = 0,
      this.name = '',
      this.totalPrice = 0,
      this.paid = 0,
      this.remainder = 0,
      this.date = '',
      this.details = ''});

  static List<Expense> jsonToList(List<dynamic> expensesMap) {
    List<Expense> expenses = [];
    for (var expense in expensesMap) {
      expenses.add(Expense(
        id: expense.containsKey(AppResponseKeys.id)
            ? expense[AppResponseKeys.id]
            : 0,
        name: expense.containsKey(AppResponseKeys.name)
            ? expense[AppResponseKeys.name]
            : '',
        details: expense.containsKey(AppResponseKeys.detailsCln)
            ? expense[AppResponseKeys.detailsCln]
            : '',
        totalPrice: expense.containsKey(AppResponseKeys.totalPrice)
            ? double.parse(expense[AppResponseKeys.totalPrice].toString())
            : 0,
        paid: expense.containsKey(AppResponseKeys.paid)
            ? double.parse(expense[AppResponseKeys.paid].toString())
            : 0,
        remainder: expense.containsKey(AppResponseKeys.remained)
            ? double.parse(expense[AppResponseKeys.remained].toString())
            : 0,
        date: expense.containsKey(AppResponseKeys.date)
            ? expense[AppResponseKeys.date]
            : '',
      ));
    }
    return expenses;
  }
}
