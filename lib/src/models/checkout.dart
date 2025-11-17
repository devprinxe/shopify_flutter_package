import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';
import 'product.dart';

part 'checkout.freezed.dart';

@freezed
class Checkout with _$Checkout {
  const factory Checkout({required String id, required String webUrl, @Default(false) bool ready, String? email, String? completedAt, String? createdAt, String? updatedAt, required Money subtotalPrice, required Money totalPrice, Money? totalTax, @Default([]) List<CheckoutLineItem> lineItems}) = _Checkout;

  factory Checkout.fromJson(Map<String, dynamic> json) {
    return Checkout(id: json['id'] as String, webUrl: json['webUrl'] as String, ready: json['ready'] as bool? ?? false, email: json['email'] as String?, completedAt: json['completedAt'] as String?, createdAt: json['createdAt'] as String?, updatedAt: json['updatedAt'] as String?, subtotalPrice: Money.fromJson(json['subtotalPrice'] as Map<String, dynamic>), totalPrice: Money.fromJson(json['totalPrice'] as Map<String, dynamic>), totalTax: json['totalTax'] != null ? Money.fromJson(json['totalTax'] as Map<String, dynamic>) : null, lineItems: EdgeParser.parseEdges(json['lineItems']?['edges'] as List<dynamic>?, CheckoutLineItem.fromJson));
  }
}

@freezed
class CheckoutLineItem with _$CheckoutLineItem {
  const factory CheckoutLineItem({required String id, required String title, required int quantity, ProductVariant? variant}) = _CheckoutLineItem;

  factory CheckoutLineItem.fromJson(Map<String, dynamic> json) {
    return CheckoutLineItem(id: json['id'] as String, title: json['title'] as String, quantity: json['quantity'] as int, variant: json['variant'] != null ? ProductVariant.fromJson(json['variant'] as Map<String, dynamic>) : null);
  }
}

/// Input class for creating/updating checkout line items
class CheckoutLineItemInput {
  final String variantId;
  final int quantity;

  const CheckoutLineItemInput({required this.variantId, required this.quantity});

  Map<String, dynamic> toJson() => {'variantId': variantId, 'quantity': quantity};
}

/// Input class for updating checkout line items
class CheckoutLineItemUpdateInput {
  final String id;
  final int quantity;

  const CheckoutLineItemUpdateInput({required this.id, required this.quantity});

  Map<String, dynamic> toJson() => {'id': id, 'quantity': quantity};
}
