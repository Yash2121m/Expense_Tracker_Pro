import '../../data/models/expense_model.dart';

class ExpenseUtils {
  static Map<String, double> categoryTotals(
      List<ExpenseModel> expenses,
      ) {
    final Map<String, double> totals = {};

    for (final expense in expenses) {
      totals.update(
        expense.category,
            (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return totals;
  }
}