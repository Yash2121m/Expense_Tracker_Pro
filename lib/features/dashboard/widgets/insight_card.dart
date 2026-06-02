import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InsightCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}