class MenuModel {
  final String categoryId;
  final String name;
  final String price;
  final String description;
  final String? id;
  final bool status;
  int quantity;
  MenuModel({
    required this.categoryId,
    required this.name,
    required this.price,
    required this.description,
    this.id,
    this.status = true,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'name': name,
        'price': price,
        'description': description,
        'status': status,
        'quantity': quantity,
      };

  static MenuModel fromJson(Map<String, dynamic> json) => MenuModel(
        categoryId: json['category_id'],
        name: json['name'],
        price: json['price'],
        description: json['description'],
        status: json['status'],
        quantity: json['quantity'],
      );
}
