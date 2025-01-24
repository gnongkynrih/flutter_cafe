class MenuModel {
  final String categoryId;
  final String name;
  final String price;
  final String description;
  final String? id;
  final bool status;
  MenuModel({
    required this.categoryId,
    required this.name,
    required this.price,
    required this.description,
    this.id,
    this.status = true,
  });
}
