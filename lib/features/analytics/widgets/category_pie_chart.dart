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
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    int index = 0;

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: categoryTotals.entries.map((entry) {
            final color =
            colors[index++ % colors.length];

            return PieChartSectionData(
              value: entry.value,
              title: entry.key,
              radius: 100,
              color: color,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}