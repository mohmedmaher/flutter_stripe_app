// error_handlers.dart
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class ErrorHandler {
  static String handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout occurred. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout occurred. Please try again.';
      case DioExceptionType.badResponse:
        return 'Error response: ${dioError.response?.data}';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
        return 'Something went wrong: ${dioError.message}';
      default:
        return 'Unexpected error: ${dioError.message}';
    }
  }

  static String handleStripeError(StripeException stripeError) {
    return 'Stripe error: ${stripeError.error.localizedMessage}';
  }

  static String handleGeneralError(dynamic error) {
    return 'An unexpected error occurred: $error';
  }
}
