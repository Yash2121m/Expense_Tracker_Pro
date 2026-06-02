import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onEdit;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onEdit,
  });

  String getEmoji(String category) {
    switch (category) {
      case 'Food':
        return '🍔';
      case 'Transport':
        return '🚗';
      case 'Shopping':
        return '🛍️';
      case 'Bills':
        return '💡';
      default:
        return '💰';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          radius: 24,
          child: Text(
            getEmoji(expense.category),
          ),
        ),

        title: Text(
          expense.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(
          DateFormat(
            'dd MMM yyyy',
          ).format(expense.date),
        ),

        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            Text(
              '₹${expense.amount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            GestureDetector(
              onTap: onEdit,
              child: const Icon(
                Icons.edit,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}