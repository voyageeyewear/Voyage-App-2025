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
    return Collection(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      handle: json['handle'] ?? '',
      description: json['description'],
      imageUrl: json['image']?['url'] ?? json['image'],
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

