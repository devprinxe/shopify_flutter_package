import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';
import 'product.dart';

part 'order.freezed.dart';

@freezed
class Order with _$Order {
  const factory Order({required String id, required int orderNumber, String? processedAt, String? financialStatus, String? fulfillmentStatus, required Money totalPrice, Money? subtotalPrice, Money? totalShippingPrice, Money? totalTax, @Default([]) List<OrderLineItem> lineItems}) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(id: json['id'] as String, orderNumber: json['orderNumber'] as int, processedAt: json['processedAt'] as String?, financialStatus: json['financialStatus'] as String?, fulfillmentStatus: json['fulfillmentStatus'] as String?, totalPrice: Money.fromJson(json['totalPrice'] as Map<String, dynamic>), subtotalPrice: json['subtotalPrice'] != null ? Money.fromJson(json['subtotalPrice'] as Map<String, dynamic>) : null, totalShippingPrice: json['totalShippingPrice'] != null ? Money.fromJson(json['totalShippingPrice'] as Map<String, dynamic>) : null, totalTax: json['totalTax'] != null ? Money.fromJson(json['totalTax'] as Map<String, dynamic>) : null, lineItems: EdgeParser.parseEdges(json['lineItems']?['edges'] as List<dynamic>?, OrderLineItem.fromJson));
  }
}

@freezed
class OrderLineItem with _$OrderLineItem {
  const factory OrderLineItem({required String title, required int quantity, ProductVariant? variant}) = _OrderLineItem;

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    return OrderLineItem(title: json['title'] as String, quantity: json['quantity'] as int, variant: json['variant'] != null ? ProductVariant.fromJson(json['variant'] as Map<String, dynamic>) : null);
  }
}
