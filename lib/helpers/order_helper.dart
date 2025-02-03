import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:layout/model/menu_model.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:provider/provider.dart';

class OrderHelper {
  static final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menus');
  static Future<void> getMenus(context) async {
    Provider.of<CafeProvider>(context, listen: false).allMenu.clear();
    QuerySnapshot<Object?> querySnapshot = await _menuCollection.get();
    for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
      MenuModel menu = MenuModel(
          name: doc['name'],
          price: doc['price'],
          description: doc['description'],
          status: doc['status'],
          categoryId: doc['category_id']);
      Provider.of<CafeProvider>(context, listen: false).addMenuModel(menu);
    }
  }
}
