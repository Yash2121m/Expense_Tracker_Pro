import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/expense_utils.dart';
import '../../expenses/providers/expense_provider.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_bar_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);

    if (expenses.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
        ),
        body: const Center(
          child: Text(
            'No expenses available',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final categoryTotals =
    ExpenseUtils.categoryTotals(expenses);

    final monthlyTotals =
    AnalyticsUtils.monthlyTotals(expenses);

    final totalExpense = expenses.fold<double>(
      0,
          (sum, expense) => sum + expense.amount,
    );

    final averageExpense =
        totalExpense / expenses.length;

    final topCategory =
    categoryTotals.entries.isNotEmpty
        ? categoryTotals.entries
        .reduce(
          (a, b) =>
      a.value > b.value ? a : b,
    )
        .key
        : '-';

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Analytics')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
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
                      color: const Color(
                        0xff2563EB,
                      ).withValues(alpha: 0.25),
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
                          const Text(
                            'Financial Insights',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '₹${totalExpense.toStringAsFixed(0)} Total Spent',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
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
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$topCategory • Top Category',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    CircleAvatar(
                      radius: 34,
                      backgroundColor:
                      Colors.white24,
                      child: const Icon(
                        Icons.pie_chart,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _AnalyticsCard(
                      title: 'Transactions',
                      value:
                      expenses.length.toString(),
                      icon: Icons.receipt_long,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _AnalyticsCard(
                      title: 'Average',
                      value:
                      '₹${averageExpense.toStringAsFixed(0)}',
                      icon: Icons.analytics,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// PIE CHART
              const Text(
                'Category Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding:
                const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withValues(
                        alpha: 0.05,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: CategoryPieChart(
                  categoryTotals:
                  categoryTotals,
                ),
              ),

              const SizedBox(height: 30),

              /// BAR CHART
              const Text(
                'Monthly Spending',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding:
                const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withValues(
                        alpha: 0.05,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: MonthlyBarChart(
                  values: monthlyTotals,
                ),
              ),

              const SizedBox(height: 30),

              /// CATEGORY TOTALS
              const Text(
                'Category Totals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ...categoryTotals.entries.map(
                    (entry) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        _emojiForCategory(
                          entry.key,
                        ),
                      ),
                    ),
                    title: Text(entry.key),
                    trailing: Text(
                      '₹${entry.value.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  static String _emojiForCategory(
      String category,
      ) {
    switch (category) {
      case 'Food':
        return '🍔';

      case 'Shopping':
        return '🛍️';

      case 'Transport':
        return '🚗';

      case 'Bills':
        return '💡';

      case 'Entertainment':
        return '🎬';

      default:
        return '💰';
    }
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
            theme.colorScheme
                .primaryContainer,

            child: Icon(
              icon,
              color:
              theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
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

class MonthlyBarChart extends StatelessWidget {
  final List<double> values;

  const MonthlyBarChart({
    super.key,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    const months = [
      'J',
      'F',
      'M',
      'A',
      'M',
      'J',
      'J',
      'A',
      'S',
      'O',
      'N',
      'D',
    ];

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          borderData:
          FlBorderData(show: false),

          gridData:
          FlGridData(show: true),

          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles:
              SideTitles(showTitles: false),
            ),

            rightTitles: AxisTitles(
              sideTitles:
              SideTitles(showTitles: false),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget:
                    (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() <
                          months.length) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text(
                        months[value.toInt()],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),

          barGroups: List.generate(
            values.length,
                (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index],
                  width: 18,
                  borderRadius:
                  BorderRadius.circular(6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}