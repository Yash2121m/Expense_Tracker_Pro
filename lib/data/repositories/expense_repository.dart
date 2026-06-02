import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  final Box<ExpenseModel> expenseBox =
  Hive.box<ExpenseModel>('expenses');

  List<ExpenseModel> getExpenses() {
    return expenseBox.values.toList();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await expenseBox.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await expenseBox.delete(id);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await expenseBox.put(expense.id, expense);
  }
}