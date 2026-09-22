class ProductModel {
  final String id;
  final String name;
  final int year;
  final dynamic price;

  ProductModel({
    required this.id,
    required this.name,
    required this.year,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      year: json["data"]?["year"] ?? 0,
      price: json["data"]?["price"] ?? 0,
    );
  }
}