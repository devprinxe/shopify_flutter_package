import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'exceptions.dart';

/// Secure storage wrapper following KISS principle
class StorageService {
  final FlutterSecureStorage _storage;
  
  static const String _customerTokenKey = 'shopify_customer_token';
  static const String _customerIdKey = 'shopify_customer_id';
  
  StorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();
  
  /// Save customer access token
  Future<void> saveCustomerToken(String token) async {
    try {
      await _storage.write(key: _customerTokenKey, value: token);
    } catch (e) {
      throw StorageException('Failed to save customer token', e);
    }
  }
  
  /// Get customer access token
  Future<String?> getCustomerToken() async {
    try {
      return await _storage.read(key: _customerTokenKey);
    } catch (e) {
      throw StorageException('Failed to read customer token', e);
    }
  }
  
  /// Delete customer access token
  Future<void> deleteCustomerToken() async {
    try {
      await _storage.delete(key: _customerTokenKey);
    } catch (e) {
      throw StorageException('Failed to delete customer token', e);
    }
  }
  
  /// Save customer ID
  Future<void> saveCustomerId(String id) async {
    try {
      await _storage.write(key: _customerIdKey, value: id);
    } catch (e) {
      throw StorageException('Failed to save customer ID', e);
    }
  }
  
  /// Get customer ID
  Future<String?> getCustomerId() async {
    try {
      return await _storage.read(key: _customerIdKey);
    } catch (e) {
      throw StorageException('Failed to read customer ID', e);
    }
  }
  
  /// Delete customer ID
  Future<void> deleteCustomerId() async {
    try {
      await _storage.delete(key: _customerIdKey);
    } catch (e) {
      throw StorageException('Failed to delete customer ID', e);
    }
  }
  
  /// Clear all stored data
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw StorageException('Failed to clear storage', e);
    }
  }
}