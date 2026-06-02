import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryTotals;

  const CategoryPieChart({
    super.key,
    required this.categoryTotals,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = [
      theme.colorScheme.primary,
      const Color(0xff60A5FA),
      const Color(0xff93C5FD),
      const Color(0xff2563EB),
      const Color(0xff1D4ED8),
    ];

    final total =
    categoryTotals.values.fold(
      0.0,
          (a, b) => a + b,
    );

    int index = 0;

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(24),
      ),

      child: SizedBox(
        height: 250,
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 55,

            sections:
            categoryTotals.entries.map(
                  (entry) {
                final color =
                colors[index++ %
                    colors.length];

                final percent =
                    (entry.value /
                        total) *
                        100;

                return PieChartSectionData(
                  value: entry.value,
                  radius: 90,
                  color: color,

                  title:
                  '${percent.toStringAsFixed(0)}%',

                  titleStyle:
                  const TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}