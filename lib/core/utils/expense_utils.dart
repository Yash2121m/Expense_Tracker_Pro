import '../../data/models/expense_model.dart';

class AnalyticsUtils {
  static double totalExpense(
      List<ExpenseModel> expenses,
      ) {
    return expenses.fold(
      0,
          (sum, expense) => sum + expense.amount,
    );
  }

  static String highestCategory(
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

    if (totals.isEmpty) return '-';

    return totals.entries
        .reduce(
          (a, b) =>
      a.value > b.value ? a : b,
    )
        .key;
  }

  static double averageExpense(
      List<ExpenseModel> expenses,
      ) {
    if (expenses.isEmpty) return 0;

    return totalExpense(expenses) /
        expenses.length;
  }

  static List<double> monthlyTotals(
      List<ExpenseModel> expenses,
      ) {
    List<double> months =
    List.filled(12, 0);

    for (final expense in expenses) {
      months[
      expense.date.month - 1] +=
          expense.amount;
    }

    return months;
  }
}

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