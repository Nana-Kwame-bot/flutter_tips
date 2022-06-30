import 'package:dio/dio.dart';

///[DioException] describes the error info when request fails.
class DioException implements Exception {
  const DioException([
    this.errorMessage = "Something went wrong",
  ]);

  factory DioException.fromDioError({required DioError dioError}) {
    switch (dioError.type) {
      case DioErrorType.connectTimeout:
        return DioException("Connection timed out");
      case DioErrorType.sendTimeout:
        return DioException("Request send timeout");
      case DioErrorType.receiveTimeout:
        return DioException("Receiving timeout occurred");
      case DioErrorType.response:
        return DioException(_handleStatusCode(dioError.response?.statusCode));
      case DioErrorType.cancel:
        return DioException("Request to the server was cancelled");
      case DioErrorType.other:
        if (dioError.message.contains('SocketException')) {
          return DioException(
            "No internet connection detected, please try again",
          );
        }
        return DioException("An unknown exception occurred");
      default:
        return const DioException();
    }
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Invalid request";
      case 401:
        return "Access denied";
      case 404:
        return "The requested information could not be found";
      case 409:
        return "Conflict occurred";
      case 500:
        return "Unknown error occurred, please try again later";
      default:
        return "Something went wrong";
    }
  }

  @override
  String toString() => "DioException: $errorMessage";

  /// The associated error message.
  final String errorMessage;
}
