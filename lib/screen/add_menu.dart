import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/model/category_model.dart';
import 'package:layout/widgets/my_drawer.dart';
import 'package:quickalert/quickalert.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key, required this.category});
  final CategoryModel category;
  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _menuStatus = true;
  bool isLoading = false;

  Future<void> _submitForm() async {
    //menuCollection points to menus in firebase
    CollectionReference menuCollection =
        FirebaseFirestore.instance.collection('menus');

    setState(() {
      isLoading = true;
    });
    try {
      var data = {
        'name': _nameController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'status': _menuStatus,
        'category_id': widget.category.id,
      };
      await menuCollection.add(data);
      AnimatedSnackBar.material(
        'Menu added successfully',
        duration: const Duration(seconds: 6),
        type: AnimatedSnackBarType.success,
      );

      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: e.toString(),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Menu',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Category : ${widget.category.name}'),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      //  border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Status:'),
                      const SizedBox(width: 10),
                      Switch(
                          activeColor: Colors.purple,
                          activeTrackColor: Colors.blue.shade100,
                          value: _menuStatus,
                          onChanged: (value) {
                            setState(() {
                              _menuStatus = value;
                            });
                          }),
                      const SizedBox(width: 10),
                      Text(_menuStatus ? 'Active' : 'Inactive')
                    ],
                  ),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _submitForm();
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
