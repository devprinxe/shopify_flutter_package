import 'core/graphql_client.dart';
import 'core/storage_service.dart';
import 'services/auth_service.dart';
import 'services/product_service.dart';
import 'services/collection_service.dart';
import 'services/checkout_service.dart';
import 'services/customer_service.dart';
import 'services/order_service.dart';
import 'shopify_config.dart';

/// Main SDK class that provides access to all Shopify services
/// Use as a singleton like Firebase: Shopify.instance
class Shopify {
  static Shopify? _instance;
  
  final ShopifyConfig config;
  late final GraphQLClient _client;
  late final StorageService _storage;
  
  late final AuthService auth;
  late final ProductService products;
  late final CollectionService collections;
  late final CheckoutService checkout;
  late final CustomerService customer;
  late final OrderService orders;
  
  Shopify._(this.config) {
    if (!config.isValid) {
      throw ArgumentError('Invalid ShopifyConfig: Please provide valid shopDomain and storefrontAccessToken');
    }
    
    _client = GraphQLClient(
      shopDomain: config.shopDomain,
      storefrontAccessToken: config.storefrontAccessToken,
    );
    
    _storage = StorageService();
    
    // Initialize all services
    auth = AuthService(_client, _storage);
    products = ProductService(_client);
    collections = CollectionService(_client);
    checkout = CheckoutService(_client);
    customer = CustomerService(_client, _storage);
    orders = OrderService(_client, _storage);
  }
  
  /// Initialize Shopify SDK with configuration
  /// Call this in main() before runApp()
  static Future<void> initialize(ShopifyConfig config) async {
    if (_instance != null) {
      throw StateError('Shopify SDK is already initialized. Call Shopify.initialize() only once.');
    }
    
    _instance = Shopify._(config);
    await _instance!._initialize();
  }
  
  /// Get the singleton instance
  /// Throws if not initialized
  static Shopify get instance {
    if (_instance == null) {
      throw StateError(
        'Shopify SDK is not initialized. '
        'Call Shopify.initialize(config) in main() before using Shopify.instance',
      );
    }
    return _instance!;
  }
  
  /// Check if SDK is initialized
  static bool get isInitialized => _instance != null;
  
  /// Reset the instance (useful for testing)
  static void reset() {
    _instance = null;
  }
  
  /// Internal initialization (restore session if available)
  Future<void> _initialize() async {
    await auth.restoreSession();
  }
  
  /// Clear all cached data and sign out
  Future<void> clearAll() async {
    await auth.signOut();
    await _storage.clearAll();
  }
}