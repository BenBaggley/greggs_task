// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:greggs/core/domain/failure.dart';

/// Extension on [DioException] to parse errors and return [Failure]
extension DioExceptionX on DioException {
  /// Parses the error and returns a [Failure]
  Failure get asFailure {
    final response = this.response;
    if (type == DioExceptionType.badResponse && response != null) {
      final dynamic data = response.data;

      if (data is Map<String, dynamic>) {
        final message = data['message'] as String?;
        final code = data['code'] as int?;

        return Failure(message: message ?? 'Something went wrong', code: code);
      }
      return const Failure(message: 'Something went wrong');
    } else if (type == DioExceptionType.connectionTimeout) {
      return const Failure(message: 'The connection timed out');
    } else if (type == DioExceptionType.receiveTimeout) {
      return const Failure(message: 'The response timed out');
    } else if (type == DioExceptionType.sendTimeout) {
      return const Failure(message: 'The request timed out');
    } else if (type == DioExceptionType.cancel) {
      return const Failure(message: 'The request was cancelled');
    } else if (this.response == null) {
      return const Failure(message: 'You need to be online to use the app');
    } else {
      return Failure(message: error?.toString() ?? 'Something went wrong');
    }
  }
}
