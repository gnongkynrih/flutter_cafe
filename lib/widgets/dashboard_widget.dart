import 'package:flutter/material.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({
    super.key,
    required this.tableNumber,
    required this.icon,
  });
  final String tableNumber;
  final IconData icon;
  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.purple.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: Colors.white,
            size: 35,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.tableNumber,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
