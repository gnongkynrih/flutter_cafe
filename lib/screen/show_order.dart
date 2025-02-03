import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/model/sale_model.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:provider/provider.dart';

class ShowOrderScreen extends StatefulWidget {
  const ShowOrderScreen({super.key});

  @override
  State<ShowOrderScreen> createState() => _ShowOrderScreenState();
}

class _ShowOrderScreenState extends State<ShowOrderScreen> {
  CollectionReference salesRef = FirebaseFirestore.instance.collection('sales');
  late SaleModel sale;
  bool isLoading = false;

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
      sale = SaleModel(
          table: salesSnapshot.docs.first['table'],
          id: salesSnapshot.docs.first.id,
          status: salesSnapshot.docs.first['status'],
          orders: salesSnapshot.docs.first['items'],
          invoiceDate: salesSnapshot.docs.first['invoice_date']);
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
            : Text(sale.table));
  }
}
