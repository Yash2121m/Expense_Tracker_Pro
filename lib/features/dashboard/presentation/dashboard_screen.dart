import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/expense_utils.dart';
import '../../expenses/presentation/add_expense_screen.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../expenses/widgets/expense_card.dart';
import '../widgets/insight_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);

    final totalExpense = expenses.fold<double>(
      0,
          (sum, expense) => sum + expense.amount,
    );

    final highestCategory =
    AnalyticsUtils.highestCategory(
      expenses,
    );

    final averageExpense =
    AnalyticsUtils.averageExpense(
      expenses,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff1D4ED8),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddExpenseScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Expense',
        ),
      ),

      body: Column(
        children: [
          /// TOTAL EXPENSE CARD
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(28),

              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff2563EB),
                  Color(0xff1E40AF),
                ],
              ),

              boxShadow: [
                BoxShadow(
                  color:
                  Color(0xff2563EB)
                      .withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '₹${totalExpense.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                        Colors.white24,
                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                      ),
                      child: Text(
                        '${expenses.length} Transactions',
                        style:
                        const TextStyle(
                          color:
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// SUMMARY CARDS
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Transactions',
                    value: expenses.length.toString(),
                    icon: Icons.receipt_long,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _SummaryCard(
                    title: 'Categories',
                    value: expenses
                        .map((e) => e.category)
                        .toSet()
                        .length
                        .toString(),
                    icon: Icons.category,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                InsightCard(
                  title: 'Top Category',
                  value: highestCategory,
                  icon: Icons.star,
                ),

                const SizedBox(width: 12),

                InsightCard(
                  title: 'Avg Expense',
                  value:
                  '₹${averageExpense.toStringAsFixed(0)}',
                  icon: Icons.analytics,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// RECENT TRANSACTIONS
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// EXPENSE LIST
          Expanded(
            child: expenses.isEmpty
                ? const Center(
              child: Text(
                'No Expenses Found',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];

                return Dismissible(
                  key: ValueKey(expense.id),

                  direction:
                  DismissDirection.endToStart,

                  background: Container(
                    margin:
                    const EdgeInsets.only(
                      bottom: 12,
                    ),
                    alignment:
                    Alignment.centerRight,
                    padding:
                    const EdgeInsets.only(
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),

                  onDismissed: (_) {
                    ref
                        .read(
                      expenseProvider
                          .notifier,
                    )
                        .deleteExpense(
                      expense.id,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Expense Deleted',
                        ),
                      ),
                    );
                  },

                  child: ExpenseCard(
                    expense: expense,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddExpenseScreen(
                                expense: expense,
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          CircleAvatar(
            backgroundColor:
            const Color(0xffDBEAFE),
            child: Icon(
              icon,
              color:
              const Color(
                0xff2563EB,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style:
            const TextStyle(
              color:
              Colors.grey,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style:
            const TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}