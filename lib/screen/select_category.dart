import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:layout/model/category_model.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:layout/screen/add_menu.dart';
import 'package:layout/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  List<CategoryModel> categories = [];
  bool _isLoading = false;

  void getCategories() async {
    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot<Object?> categorySnapshot = await _categoryCollection.get();
      for (QueryDocumentSnapshot<Object?> doc in categorySnapshot.docs) {
        CategoryModel category =
            CategoryModel(name: doc['name'], status: doc['status'], id: doc.id);
        categories.add(category);
      }
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
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Category',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const MyDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      //store the selected category in the provider
                      Provider.of<CafeProvider>(context, listen: false)
                          .setSelectedCategory(category);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddMenuScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(category.name)),
                    ),
                  );
                },
              )),
    );
  }
}
