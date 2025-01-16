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
      body: const SafeArea(
        child: Padding(padding: EdgeInsets.all(8.0), child: Text('Category')),
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
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height / 4,
        padding: const EdgeInsets.all(16),
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
            const SizedBox(
              height: 20,
            ),

            //button should take the whole width
            ElevatedButton.icon(
              style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
                  elevation: WidgetStatePropertyAll(5),
                  alignment: Alignment.center,
                  backgroundColor: WidgetStatePropertyAll(Colors.purple)),
              label: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              icon: const FaIcon(
                FontAwesomeIcons.floppyDisk,
                color: Colors.white,
              ),
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
    );
  }
}
