import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/model/category_model.dart';
import 'package:layout/widgets/my_drawer.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key, required this.category});
  final CategoryModel category;
  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
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
        child: Center(child: Text(widget.category.name)),
      ),
    );
  }
}
