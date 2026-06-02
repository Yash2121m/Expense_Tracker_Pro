import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/expense_model.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final ExpenseModel? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  ConsumerState<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController amountController;

  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
  ];

  String selectedCategory = 'Food';

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    amountController = TextEditingController();

    if (widget.expense != null) {
      titleController.text = widget.expense!.title;
      amountController.text =
          widget.expense!.amount.toString();

      selectedCategory = widget.expense!.category;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final expense = ExpenseModel(
      id: widget.expense?.id ??
          const Uuid().v4(),
      title: titleController.text.trim(),
      amount:
      double.parse(amountController.text.trim()),
      category: selectedCategory,
      date: widget.expense?.date ??
          DateTime.now(),
    );

    if (widget.expense == null) {
      await ref
          .read(expenseProvider.notifier)
          .addExpense(expense);
    } else {
      await ref
          .read(expenseProvider.notifier)
          .updateExpense(expense);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Edit Expense'
              : 'Add Expense',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration:
                const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: amountController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Enter amount';
                  }

                  if (double.tryParse(value) ==
                      null) {
                    return 'Invalid amount';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration:
                const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category',
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: saveExpense,
                  child: Text(
                    isEditing
                        ? 'Update Expense'
                        : 'Save Expense',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}