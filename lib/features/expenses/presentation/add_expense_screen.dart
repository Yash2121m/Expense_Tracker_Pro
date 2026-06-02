import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/expense_model.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final ExpenseModel? expense;
  const AddExpenseScreen({super.key, this.expense});
  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController amountController;
  final categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
  ];
  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    amountController = TextEditingController();
    if (widget.expense != null) {
      titleController.text = widget.expense!.title;
      amountController.text = widget.expense!.amount.toString();
      selectedCategory = widget.expense!.category;
      selectedDate = widget.expense!.date;
    }
    titleController.addListener(() {
      setState(() {});
    });
    amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final expense = ExpenseModel(
      id: widget.expense?.id ?? const Uuid().v4(),
      title: titleController.text.trim(),
      amount: double.parse(amountController.text.trim()),
      category: selectedCategory,
      date: selectedDate,
    );
    if (widget.expense == null) {
      await ref.read(expenseProvider.notifier).addExpense(expense);
    } else {
      await ref.read(expenseProvider.notifier).updateExpense(expense);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  String getEmoji() {
    switch (selectedCategory) {
      case 'Food':
        return '🍔';
      case 'Transport':
        return '🚗';
      case 'Shopping':
        return '🛍️';
      case 'Bills':
        return '💡';
      case 'Entertainment':
        return '🎬';
      default:
        return '💰';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffF5F7FA),
        title: Text(
          isEditing
              ? 'Edit Expense'
              : 'Add Expense',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: const Color(0xffF5F7FA),
      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor:
        Theme.of(context)
            .colorScheme
            .primary,

        foregroundColor:
        Theme.of(context)
            .colorScheme
            .onPrimary,

        elevation: 8,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(18),
        ),

        onPressed: saveExpense,

        icon: const Icon(Icons.save),

        label: Text(
          isEditing
              ? 'Update Expense'
              : 'Save Expense',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  0,
                ),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),

                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff2563EB),
                      Color(0xff1D4ED8),
                    ],
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff2563EB)
                          .withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing
                                ? 'Edit Expense'
                                : 'Add Expense',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Track and manage your spending',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                            child: Text(
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(selectedDate),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    CircleAvatar(
                      radius: 32,
                      backgroundColor:
                      Colors.white24,
                      child: Text(
                        getEmoji(),
                        style: const TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Expense Title',
                                  prefixIcon: Icon(Icons.edit),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter title';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Amount',
                                  prefixIcon: Icon(Icons.currency_rupee),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter amount';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Invalid amount';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Category',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(

                                spacing: 8,
                                runSpacing: 8,
                                children: categories.map((category) {
                                  return ChoiceChip(
                                    label: Text(category),

                                    selected: selectedCategory == category,

                                    selectedColor:
                                    Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,

                                    backgroundColor:
                                    Colors.grey.shade100,

                                    labelStyle: TextStyle(
                                      color:
                                      selectedCategory == category
                                          ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),

                                    checkmarkColor:
                                    Theme.of(context)
                                        .colorScheme
                                        .primary,

                                    side: BorderSide(
                                      color:
                                      selectedCategory == category
                                          ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          : Colors.grey.shade300,
                                    ),

                                    onSelected: (_) {
                                      setState(() {
                                        selectedCategory = category;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                tileColor: Colors.grey.shade100,
                                leading: const Icon(Icons.calendar_month),
                                title: const Text('Expense Date'),
                                subtitle: Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(selectedDate),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: pickDate,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preview',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                radius: 24,
                                child: Text(getEmoji()),
                              ),
                              title: Text(
                                titleController.text.isEmpty
                                    ? 'Expense Title'
                                    : titleController.text,
                              ),
                              subtitle: Text(selectedCategory),
                              trailing: Text(
                                amountController.text.isEmpty
                                    ? '₹0'
                                    : '₹${amountController.text}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
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
