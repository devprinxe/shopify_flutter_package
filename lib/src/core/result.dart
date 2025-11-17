import 'exceptions.dart';

/// Result type for better error handling without exceptions
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final ShopifyException? exception;

  const Failure(this.message, [this.exception]);
}

/// Extension methods for Result
extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  String? get errorOrNull => this is Failure<T> ? (this as Failure<T>).message : null;

  R when<R>({required R Function(T data) success, required R Function(String message, ShopifyException? exception) failure}) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      final fail = this as Failure<T>;
      return failure(fail.message, fail.exception);
    }
  }
}
