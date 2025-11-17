import 'package:url_launcher/url_launcher.dart';
import '../core/graphql_client.dart';
import '../core/result.dart';
import '../core/exceptions.dart';
import '../graphql/queries.dart';
import '../graphql/mutations.dart';
import '../models/checkout.dart';

/// Checkout service for cart and checkout management
class CheckoutService {
  final GraphQLClient _client;
  
  Checkout? _currentCheckout;
  
  CheckoutService(this._client);
  
  /// Get current checkout
  Checkout? get currentCheckout => _currentCheckout;
  
  /// Create a new checkout with line items
  Future<Result<Checkout>> createCheckout({
    required List<CheckoutLineItemInput> lineItems,
    String? email,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyMutations.checkoutCreate;
      final variables = {
        'input': {
          'lineItems': lineItems.map((item) => item.toJson()).toList(),
          if (email != null) 'email': email,
        }
      };
      
      final data = await _client.execute(query, variables: variables);
      final result = data['checkoutCreate'] as Map<String, dynamic>;
      final checkoutData = result['checkout'] as Map<String, dynamic>;
      
      _currentCheckout = Checkout.fromJson(checkoutData);
      return Success(_currentCheckout!);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to create checkout: ${e.toString()}');
    }
  }
  
  /// Add line items to existing checkout
  Future<Result<Checkout>> addLineItems({
    required String checkoutId,
    required List<CheckoutLineItemInput> lineItems,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyMutations.checkoutLineItemsAdd;
      final variables = {
        'checkoutId': checkoutId,
        'lineItems': lineItems.map((item) => item.toJson()).toList(),
      };
      
      final data = await _client.execute(query, variables: variables);
      final result = data['checkoutLineItemsAdd'] as Map<String, dynamic>;
      final checkoutData = result['checkout'] as Map<String, dynamic>;
      
      _currentCheckout = Checkout.fromJson(checkoutData);
      return Success(_currentCheckout!);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to add line items: ${e.toString()}');
    }
  }
  
  /// Update line items in checkout
  Future<Result<Checkout>> updateLineItems({
    required String checkoutId,
    required List<CheckoutLineItemUpdateInput> lineItems,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyMutations.checkoutLineItemsUpdate;
      final variables = {
        'checkoutId': checkoutId,
        'lineItems': lineItems.map((item) => item.toJson()).toList(),
      };
      
      final data = await _client.execute(query, variables: variables);
      final result = data['checkoutLineItemsUpdate'] as Map<String, dynamic>;
      final checkoutData = result['checkout'] as Map<String, dynamic>;
      
      _currentCheckout = Checkout.fromJson(checkoutData);
      return Success(_currentCheckout!);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to update line items: ${e.toString()}');
    }
  }
  
  /// Remove line items from checkout
  Future<Result<Checkout>> removeLineItems({
    required String checkoutId,
    required List<String> lineItemIds,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyMutations.checkoutLineItemsRemove;
      final variables = {
        'checkoutId': checkoutId,
        'lineItemIds': lineItemIds,
      };
      
      final data = await _client.execute(query, variables: variables);
      final result = data['checkoutLineItemsRemove'] as Map<String, dynamic>;
      final checkoutData = result['checkout'] as Map<String, dynamic>;
      
      _currentCheckout = Checkout.fromJson(checkoutData);
      return Success(_currentCheckout!);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to remove line items: ${e.toString()}');
    }
  }
  
  /// Update checkout email
  Future<Result<Checkout>> updateEmail({
    required String checkoutId,
    required String email,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyMutations.checkoutEmailUpdate;
      final variables = {
        'checkoutId': checkoutId,
        'email': email,
      };
      
      final data = await _client.execute(query, variables: variables);
      final result = data['checkoutEmailUpdateV2'] as Map<String, dynamic>;
      final checkoutData = result['checkout'] as Map<String, dynamic>;
      
      _currentCheckout = Checkout.fromJson(checkoutData);
      return Success(_currentCheckout!);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to update email: ${e.toString()}');
    }
  }
  
  /// Get checkout by ID
  Future<Result<Checkout>> getCheckout({
    required String checkoutId,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyQueries.getCheckout;
      final variables = {'checkoutId': checkoutId};
      
      final data = await _client.execute(query, variables: variables);
      final checkoutData = data['node'] as Map<String, dynamic>?;
      
      if (checkoutData == null) {
        return Failure('Checkout not found with ID: $checkoutId');
      }
      
      _currentCheckout = Checkout.fromJson(checkoutData);
      return Success(_currentCheckout!);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to get checkout: ${e.toString()}');
    }
  }
  
  /// Open checkout URL in browser for payment
  Future<Result<bool>> openCheckoutUrl(String webUrl) async {
    try {
      final uri = Uri.parse(webUrl);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        return const Failure('Could not launch checkout URL');
      }
      
      return const Success(true);
    } catch (e) {
      return Failure('Failed to open checkout URL: ${e.toString()}');
    }
  }
  
  /// Clear current checkout
  void clearCheckout() {
    _currentCheckout = null;
  }
}