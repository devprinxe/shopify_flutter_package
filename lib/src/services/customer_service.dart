import '../core/graphql_client.dart';
import '../core/storage_service.dart';
import '../core/result.dart';
import '../core/exceptions.dart';
import '../graphql/queries.dart';
import '../graphql/mutations.dart';
import '../models/customer.dart';

/// Customer profile management service
class CustomerService {
  final GraphQLClient _client;
  final StorageService _storage;
  
  CustomerService(this._client, this._storage);
  
  /// Get current customer profile
  Future<Result<Customer>> getCustomer({String? customQuery}) async {
    try {
      final token = await _storage.getCustomerToken();
      if (token == null) {
        return const Failure('Not authenticated');
      }
      
      final query = customQuery ?? ShopifyQueries.getCustomer;
      final variables = {'customerAccessToken': token};
      
      final data = await _client.execute(query, variables: variables);
      final customerData = data['customer'] as Map<String, dynamic>?;
      
      if (customerData == null) {
        return const Failure('Customer not found');
      }
      
      final customer = Customer.fromJson(customerData);
      return Success(customer);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to get customer: ${e.toString()}');
    }
  }
  
  /// Update customer profile
  Future<Result<Customer>> updateCustomer({
    String? firstName,
    String? lastName,
    String? phone,
    bool? acceptsMarketing,
    String? customQuery,
  }) async {
    try {
      final token = await _storage.getCustomerToken();
      if (token == null) {
        return const Failure('Not authenticated');
      }
      
      final query = customQuery ?? ShopifyMutations.customerUpdate;
      final variables = {
        'customerAccessToken': token,
        'customer': {
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (phone != null) 'phone': phone,
          if (acceptsMarketing != null) 'acceptsMarketing': acceptsMarketing,
        }
      };
      
      final data = await _client.execute(query, variables: variables);
      final result = data['customerUpdate'] as Map<String, dynamic>;
      final customerData = result['customer'] as Map<String, dynamic>;
      
      final customer = Customer.fromJson(customerData);
      return Success(customer);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to update customer: ${e.toString()}');
    }
  }
}