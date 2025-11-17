/// Configuration for Shopify SDK
class ShopifyConfig {
  /// Your Shopify store domain (e.g., 'your-store.myshopify.com')
  final String shopDomain;
  
  /// Storefront API access token
  final String storefrontAccessToken;
  
  /// Enable debug logging (default: false)
  final bool enableLogging;
  
  /// API version (default: '2024-10')
  final String apiVersion;
  
  const ShopifyConfig({
    required this.shopDomain,
    required this.storefrontAccessToken,
    this.enableLogging = false,
    this.apiVersion = '2024-10',
  });
  
  /// Validate configuration
  bool get isValid {
    return shopDomain.isNotEmpty && 
           storefrontAccessToken.isNotEmpty &&
           shopDomain.contains('.');
  }
  
  @override
  String toString() {
    return 'ShopifyConfig(shopDomain: $shopDomain, apiVersion: $apiVersion)';
  }
}