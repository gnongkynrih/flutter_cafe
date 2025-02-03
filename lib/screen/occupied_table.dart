import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:layout/helpers/table_helpers.dart';
import 'package:layout/model/table_model.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:layout/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class OccupiedTableScreen extends StatefulWidget {
  const OccupiedTableScreen({super.key});

  @override
  State<OccupiedTableScreen> createState() => _OccupiedTableScreenState();
}

class _OccupiedTableScreenState extends State<OccupiedTableScreen> {
  List<TableModel> tables = [];
  bool _isLoading = false;

  void getTable() async {
    setState(() {
      _isLoading = true;
    });
    tables = await TableHelpers.getTable();
    //remove the occupied tables
    tables.removeWhere((table) => table.status == true);
    // for (var table in tables) {
    //   if (table.status == true) {
    //     tables.remove(table);
    //   }
    // }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Select Table',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.purple,
        ),
        drawer: const MyDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                itemCount: tables.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  final table = tables[index];
                  return GestureDetector(
                    onTap: () {
                      Provider.of<CafeProvider>(context, listen: false)
                          .setSelectedTable(table.name);
                      Navigator.pushNamed(context, '/show_order');
                    },
                    child: Card(
                      color: Colors.purple.shade200,
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.table_bar,
                              size: 50,
                              color: tables[index].status
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(table.name),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
  }
}
