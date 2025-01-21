class CategoryModel {
  final String name;
  final bool status;
  final String? id;

  const CategoryModel({
    required this.name,
    this.status = true,
    this.id,
  });
}
