class ProductModel {
  final String id;
  final String name;
  final String year;
  final String price;

  ProductModel({
    required this.id,
    required this.name,
    required this.year,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      year: json["data"]?["year"]?.toString() ?? "",
      price: json["data"]?["price"]?.toString() ?? "",
    );
  }
}