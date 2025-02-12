import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:layout/model/category_model.dart';
import 'package:layout/model/menu_model.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:layout/screen/add_menu.dart';
import 'package:layout/screen/select_table.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ListMenu extends StatefulWidget {
  const ListMenu({super.key});

  @override
  State<ListMenu> createState() => _ListMenuState();
}

class _ListMenuState extends State<ListMenu> {
  CategoryModel? category;
  List<MenuModel> menues = [];
  bool isLoading = false;
  final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menus');
  Future<void> getMenus() async {
    setState(() {
      isLoading = true;
    });
    Provider.of<CafeProvider>(context, listen: false).allMenu.clear();
    QuerySnapshot<Object?> querySnapshot = await _menuCollection
        .where('category_id', isEqualTo: category!.id)
        .get();
    for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
      MenuModel menu = MenuModel(
          name: doc['name'],
          price: int.parse(doc['price']),
          description: doc['description'],
          status: doc['status'], //doc['status'],
          image_url: doc['image_url'],
          categoryId: doc['category_id']);

      menues.add(menu);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    category =
        Provider.of<CafeProvider>(context, listen: false).getSelectedCategory();
    getMenus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Menu'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : menues.isEmpty
              ? const Center(child: Text('No menu found'))
              : Center(
                  child: ListView.builder(
                      itemCount: menues.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectTableScreen()));
                          },
                          child: Card(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Image.network(
                                    '${menues[index].image_url}?project=67ac1c09002d41191574'),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                children: [
                                  Text(menues[index].name),
                                  Text(menues[index].price.toString()),
                                ],
                              ),
                            ],
                          )),
                        );
                      }),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddMenuScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
