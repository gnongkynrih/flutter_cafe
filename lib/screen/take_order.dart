import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/helpers/category_helpers.dart';
import 'package:layout/model/category_model.dart';
import 'package:layout/model/menu_model.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class TakeOrderScreen extends StatefulWidget {
  const TakeOrderScreen({super.key});

  @override
  State<TakeOrderScreen> createState() => _TakeOrderScreenState();
}

class _TakeOrderScreenState extends State<TakeOrderScreen> {
  String selectedTable = '';
  List<CategoryModel> categories = [];
  bool _isLoading = false;
  List<MenuModel> orderedItems = []; //store the items that are ordered

  CollectionReference saleRef = FirebaseFirestore.instance.collection('sales');
  CollectionReference tableRef =
      FirebaseFirestore.instance.collection('tables');
  void initialize() async {
    try {
      setState(() {
        _isLoading = true;
      });
      selectedTable =
          Provider.of<CafeProvider>(context, listen: false).getSelectedTable();
      categories =
          Provider.of<CafeProvider>(context, listen: false).getCategories();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    initialize();

    super.initState();
  }

  Widget _buildCategory() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              color: Colors.purple.shade600,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    category.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Expanded(
      child: ListView.builder(
          itemCount: Provider.of<CafeProvider>(context, listen: false)
              .getAllMenu()
              .length,
          itemBuilder: (context, index) {
            final menu = Provider.of<CafeProvider>(context, listen: false)
                .getAllMenu()[index];
            return GestureDetector(
              onTap: () {
                showTakeOrderDialog(context, menu);
              },
              child: Card(
                color: Colors.grey.shade400,
                child: ListTile(
                  title: Text(menu.name),
                  subtitle: Row(
                    children: [
                      const Icon(
                        Icons.currency_rupee,
                        size: 15,
                      ),
                      Text(menu.price.toString()),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void showTakeOrderDialog(BuildContext context, MenuModel menu) {
    Provider.of<CafeProvider>(context, listen: false).resetQuantity();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  menu.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 50),
                          backgroundColor: Colors.purple.shade500,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Provider.of<CafeProvider>(context, listen: false)
                              .removeQuantity();
                        },
                        child: const Text(
                          '-',
                          style: TextStyle(fontSize: 25),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(Provider.of<CafeProvider>(context, listen: true)
                        .quantity
                        .toString()),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 50),
                          backgroundColor: Colors.purple.shade500,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Provider.of<CafeProvider>(context, listen: false)
                              .addQuantity();
                        },
                        child: const Text(
                          '+',
                          style: TextStyle(fontSize: 25),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade500,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      menu.quantity =
                          Provider.of<CafeProvider>(context, listen: false)
                              .getQuantity();
                      orderedItems.add(menu);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _showOrderSummary() async {
    if (orderedItems.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'No items ordered',
      );
      return;
    }

    //add sales to firebase
    var sale = {
      'status': 'pending',
      'table': selectedTable,
      'invoice_date': DateTime.now(),
      'items': orderedItems.map((item) => item.toJson()).toList(),
    };
    await saleRef.add(sale);

    //update the status of the table to occupied
    await tableRef.doc(selectedTable).update({'status': false});

    //clear the ordered items
    orderedItems.clear();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Order placed successfully',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Table: $selectedTable',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildCategory(),
                _buildMenu(),
              ],
            ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        onPressed: () {
          _showOrderSummary();
        },
        child:
            const Text('Complete Order', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
