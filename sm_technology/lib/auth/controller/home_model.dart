class Product {
  final String id;
  final String name;
  final Map<String, dynamic>? data;

  Product({
    required this.id,
    required this.name,
    this.data,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? 'No name',
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
    );
  }
}
