import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:layout/helpers/category_helpers.dart';
import 'package:layout/helpers/order_helper.dart';
import 'package:layout/screen/select_table.dart';
import 'package:layout/widgets/dashboard_widget.dart';
import 'package:layout/widgets/my_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            InkWell(
              onTap: () {
                OrderHelper.getMenus(context);
                CategoryHelpers.getAllCategories(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelectTableScreen()),
                );
              },
              child: const DashboardWidget(
                  tableNumber: "Take Order", icon: Icons.takeout_dining),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/occupied_tables');
              },
              child: const DashboardWidget(
                  tableNumber: "Complete Order", icon: Icons.done),
            ),
            const DashboardWidget(
                tableNumber: "Cancel Order", icon: Icons.cancel),
            const DashboardWidget(tableNumber: "Reports", icon: Icons.report),
          ],
        ),
      ),
    );
  }
}
