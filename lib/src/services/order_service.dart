import '../core/graphql_client.dart';
import '../core/storage_service.dart';
import '../core/result.dart';
import '../core/exceptions.dart';
import '../graphql/queries.dart';
import '../models/order.dart';
import '../models/common.dart';

/// Order history service
class OrderService {
  final GraphQLClient _client;
  final StorageService _storage;
  
  OrderService(this._client, this._storage);
  
  /// Get customer orders with pagination
  Future<Result<OrderList>> getOrders({
    int first = 20,
    String? after,
    String? customQuery,
  }) async {
    try {
      final token = await _storage.getCustomerToken();
      if (token == null) {
        return const Failure('Not authenticated');
      }
      
      final query = customQuery ?? ShopifyQueries.getCustomerOrders;
      final variables = {
        'customerAccessToken': token,
        'first': first,
        if (after != null) 'after': after,
      };
      
      final data = await _client.execute(query, variables: variables);
      final customer = data['customer'] as Map<String, dynamic>?;
      
      if (customer == null) {
        return const Failure('Customer not found');
      }
      
      final ordersData = customer['orders'] as Map<String, dynamic>;
      final pageInfo = PageInfo.fromJson(ordersData['pageInfo'] as Map<String, dynamic>);
      final orders = EdgeParser.parseEdges<Order>(
        ordersData['edges'] as List<dynamic>?,
        Order.fromJson,
      );
      
      return Success(OrderList(orders: orders, pageInfo: pageInfo));
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to get orders: ${e.toString()}');
    }
  }
}

/// Order list with pagination info
class OrderList {
  final List<Order> orders;
  final PageInfo pageInfo;
  
  const OrderList({
    required this.orders,
    required this.pageInfo,
  });
}