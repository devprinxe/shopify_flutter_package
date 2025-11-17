/// Base exception for all Shopify-related errors
abstract class ShopifyException implements Exception {
  final String message;
  final dynamic originalError;
  
  const ShopifyException(this.message, [this.originalError]);
  
  @override
  String toString() => 'ShopifyException: $message';
}

class NetworkException extends ShopifyException {
  const NetworkException(super.message, [super.originalError]);
  
  @override
  String toString() => 'NetworkException: $message';
}

class AuthException extends ShopifyException {
  const AuthException(super.message, [super.originalError]);
  
  @override
  String toString() => 'AuthException: $message';
}

class GraphQLException extends ShopifyException {
  final List<GraphQLError> errors;
  
  const GraphQLException(super.message, this.errors, [super.originalError]);
  
  @override
  String toString() => 'GraphQLException: $message - Errors: ${errors.map((e) => e.message).join(", ")}';
}

class GraphQLError {
  final String message;
  final String? field;
  final String? code;
  
  const GraphQLError({
    required this.message,
    this.field,
    this.code,
  });
  
  factory GraphQLError.fromJson(Map<String, dynamic> json) {
    return GraphQLError(
      message: json['message'] as String? ?? 'Unknown error',
      field: json['field'] as String?,
      code: json['code'] as String?,
    );
  }
}

class StorageException extends ShopifyException {
  const StorageException(super.message, [super.originalError]);
  
  @override
  String toString() => 'StorageException: $message';
}

class CheckoutException extends ShopifyException {
  const CheckoutException(super.message, [super.originalError]);
  
  @override
  String toString() => 'CheckoutException: $message';
}