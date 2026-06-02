import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<double> values;

  const MonthlyBarChart({
    super.key,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          borderData:
          FlBorderData(show: false),

          titlesData:
          FlTitlesData(show: true),

          gridData: FlGridData(
            drawVerticalLine: false,
          ),

          barGroups: List.generate(
            values.length,
                (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index],

                  width: 18,

                  gradient:
                  const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xff60A5FA),
                      Color(0xff2563EB),
                    ],
                  ),

                  borderRadius:
                  BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}