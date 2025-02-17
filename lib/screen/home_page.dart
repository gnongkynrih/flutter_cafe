import 'package:flutter/material.dart';
import 'package:layout/screen/category_screen.dart';
import 'package:layout/screen/dashboard_screen.dart';
import 'package:layout/screen/show_order.dart';
import 'package:layout/screen/take_order.dart';
import 'package:layout/widgets/my_drawer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> screens = [
    const TakeOrderScreen(),
    const DashboardScreen(),
    const ShowOrderScreen(),
    const CategoryScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: const MyDrawer(),
      body: screens[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Take order'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Dashboard'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.takeout_dining),
            title: const Text('Show Order'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.done),
            title: const Text('Category'),
          ),
        ],
      ),
    );
  }
}
