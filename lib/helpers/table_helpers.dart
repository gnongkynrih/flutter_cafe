import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/model/table_model.dart';

class TableHelpers {
  static Future<List<TableModel>> getTable() async {
    List<TableModel>? tables = [];
    CollectionReference tableCollection =
        FirebaseFirestore.instance.collection('tables');
    try {
      QuerySnapshot<Object?> tableSnapshot = await tableCollection.get();
      for (QueryDocumentSnapshot<Object?> doc in tableSnapshot.docs) {
        TableModel table =
            TableModel(name: doc['name'], status: doc['status'], id: doc.id);
        tables.add(table);
      }
    } catch (e) {
      print(e);
    }
    return tables;
  }
}
