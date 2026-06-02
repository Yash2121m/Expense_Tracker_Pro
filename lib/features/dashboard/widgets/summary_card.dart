import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xffDBEAFE),
              child: Icon(
                icon,
                color: const Color(0xff2563EB),
                size: 22,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              amount,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff111827),
              ),
            ),
          ],
        ),
      ),
    );
  }
}