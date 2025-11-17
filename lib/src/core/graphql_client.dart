import 'package:dio/dio.dart';
import 'exceptions.dart';

/// DIO-based GraphQL client for Shopify Storefront API
class GraphQLClient {
  final Dio _dio;
  final String shopDomain;
  final String storefrontAccessToken;
  
  GraphQLClient({
    required this.shopDomain,
    required this.storefrontAccessToken,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _configureDio();
  }
  
  void _configureDio() {
    _dio.options.baseUrl = 'https://$shopDomain/api/2024-10/graphql.json';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'X-Shopify-Storefront-Access-Token': storefrontAccessToken,
    };
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Add interceptors for logging (optional, can be configured)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('[GraphQL] $obj'),
    ));
  }
  
  /// Execute a GraphQL query or mutation
  Future<Map<String, dynamic>> execute(
    String query, {
    Map<String, dynamic>? variables,
  }) async {
    try {
      final response = await _dio.post(
        '',
        data: {
          'query': query,
          if (variables != null && variables.isNotEmpty) 'variables': variables,
        },
      );
      
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException('Unexpected error: ${e.toString()}', e);
    }
  }
  
  Map<String, dynamic> _handleResponse(Response response) {
    final data = response.data as Map<String, dynamic>;
    
    // Check for GraphQL errors
    if (data.containsKey('errors')) {
      final errorsList = data['errors'] as List;
      final errors = errorsList
          .map((e) => GraphQLError.fromJson(e as Map<String, dynamic>))
          .toList();
      throw GraphQLException(
        'GraphQL query failed',
        errors,
      );
    }
    
    // Check for user errors (common in mutations)
    if (data.containsKey('data')) {
      final responseData = data['data'] as Map<String, dynamic>?;
      if (responseData != null) {
        for (final value in responseData.values) {
          if (value is Map<String, dynamic>) {
            if (value.containsKey('userErrors') || value.containsKey('customerUserErrors')) {
              final errorKey = value.containsKey('userErrors') ? 'userErrors' : 'customerUserErrors';
              final userErrors = value[errorKey] as List?;
              if (userErrors != null && userErrors.isNotEmpty) {
                final errors = userErrors
                    .map((e) => GraphQLError.fromJson(e as Map<String, dynamic>))
                    .toList();
                throw GraphQLException(
                  'Operation failed with user errors',
                  errors,
                );
              }
            }
          }
        }
      }
    }
    
    return data['data'] as Map<String, dynamic>? ?? {};
  }
  
  ShopifyException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Request timeout. Please check your connection.');
      case DioExceptionType.badResponse:
        return NetworkException(
          'Server error: ${error.response?.statusCode}',
          error,
        );
      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');
      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');
      default:
        return NetworkException('Network error: ${error.message}', error);
    }
  }
  
  /// Add custom headers (e.g., customer access token)
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }
  
  /// Remove header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }
}