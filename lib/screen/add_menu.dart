import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as aw;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:layout/model/category_model.dart';
import 'package:layout/provider/cafe_provider.dart';
import 'package:layout/widgets/my_drawer.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key});
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
  CategoryModel? category;

  late final Client client;
  late final Storage storage;
  String _imageUrl = '';
  static const String _bucketId = '67ac1d500021cae5edd4';
  // late final Databases databases;

  final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menus');
  final uploadStreamController = StreamController<double>();
  @override
  void initState() {
    super.initState();
    category =
        Provider.of<CafeProvider>(context, listen: false).getSelectedCategory();

    _nameController.text = category!.name;

    // Initialize Appwrite client (do this outside your function, ideally in your app's initialization)
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('67ac1c09002d41191574');

    storage = Storage(client); // Initialize Appwrite storage
    // databases = Databases(client); // Initialize Appwrite databases
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_imageUrl.isEmpty) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          text: 'Image not uploaded. Continue save?',
          confirmBtnText: 'Save',
          cancelBtnText: 'Cancel',
          onCancelBtnTap: () {
            return;
          });
    }
    setState(() => isLoading = true);
    try {
      //use firebase database not appwrite
      await _menuCollection.add({
        'name': _nameController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'status': _menuStatus,
        'category_id': category!.id,
        'image_url': _imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Create the document in Appwrite
      // final databases = Databases(client);
      // await databases.createDocument(
      //   databaseId: '67a44ee70021df78df34', // Replace with your database ID
      //   collectionId: 'menus', // Replace with your collection ID
      //   documentId: ID.unique(),
      //   data: {
      //     'name': _nameController.text,
      //     'price': _priceController.text,
      //     'description': _descriptionController.text,
      //     'status': _menuStatus,
      //     'category_id': category!.id,
      //     'image_url': _imageUrl,
      //     'created_at': DateTime.now().toIso8601String(),
      //   },
      // );

      AnimatedSnackBar.material(
        'Menu added successfully',
        duration: const Duration(seconds: 6),
        type: AnimatedSnackBarType.success,
      ).show(context);
      Navigator.pop(context);
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

  Future<void> _pickAndCropImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) {
      return;
    }
    File pickedFile = File(image.path); // Use the selected image!.path;
    File imageToUpload; // Variable to hold the image to upload

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.original,
      //   CropAspectRatioPreset.square,
      //   CropAspectRatioPreset.ratio4x3,
      //   CropAspectRatioPreset.ratio16x9
      // ],
      // uiSettings: [
      //   AndroidUiSettings(
      //     toolbarTitle: 'Crop Image',
      //     toolbarColor: Colors.purple,
      //     toolbarWidgetColor: Colors.white,
      //     activeControlsWidgetColor: Colors.purple,
      //     hideBottomControls: false,
      //   ),
      //   IOSUiSettings(
      //     title: 'Crop Image',
      //     aspectRatioPickerButtonHidden: false,
      //   )
      // ],
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 70,
    );

    if (croppedFile != null) {
      imageToUpload = File(croppedFile.path);

      // Validate image size (max 5MB)
      final fileSize = await imageToUpload.length();
      if (fileSize > 5 * 1024 * 1024) {
        AnimatedSnackBar.material(
          'Image too large (max 5MB)',
          type: AnimatedSnackBarType.error,
        ).show(context);
        return;
      }

      try {
        showDialog(
          // Show a simple loading indicator
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text('Uploading...'),
              ],
            ),
          ),
        );
        const uuid = Uuid(); // Create a UUID object
        final fileId = uuid.v4(); // Generate a v4 UUID
        //give random file id
        final file = await storage.createFile(
          bucketId: _bucketId,
          fileId: fileId,
          file: InputFile.fromPath(
              path: imageToUpload.path), // Upload the selected image
        );
        //get image url
        String url =
            'https://cloud.appwrite.io/v1/storage/buckets/$_bucketId/files/${file.$id}/view';
        final imageUrl = Uri.parse(url);
        _imageUrl = imageUrl.toString();
        AnimatedSnackBar.material(
          'Image uploaded successfully',
          duration: const Duration(seconds: 6),
          type: AnimatedSnackBarType.success,
        ).show(context);
        // Update menu document with image URL
        // await databases.createDocument(
        //   databaseId: '67ac1c09002d41191574', // Replace with your database ID
        //   collectionId: 'menus', // Replace with your collection ID
        //   documentId: ID.unique(),
        //   data: {
        //     'name': _nameController.text,
        //     'price': _priceController.text,
        //     'description': _descriptionController.text,
        //     'status': _menuStatus,
        //     'category_id': category!.id,
        //     'image_url': imageUrl.toString(),
        //     'created_at': DateTime.now().toIso8601String(),
        //   },
        // );
      } catch (e) {
        print(e);
        AnimatedSnackBar.material(
          'Error uploading image to Appwrite: $e',
          duration: const Duration(seconds: 6),
          type: AnimatedSnackBarType.error,
        ).show(context);
      } finally {
        Navigator.of(context).pop();
      }
    } else {
      imageToUpload = pickedFile; // Use original image if not cropped
    }
  }

  void showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content: const Text('Choose how to select an image:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickAndCropImage(ImageSource.gallery);
              },
              child: const Column(
                children: [
                  FaIcon(FontAwesomeIcons.image),
                  SizedBox(height: 8),
                  Text('Gallery'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickAndCropImage(ImageSource.camera);
              },
              child: const Column(
                children: [
                  FaIcon(FontAwesomeIcons.camera),
                  SizedBox(height: 8),
                  Text('Camera'),
                ],
              ),
            ),
          ],
        );
      },
    );
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
            Text('Category : ${category!.name}'),
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
                  GestureDetector(
                    onTap: () {
                      showImageSelectionDialog();
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.purple,
                        ),
                        SizedBox(width: 10),
                        Text('Upload Image')
                      ],
                    ),
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
