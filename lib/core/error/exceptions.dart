class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}

class DatabaseException implements Exception {
  final String message;
  
  DatabaseException(this.message);
  
  @override
  String toString() => 'DatabaseException: $message';
}

class CacheException implements Exception {
  final String message;
  
  CacheException(this.message);
  
  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}