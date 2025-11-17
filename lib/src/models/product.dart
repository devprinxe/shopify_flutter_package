import 'package:freezed_annotation/freezed_annotation.dart';
import 'common.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String title,
    String? description,
    String? descriptionHtml,
    required String handle,
    String? productType,
    String? vendor,
    @Default([]) List<String> tags,
    String? createdAt,
    String? updatedAt,
    @Default(true) bool availableForSale,
    PriceRange? priceRange,
    @Default([]) List<ShopifyImage> images,
    @Default([]) List<ProductVariant> variants,
  }) = _Product;
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      descriptionHtml: json['descriptionHtml'] as String?,
      handle: json['handle'] as String,
      productType: json['productType'] as String?,
      vendor: json['vendor'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      availableForSale: json['availableForSale'] as bool? ?? true,
      priceRange: json['priceRange'] != null 
          ? PriceRange.fromJson(json['priceRange'] as Map<String, dynamic>)
          : null,
      images: EdgeParser.parseEdges(
        json['images']?['edges'] as List<dynamic>?,
        ShopifyImage.fromJson,
      ),
      variants: EdgeParser.parseEdges(
        json['variants']?['edges'] as List<dynamic>?,
        ProductVariant.fromJson,
      ),
    );
  }
}

@freezed
class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    required String title,
    required Money price,
    Money? compareAtPrice,
    @Default(true) bool availableForSale,
    int? quantityAvailable,
    String? sku,
    @Default([]) List<SelectedOption> selectedOptions,
    ShopifyImage? image,
  }) = _ProductVariant;
  
  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      title: json['title'] as String,
      price: Money.fromJson(json['price'] as Map<String, dynamic>),
      compareAtPrice: json['compareAtPrice'] != null
          ? Money.fromJson(json['compareAtPrice'] as Map<String, dynamic>)
          : null,
      availableForSale: json['availableForSale'] as bool? ?? true,
      quantityAvailable: json['quantityAvailable'] as int?,
      sku: json['sku'] as String?,
      selectedOptions: (json['selectedOptions'] as List<dynamic>?)
              ?.map((e) => SelectedOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      image: json['image'] != null
          ? ShopifyImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
    );
  }
}

@freezed
class PriceRange with _$PriceRange {
  const factory PriceRange({
    required Money minVariantPrice,
    required Money maxVariantPrice,
  }) = _PriceRange;
  
  factory PriceRange.fromJson(Map<String, dynamic> json) => _$PriceRangeFromJson(json);
}

@freezed
class SelectedOption with _$SelectedOption {
  const factory SelectedOption({
    required String name,
    required String value,
  }) = _SelectedOption;
  
  factory SelectedOption.fromJson(Map<String, dynamic> json) => 
      _$SelectedOptionFromJson(json);
}