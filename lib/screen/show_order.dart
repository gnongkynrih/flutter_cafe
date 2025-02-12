import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/model/sale_model.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class ShowOrderScreen extends StatefulWidget {
  const ShowOrderScreen({super.key});

  @override
  State<ShowOrderScreen> createState() => _ShowOrderScreenState();
}

class _ShowOrderScreenState extends State<ShowOrderScreen> {
  CollectionReference salesRef = FirebaseFirestore.instance.collection('sales');
  CollectionReference tableRef =
      FirebaseFirestore.instance.collection('tables');
  late SaleModel sale;
  bool isLoading = false;
  String hasOrder = '';
  Future<void> getOrders() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot<Object?> salesSnapshot = await salesRef
        .where('table',
            isEqualTo: Provider.of<CafeProvider>(context, listen: false)
                .getSelectedTable())
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    if (salesSnapshot.docs.isNotEmpty) {
      final doc = salesSnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add the document ID to the data
      sale = SaleModel.fromJson(data);
      setState(() {
        hasOrder = 'yes';
      });
    } else {
      setState(() {
        hasOrder = 'no';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasOrder == 'no'
              ? const Center(child: Text('No order'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const SizedBox(height: 10,
                      // child:ListTile(
                      //   leading: Text('Sl'),
                      //   title: Text('Item'),
                      //   trailing: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Text('Price'),
                      //       SizedBox(width: 10),
                      //       Text('Qty'),
                      //       SizedBox(width: 10),
                      //     Text('Total'),
                      //   ],
                      // ),),
                      Expanded(
                        child: ListView.builder(
                            itemCount: sale.orders.length,
                            itemBuilder: (context, index) {
                              final order = sale.orders[index];
                              return ListTile(
                                leading: Text((index + 1).toString()),
                                title: Text(order.name),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(order.price.toString()),
                                    const SizedBox(width: 10),
                                    Text(order.quantity.toString()),
                                    const SizedBox(width: 10),
                                    Text((order.quantity * order.price)
                                        .toString()),
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
      bottomNavigationBar: hasOrder == 'yes'
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  text: 'Confirm payment',
                  confirmBtnText: 'Pay',
                  onConfirmBtnTap: () async {
                    //find the table document in the table collection
                    QuerySnapshot<Object?> tableSnapshot = await tableRef
                        .where('name', isEqualTo: sale.table)
                        .limit(1)
                        .get();
                    var doc = tableSnapshot.docs.first;
                    //update the status of the table to paid
                    await tableRef.doc(doc.id).update({'status': true});
                    //update the status of the sale to paid
                    await salesRef.doc(sale.id).update({
                      'status': 'paid',
                      'invoice_number': Random().nextInt(100000).toString(),
                    });
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Payment successful',
                    );
                    Navigator.pushNamed(context, '/dashboard');
                  },
                );
              },
              child: const Text(
                'Make Payment',
                style: TextStyle(color: Colors.white),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
