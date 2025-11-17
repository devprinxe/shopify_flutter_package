import 'dart:convert';
import 'package:http/http.dart' as http;

/// Lightweight GraphQL client for Shopify Storefront API
class ShopifyClient {
  final String shopDomain;
  final String storefrontAccessToken;
  final http.Client httpClient;

  ShopifyClient({
    required this.shopDomain,
    required this.storefrontAccessToken,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Uri get _endpoint => Uri.https(shopDomain, '/api/2024-07/graphql.json');

  Future<Map<String, dynamic>> query(String query, {Map<String, dynamic>? variables}) async {
    final body = jsonEncode({
      'query': query,
      if (variables != null) 'variables': variables,
    });

    final resp = await httpClient.post(
      _endpoint,
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': storefrontAccessToken,
      },
      body: body,
    );

    if (resp.statusCode != 200) {
      throw Exception('GraphQL request failed: ${resp.statusCode} ${resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (data.containsKey('errors')) {
      throw Exception('GraphQL errors: ${data['errors']}');
    }
    return data['data'] as Map<String, dynamic>;
  }
}