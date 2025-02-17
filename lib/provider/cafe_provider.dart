import 'package:flutter/material.dart';
import 'package:layout/model/category_model.dart';
import 'package:layout/model/menu_model.dart';

class CafeProvider with ChangeNotifier {
  CategoryModel? _selectedCategory;
  String _selectedTable = '';
  List<MenuModel> allMenu = [];
  List<CategoryModel> allCategories = [];
  int quantity = 1;
  String userMobile = '';
  String otpCode = '';

  String getOtpCode() {
    return otpCode;
  }

  void setOtpCode(String code) {
    otpCode = code;
    notifyListeners();
  }

  String getMobileNo() {
    return userMobile;
  }

  void setMobileNo(String no) {
    userMobile = no;
    notifyListeners();
  }

  int getQuantity() {
    return quantity;
  }

  void resetQuantity() {
    quantity = 1;
    notifyListeners();
  }

  void addQuantity() {
    quantity++;
    notifyListeners();
  }

  void removeQuantity() {
    if (quantity == 1) return;
    quantity--;
    notifyListeners();
  }

  void addCategory(CategoryModel category) {
    allCategories.add(category);
    notifyListeners();
  }

  List<CategoryModel> getCategories() {
    return allCategories;
  }

  void addMenuModel(MenuModel menu) {
    allMenu.add(menu);
    notifyListeners();
  }

  List<MenuModel> getAllMenu() {
    return allMenu;
  }

  void setSelectedTable(String table) {
    _selectedTable = table;
    notifyListeners();
  }

  String getSelectedTable() {
    return _selectedTable;
  }

  void setSelectedCategory(CategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  CategoryModel? getSelectedCategory() {
    return _selectedCategory;
  }
}
