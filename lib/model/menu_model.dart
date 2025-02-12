class MenuModel {
  final String categoryId;
  final String name;
  final int price;
  final String description;
  final String? id;
  final bool status;
  final String? image_url;
  int quantity;
  MenuModel({
    required this.categoryId,
    required this.name,
    required this.price,
    required this.description,
    this.id,
    this.status = true,
    this.quantity = 0,
    this.image_url,
  });

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'name': name,
        'price': price,
        'description': description,
        'status': status,
        'quantity': quantity,
        'image_url': image_url,
      };

  static MenuModel fromJson(Map<String, dynamic> json) => MenuModel(
        categoryId: json['category_id'],
        name: json['name'],
        price: int.parse(json['price'].toString()),
        description: json['description'],
        status: json['status'],
        quantity: int.parse(json['quantity'].toString()),
        image_url: json['image_url'],
      );
}
