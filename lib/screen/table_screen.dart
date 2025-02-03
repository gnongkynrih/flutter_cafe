import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:layout/helpers/table_helpers.dart';
import 'package:layout/model/table_model.dart';
import 'package:layout/widgets/my_drawer.dart';
import 'package:quickalert/quickalert.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final GlobalKey<FormState> tableForm = GlobalKey<FormState>();
  final TextEditingController _tableNameController = TextEditingController();

  final CollectionReference _tableCollection =
      FirebaseFirestore.instance.collection('tables');
  List<TableModel> tables = [];

  bool _isLoading = false;
  bool _isAdding = false;
  bool _tableStatus = true;
  void getTable() async {
    try {
      setState(() {
        _isLoading = true;
      });
      tables = await TableHelpers.getTable();
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
    getTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Table',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: tables.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final table = tables[index];
                    return ListTile(
                      title: Text(
                        table.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        table.status ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: table.status ? Colors.green : Colors.red,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const FaIcon(
                                  FontAwesomeIcons.penToSquare,
                                  size: 15,
                                ),
                                onPressed: () => {
                                      createOrEdit(context, table),
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
                                        title: 'Delete Table',
                                        text:
                                            'Are you sure you want to delete this category?',
                                        confirmBtnText: 'Yes',
                                        cancelBtnText: 'No',
                                        confirmBtnColor: Colors.purple,
                                        onConfirmBtnTap: () async {
                                          await _tableCollection
                                              .doc(table.id)
                                              .delete();
                                          setState(() {
                                            tables.remove(table);
                                          });
                                          Navigator.pop(context);
                                        },
                                      )
                                    }),
                          ],
                        ),
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

  void createOrEdit(BuildContext context, TableModel? table) {
    if (table != null) {
      _tableNameController.text = table.name;
      _tableStatus = table.status;
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
            key: tableForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _tableNameController,
                  decoration: const InputDecoration(
                    labelText: 'Table Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Table name is required';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Status :'),
                    Switch(
                      value: _tableStatus,
                      onChanged: (bool value) {
                        setModalState(() {
                          _tableStatus = value;
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
                        width: MediaQuery.of(context).size.width /
                            2, //double.infinity,
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
                            saveCategory(table?.id);
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
                                table != null
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
    TableModel table = TableModel(
      name: _tableNameController.text,
      status: _tableStatus,
    );
    try {
      var data = {
        'name': _tableNameController.text,
        'status': _tableStatus,
      };
      if (id == null) {
        await _tableCollection.add(data);
      } else {
        await _tableCollection.doc(id).update(data);
        setState(() {
          //searches for the category in the list and removes it
          tables.removeWhere((item) => item.id == id);
        });
      }

      setState(() {
        tables.add(table); //updating the category list
      });

      _tableNameController.clear();

      AnimatedSnackBar.material(
        'Table added successfully',
        duration: const Duration(seconds: 8),
        type: AnimatedSnackBarType.success,
      ).show(context);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      AnimatedSnackBar.material(
        'Error occurred while saving table',
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
