import 'package:flutter/material.dart';
import 'package:layout/model/category_model.dart';

class CafeProvider with ChangeNotifier {
  CategoryModel? _selectedCategory;

  void setSelectedCategory(CategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  CategoryModel? getSelectedCategory() {
    return _selectedCategory;
  }
}
