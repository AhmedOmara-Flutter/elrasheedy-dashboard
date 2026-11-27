import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elrasheedy_dashboard/feature/category/domain/entities/category_entity.dart';

class StaticCategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> sizes;

  const StaticCategoryModel({
    required this.id,
    required this.name,
    this.imageUrl = '',
    required this.sizes,
  });

  factory StaticCategoryModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return StaticCategoryModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      sizes: List<String>.from(map['sizes'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'sizes': sizes,
    };
  }
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.sizes,
    required super.createdAt,
    required super.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      sizes: List<String>.from(json['sizes'] ?? []),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      sizes: entity.sizes,
      createdAt: entity.createdAt,
      sortOrder: entity.sortOrder,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      sizes: sizes,
      createdAt: createdAt,
      sortOrder: sortOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'sizes': sizes,
      'createdAt': Timestamp.fromDate(createdAt),
      'sortOrder': sortOrder,
    };
  }
}