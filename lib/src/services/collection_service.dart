import '../core/graphql_client.dart';
import '../core/result.dart';
import '../core/exceptions.dart';
import '../graphql/queries.dart';
import '../models/collection.dart';
import '../models/common.dart';

/// Collection service for browsing product collections
class CollectionService {
  final GraphQLClient _client;
  
  CollectionService(this._client);
  
  /// Get list of collections with pagination
  Future<Result<CollectionList>> getCollections({
    int first = 20,
    String? after,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyQueries.getCollections;
      final variables = {
        'first': first,
        if (after != null) 'after': after,
      };
      
      final data = await _client.execute(query, variables: variables);
      final collectionsData = data['collections'] as Map<String, dynamic>;
      
      final pageInfo = PageInfo.fromJson(collectionsData['pageInfo'] as Map<String, dynamic>);
      final collections = EdgeParser.parseEdges<Collection>(
        collectionsData['edges'] as List<dynamic>?,
        Collection.fromJson,
      );
      
      return Success(CollectionList(collections: collections, pageInfo: pageInfo));
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to get collections: ${e.toString()}');
    }
  }
  
  /// Get collection by handle with products
  Future<Result<Collection>> getCollectionByHandle({
    required String handle,
    int productsFirst = 20,
    String? productsAfter,
    String? customQuery,
  }) async {
    try {
      final query = customQuery ?? ShopifyQueries.getCollectionByHandle;
      final variables = {
        'handle': handle,
        'first': productsFirst,
        if (productsAfter != null) 'after': productsAfter,
      };
      
      final data = await _client.execute(query, variables: variables);
      final collectionData = data['collectionByHandle'] as Map<String, dynamic>?;
      
      if (collectionData == null) {
        return Failure('Collection not found with handle: $handle');
      }
      
      final collection = Collection.fromJson(collectionData);
      return Success(collection);
    } on ShopifyException catch (e) {
      return Failure(e.message, e);
    } catch (e) {
      return Failure('Failed to get collection: ${e.toString()}');
    }
  }
}

/// Collection list with pagination info
class CollectionList {
  final List<Collection> collections;
  final PageInfo pageInfo;
  
  const CollectionList({
    required this.collections,
    required this.pageInfo,
  });
}