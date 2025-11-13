class Collection {
  final String id;
  final String title;
  final String handle;
  final String? description;
  final String? imageUrl;
  final int productsCount;

  Collection({
    required this.id,
    required this.title,
    required this.handle,
    this.description,
    this.imageUrl,
    required this.productsCount,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    // Safely parse imageUrl
    String? parseImageUrl(dynamic image) {
      if (image == null) return null;
      if (image is String) return image;
      if (image is Map) return image['url']?.toString();
      return null;
    }

    return Collection(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      handle: json['handle']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: parseImageUrl(json['image']),
      productsCount: json['productsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'handle': handle,
      'description': description,
      'image': imageUrl != null ? {'url': imageUrl} : null,
      'productsCount': productsCount,
    };
  }
}

