import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/model/category_model.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:provider/provider.dart';

class CategoryHelpers {
  static final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  static Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categories = [];
    try {
      QuerySnapshot<Object?> categorySnapshot = await _categoryCollection.get();
      for (QueryDocumentSnapshot<Object?> doc in categorySnapshot.docs) {
        CategoryModel category =
            CategoryModel(name: doc['name'], status: doc['status'], id: doc.id);
        categories.add(category);
      }
    } catch (e) {
      //print(e);
    }
    return categories;
  }

  static Future<void> getAllCategories(context) async {
    try {
      Provider.of<CafeProvider>(context, listen: false).allCategories.clear();
      QuerySnapshot<Object?> categorySnapshot = await _categoryCollection.get();
      for (QueryDocumentSnapshot<Object?> doc in categorySnapshot.docs) {
        CategoryModel category =
            CategoryModel(name: doc['name'], status: doc['status'], id: doc.id);
        Provider.of<CafeProvider>(context, listen: false).addCategory(category);
      }
    } catch (e) {
      //print(e);
    }
  }
}
