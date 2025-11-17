import 'package:freezed_annotation/freezed_annotation.dart';
import 'common.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    bool? acceptsMarketing,
    String? createdAt,
    String? updatedAt,
    Address? defaultAddress,
  }) = _Customer;
  
  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}

@freezed
class CustomerAccessToken with _$CustomerAccessToken {
  const factory CustomerAccessToken({
    required String accessToken,
    required String expiresAt,
  }) = _CustomerAccessToken;
  
  factory CustomerAccessToken.fromJson(Map<String, dynamic> json) => 
      _$CustomerAccessTokenFromJson(json);
}