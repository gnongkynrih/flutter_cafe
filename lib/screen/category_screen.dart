import 'dart:ffi';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:layout/model/category_model.dart';

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
                              onPressed: () =>
                                  {} //_showCategoryBottomSheet(category),
                              ),
                          IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.trash,
                                color: Colors.red,
                                size: 15,
                              ),
                              onPressed: () =>
                                  {} // _deleteCategory(category.id),
                              ),
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
          createOrEdit(context);
        },
      ),
    );
  }

  void createOrEdit(BuildContext context) {
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
                _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
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
                          onPressed:
                              // _isLoading ? null : () => _saveCategory(category?.id),

                              () => saveCategory(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.floppyDisk,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                // category != null ? 'Update' : 'Save',
                                'save',
                                style: TextStyle(color: Colors.white),
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

  void saveCategory() async {
    setState(() {
      _isLoading = true;
    });
    CategoryModel category = CategoryModel(
      name: _categoryNameController.text,
      status: _categoryStatus,
    );
    try {
      var data = {
        'name': _categoryNameController.text,
        'status': _categoryStatus,
      };
      await _categoryCollection.add(data);
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
