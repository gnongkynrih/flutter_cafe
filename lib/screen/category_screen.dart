import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String categoryName = '';
  final GlobalKey<FormState> categoryForm = GlobalKey<FormState>();

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
          child: Form(
            key: categoryForm,
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(
                  // border: OutlineInputBorder(),
                  labelText: 'Enter Category',
                ),
                onChanged: (value) {
                  setState(() {
                    categoryName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category cannot be blank';
                  }
                  if (value.length < 5) {
                    return 'Category must be at least 5 characters';
                  }
                  return null;
                },
              ),
              ElevatedButton.icon(
                label: const Text('Save'),
                icon: const FaIcon(FontAwesomeIcons.floppyDisk),
                onPressed: () {
                  bool noerror = categoryForm.currentState!.validate();
                  if (noerror) {
                    print('everything is fine');
                  }
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
