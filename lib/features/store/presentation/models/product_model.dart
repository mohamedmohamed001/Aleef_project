class ProductModel {
  final String id;
  final String title;
  final String description;
  final double originalPrice;
  final double finalPrice;
  final int discount;
  final List<ProductCategoryModel> categories;
  final int stock;
  final int buys;
  final ProductImageModel thumbnail;
  final List<ProductImageModel> productImages;
  final double averageRate;
  final int ratingsQuantity;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.finalPrice,
    required this.discount,
    required this.categories,
    required this.stock,
    required this.buys,
    required this.thumbnail,
    required this.productImages,
    required this.averageRate,
    required this.ratingsQuantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      finalPrice: (json['finalPrice'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      categories: (json['category'] as List<dynamic>? ?? [])
          .map((e) => ProductCategoryModel.fromJson(e))
          .toList(),
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      buys: int.tryParse(json['buys']?.toString() ?? '0') ?? 0,
      thumbnail: ProductImageModel.fromJson(json['thumbnail'] ?? {}),
      productImages: (json['productImages'] as List<dynamic>? ?? [])
          .map((e) => ProductImageModel.fromJson(e))
          .toList(),
      averageRate: double.tryParse(json['averageRate']?.toString() ?? '0') ?? 0,
      ratingsQuantity:
      int.tryParse(json['ratingsQuantity']?.toString() ?? '0') ?? 0,
    );
  }
}

class ProductCategoryModel {
  final String id;
  final String name;

  const ProductCategoryModel({required this.id, required this.name});

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ProductImageModel {
  final String url;
  final String cloudinaryId;
  final String? id;

  const ProductImageModel({
    required this.url,
    required this.cloudinaryId,
    this.id,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      url: json['url'] ?? '',
      cloudinaryId: json['cloudinary_id'] ?? '',
      id: json['id'],
    );
  }
}