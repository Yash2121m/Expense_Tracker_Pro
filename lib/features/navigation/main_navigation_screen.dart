import 'package:flutter/material.dart';
import '../analytics/presentation/analytics_screen.dart';
import '../dashboard/presentation/dashboard_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
  });

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final screens = [
    const DashboardScreen(),
    const AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,

          indicatorColor: const Color(
            0xffDBEAFE,
          ), // Light Blue

          iconTheme:
          WidgetStateProperty.resolveWith(
                (states) {
              if (states.contains(
                  WidgetState.selected)) {
                return const IconThemeData(
                  color: Color(0xff2563EB),
                  size: 26,
                );
              }

              return const IconThemeData(
                color: Colors.grey,
                size: 24,
              );
            },
          ),

          labelTextStyle:
          WidgetStateProperty.resolveWith(
                (states) {
              return TextStyle(
                color: states.contains(
                    WidgetState.selected)
                    ? const Color(
                  0xff2563EB,
                )
                    : Colors.grey,
                fontWeight: FontWeight.w600,
              );
            },
          ),
        ),
        child: NavigationBar(
          height: 70,
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(
                  Icons.pie_chart_outline),
              selectedIcon:
              Icon(Icons.pie_chart),
              label: 'Analytics',
            ),
          ],
        ),
      ),
    );
  }
}