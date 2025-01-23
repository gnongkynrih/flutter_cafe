import 'dart:ffi';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:layout/model/category_model.dart';
import 'package:layout/widgets/my_drawer.dart';
import 'package:quickalert/quickalert.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _categoryNameController = TextEditingController();
  final GlobalKey<FormState> categoryForm = GlobalKey<FormState>();

  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  List<CategoryModel> categories = [];
  bool _isLoading = false;
  bool _isAdding = false;
  bool _categoryStatus = true;
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
          'Add Category',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isLoading == true //if loading ? do this : do this
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      title: Text(
                        category.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        category.status ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: category.status ? Colors.green : Colors.red,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.penToSquare,
                                size: 15,
                              ),
                              onPressed: () => {
                                    createOrEdit(context, category),
                                  }),
                          IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.trash,
                                color: Colors.red,
                                size: 15,
                              ),
                              onPressed: () => {
                                    QuickAlert.show(
                                      barrierDismissible: false,
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      title: 'Delete Category',
                                      text:
                                          'Are you sure you want to delete this category?',
                                      confirmBtnText: 'Yes',
                                      cancelBtnText: 'No',
                                      confirmBtnColor: Colors.purple,
                                      onConfirmBtnTap: () async {
                                        await _categoryCollection
                                            .doc(category.id)
                                            .delete();
                                        setState(() {
                                          categories.remove(category);
                                        });
                                        Navigator.pop(context);
                                      },
                                    )
                                  }),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const FaIcon(FontAwesomeIcons.plus),
        onPressed: () {
          createOrEdit(context, null);
        },
      ),
    );
  }

  void createOrEdit(BuildContext context, CategoryModel? category) {
    if (category != null) {
      _categoryNameController.text = category.name;
      _categoryStatus = category.status;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: categoryForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _categoryNameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Category name is required';
                    }
                    if (value.length < 5) {
                      return 'Category name must be at least 5 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Status :'),
                    Switch(
                      value: _categoryStatus,
                      onChanged: (bool value) {
                        setModalState(() {
                          _categoryStatus = value;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                _isAdding
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.purple,
                          strokeWidth: 2,
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.all(16),
                            disabledBackgroundColor:
                                Colors.purple.withOpacity(0.6),
                          ),
                          onPressed: () {
                            setModalState(() {
                              _isAdding = true;
                            });
                            saveCategory(category?.id);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.floppyDisk,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category != null
                                    ? 'Update Category'
                                    : 'Add Category',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveCategory(String? id) async {
    CategoryModel category = CategoryModel(
      name: _categoryNameController.text,
      status: _categoryStatus,
    );
    try {
      var data = {
        'name': _categoryNameController.text,
        'status': _categoryStatus,
      };
      if (id == null) {
        await _categoryCollection.add(data);
      } else {
        await _categoryCollection.doc(id).update(data);
        setState(() {
          //searches for the category in the list and removes it
          categories.removeWhere((item) => item.id == id);
        });
      }

      setState(() {
        categories.add(category); //updating the category list
      });

      _categoryNameController.clear();

      AnimatedSnackBar.material(
        'Category added successfully',
        duration: const Duration(seconds: 6),
        type: AnimatedSnackBarType.success,
      ).show(context);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      AnimatedSnackBar.material(
        'Error occurred while saving category',
        duration: const Duration(seconds: 6),
        type: AnimatedSnackBarType.error,
      ).show(context);
    } finally {
      setState(() {
        _isAdding = false;
      });
    }
  }
}
