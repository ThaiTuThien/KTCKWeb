class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: (json['title'] ?? '').toString(),
      price: (json['price'] ?? 0.0).toDouble(),
      description: (json['description'] ?? '').toString(),
      category: json['category'] != null ? (json['category']['name'] ?? 'No Category').toString() : 'No Category',
      image: json['images'] != null && json['images'].isNotEmpty
          ? (json['images'][0] ?? 'No Image').toString()
          : 'No Image',
    );
  }
}