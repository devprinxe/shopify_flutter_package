import '../core/graphql_client.dart';
import '../core/storage_service.dart';
import '../core/result.dart';
import '../core/exceptions.dart';
import '../graphql/queries.dart';
import '../graphql/mutations.dart';
import '../models/customer.dart';

/// Authentication service with sign up, sign in, sign out, and password reset
class AuthService {
  final GraphQLClient _client;
  final StorageService _storage;
  
  Customer? _currentCustomer;
  String? _customerAccessToken;
  
  AuthService(this._client, this._storage);
  
  /// Check if user is currently signed in
  bool get isSignedIn => _customerAccessToken != null;
  
  /// Get current customer (if signed in)
  Customer? get currentCustomer => _currentCustomer;
  
  /// Get current access token
  String? get accessToken => _customerAccessToken;
  
  /// Restore session from secure storage (call on app start)
  Future<void> restoreSession() async {
    try {
      _customerAccessToken = await _storage.getCustomerToken();
      if (_customerAccessToken != null) {
        final result = await getCurrentCustomer();
        if (result is Failure) {
          // Token is invalid, clear it
          await _clearSession();
        }
      }
    } catch (e) {
      await _clearSession();
    }
  }
  
  /// Sign up a new customer
  Future<Result<Customer>> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    bool acceptsMarketing = false,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyMutations.customerCreate;
      final variables = {
        'input': {
          'email': email,
          'password': password,
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          'acceptsMarketing': acceptsMarketing,
        }
      };
      
      final data = await _client.execute(query, variables: variables);
      final result = data['customerCreate'] as Map<String, dynamic>;
      final customer = Customer.fromJson(result['customer'] as Map<String, dynamic>);
      
      return Success(customer);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to sign up: ${e.toString()}');
    }
  }
  
  /// Sign in with email and password
  Future<Result<Customer>> signIn({
    required String email,
    required String password,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyMutations.customerAccessTokenCreate;
      final variables = {
        'input': {
          'email': email,
          'password': password,
        }
      };
      
      final data = await _client.execute(query, variables: variables);
      final result = data['customerAccessTokenCreate'] as Map<String, dynamic>;
      final tokenData = result['customerAccessToken'] as Map<String, dynamic>;
      
      _customerAccessToken = tokenData['accessToken'] as String;
      await _storage.saveCustomerToken(_customerAccessToken!);
      
      // Fetch customer data
      final customerResult = await getCurrentCustomer();
      return customerResult;
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to sign in: ${e.toString()}');
    }
  }
  
  /// Sign out current customer
  Future<Result<bool>> signOut({String? customQuery}) async {
    try {
      if (_customerAccessToken != null) {
        final query = customQuery ?? ShopifyMutations.customerAccessTokenDelete;
        final variables = {'customerAccessToken': _customerAccessToken};
        
        await _client.execute(query, variables: variables);
      }
      
      await _clearSession();
      return const Success(true);
    } on ShopifyException catch (e) {
      // Still clear local session even if API call fails
      await _clearSession();
      return Failure(e.message, e);
    } catch (e) {
      await _clearSession();
      return Failure('Failed to sign out: ${e.toString()}');
    }
  }
  
  /// Request password reset email
  Future<Result<bool>> resetPassword({
    required String email,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyMutations.customerRecover;
      final variables = {'email': email};
      
      await _client.execute(query, variables: variables);
      return const Success(true);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to request password reset: ${e.toString()}');
    }
  }
  
  /// Get current customer details
  Future<Result<Customer>> getCurrentCustomer({String? customQuery}) async {
    try {
      if (_customerAccessToken == null) {
        return const Failure('Not signed in');
      }
      
      final query = customQuery ?? ShopifyQueries.getCustomer;
      final variables = {'customerAccessToken': _customerAccessToken};
      
      final data = await _client.execute(query, variables: variables);
      final customerData = data['customer'] as Map<String, dynamic>?;
      
      if (customerData == null) {
        await _clearSession();
        return const Failure('Invalid or expired session');
      }
      
      _currentCustomer = Customer.fromJson(customerData);
      await _storage.saveCustomerId(_currentCustomer!.id);
      
      return Success(_currentCustomer!);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to get customer: ${e.toString()}');
    }
  }
  
  Future<void> _clearSession() async {
    _customerAccessToken = null;
    _currentCustomer = null;
    await _storage.deleteCustomerToken();
    await _storage.deleteCustomerId();
  }
}