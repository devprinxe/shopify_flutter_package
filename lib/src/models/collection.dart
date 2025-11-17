import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';
import 'product.dart';

part 'collection.freezed.dart';

@freezed
class Collection with _$Collection {
  const factory Collection({required String id, required String title, String? description, String? descriptionHtml, required String handle, String? updatedAt, ShopifyImage? image, @Default([]) List<Product> products, PageInfo? productsPageInfo}) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(id: json['id'] as String, title: json['title'] as String, description: json['description'] as String?, descriptionHtml: json['descriptionHtml'] as String?, handle: json['handle'] as String, updatedAt: json['updatedAt'] as String?, image: json['image'] != null ? ShopifyImage.fromJson(json['image'] as Map<String, dynamic>) : null, products: EdgeParser.parseEdges(json['products']?['edges'] as List<dynamic>?, Product.fromJson), productsPageInfo: json['products']?['pageInfo'] != null ? PageInfo.fromJson(json['products']['pageInfo'] as Map<String, dynamic>) : null);
  }
}
