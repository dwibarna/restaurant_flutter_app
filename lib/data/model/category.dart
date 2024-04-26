class Category {
  final String name;

  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> category) {
    return Category(name: category['name']);
  }
}