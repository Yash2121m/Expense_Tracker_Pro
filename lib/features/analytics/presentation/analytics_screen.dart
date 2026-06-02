import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/expense_utils.dart';
import '../../expenses/providers/expense_provider.dart';
import '../widgets/category_pie_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);

    final categoryTotals =
    ExpenseUtils.categoryTotals(
      expenses,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analytics",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CategoryPieChart(
              categoryTotals:
              categoryTotals,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children:
                categoryTotals.entries.map(
                      (entry) {
                    return ListTile(
                      title: Text(entry.key),
                      trailing: Text(
                        "₹${entry.value.toStringAsFixed(0)}",
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}