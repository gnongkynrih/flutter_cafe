import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/model/menu_model.dart';

class SaleModel {
  String id;
  String status;
  String table;
  DateTime invoiceDate;
  String? invoiceNumber;
  List<MenuModel> orders;

  SaleModel({
    required this.id,
    required this.status,
    required this.table,
    required this.invoiceDate,
    this.invoiceNumber,
    required this.orders,
  });

  SaleModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        table = json['table'],
        invoiceDate = (json['invoice_date'] as Timestamp).toDate(),
        invoiceNumber = json['invoice_number'],
        orders = (json['items'] as List)
            .map((item) => MenuModel.fromJson(item))
            .toList();
}
