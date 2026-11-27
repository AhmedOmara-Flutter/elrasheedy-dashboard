class CategoryEntity {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> sizes;
  final DateTime createdAt;
  final int sortOrder;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.sizes,
    required this.createdAt,
    required this.sortOrder,
  });
}