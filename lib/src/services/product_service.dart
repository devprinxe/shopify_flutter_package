import '../core/graphql_client.dart';
import '../core/result.dart';
import '../core/exceptions.dart';
import '../graphql/queries.dart';
import '../models/product.dart';
import '../models/common.dart';

/// Product service for browsing and searching products
class ProductService {
  final GraphQLClient _client;
  
  ProductService(this._client);
  
  /// Get list of products with pagination
  Future<Result<ProductList>> getProducts({
    int first = 20,
    String? after,
    String? query,
    String? customQuery,
  }) async {
    try {
      final gqlQuery = customQuery ?? ShopifyQueries.getProducts;
      final variables = {
        'first': first,
        if (after != null) 'after': after,
        if (query != null) 'query': query,
      };
      
      final data = await _client.execute(gqlQuery, variables: variables);
      final productsData = data['products'] as Map<String, dynamic>;
      
      final pageInfo = PageInfo.fromJson(productsData['pageInfo'] as Map<String, dynamic>);
      final products = EdgeParser.parseEdges<Product>(
        productsData['edges'] as List<dynamic>?,
        Product.fromJson,
      );
      
      return Success(ProductList(products: products, pageInfo: pageInfo));
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to get products: ${e.toString()}');
    }
  }
  
  /// Get product by handle
  Future<Result<Product>> getProductByHandle({
    required String handle,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyQueries.getProductByHandle;
      final variables = {'handle': handle};
      
      final data = await _client.execute(query, variables: variables);
      final productData = data['productByHandle'] as Map<String, dynamic>?;
      
      if (productData == null) {
        return Failure('Product not found with handle: $handle');
      }
      
      final product = Product.fromJson(productData);
      return Success(product);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to get product: ${e.toString()}');
    }
  }
  
  /// Search products
  Future<Result<ProductList>> searchProducts({
    required String searchQuery,
    int first = 20,
    String? after,
    String? customQuery,
  }) async {
    return getProducts(
      first: first,
      after: after,
      query: searchQuery,
      customQuery: customQuery,
    );
  }
}

/// Product list with pagination info
class ProductList {
  final List<Product> products;
  final PageInfo pageInfo;
  
  const ProductList({
    required this.products,
    required this.pageInfo,
  });
}