import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/repositories/expense_repository.dart';

final expenseRepositoryProvider =
Provider((ref) => ExpenseRepository());

final expenseProvider =
StateNotifierProvider<ExpenseNotifier, List<ExpenseModel>>(
      (ref) => ExpenseNotifier(
    ref.read(expenseRepositoryProvider),
  ),
);

class ExpenseNotifier extends StateNotifier<List<ExpenseModel>> {
  final ExpenseRepository repository;

  ExpenseNotifier(this.repository) : super([]) {
    loadExpenses();
  }

  void loadExpenses() {
    state = repository.getExpenses();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await repository.addExpense(expense);
    loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await repository.deleteExpense(id);
    loadExpenses();
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await repository.updateExpense(expense);
    loadExpenses();
  }
}