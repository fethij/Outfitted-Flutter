import 'package:flutter/cupertino.dart';

class CollectionCategory {
  String id;
  String categoryName;
  String categoryImage;

  CollectionCategory({
    this.id,
    @required this.categoryName,
    @required this.categoryImage,
  });

  CollectionCategory.getCategoryFromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['name'];
    categoryImage = json['categoryImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['categoryImage'] = this.categoryImage;

    return data;
  }
}
