import 'package:freezed_annotation/freezed_annotation.dart';

part 'common.freezed.dart';
part 'common.g.dart';

@freezed
class Money with _$Money {
  const factory Money({
    required String amount,
    required String currencyCode,
  }) = _Money;
  
  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);
}

@freezed
class ShopifyImage with _$ShopifyImage {
  const factory ShopifyImage({
    String? id,
    required String url,
    String? altText,
    int? width,
    int? height,
  }) = _ShopifyImage;
  
  factory ShopifyImage.fromJson(Map<String, dynamic> json) => _$ShopifyImageFromJson(json);
}

@freezed
class PageInfo with _$PageInfo {
  const factory PageInfo({
    required bool hasNextPage,
    required bool hasPreviousPage,
  }) = _PageInfo;
  
  factory PageInfo.fromJson(Map<String, dynamic> json) => _$PageInfoFromJson(json);
}

@freezed
class Address with _$Address {
  const factory Address({
    String? id,
    String? address1,
    String? address2,
    String? city,
    String? province,
    String? country,
    String? zip,
    String? phone,
    String? firstName,
    String? lastName,
    String? company,
  }) = _Address;
  
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

/// Helper class to parse edges from GraphQL responses
class EdgeParser {
  static List<T> parseEdges<T>(
    List<dynamic>? edges,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (edges == null || edges.isEmpty) return [];
    return edges
        .map((edge) => fromJson(edge['node'] as Map<String, dynamic>))
        .toList();
  }
  
  static T? parseEdge<T>(
    Map<String, dynamic>? edge,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (edge == null || !edge.containsKey('node')) return null;
    return fromJson(edge['node'] as Map<String, dynamic>);
  }
}