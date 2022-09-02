// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:greggs/core/domain/failure.dart';

/// Extension on [DioError] to parse errors and return [Failure]
extension DioErrorX on DioError {
  /// Parses the error and returns a [Failure]
  Failure get asFailure {
    final response = this.response;
    if (type == DioErrorType.response && response != null) {
      final dynamic data = response.data;

      if (data is Map<String, dynamic>) {
        final message = data['message'] as String?;
        final code = data['code'] as int?;

        return Failure(message: message ?? 'Something went wrong', code: code);
      }
      return const Failure(message: 'Something went wrong');
    } else if (type == DioErrorType.connectTimeout) {
      return const Failure(message: 'The connection timed out');
    } else if (type == DioErrorType.receiveTimeout) {
      return const Failure(message: 'The response timed out');
    } else if (type == DioErrorType.sendTimeout) {
      return const Failure(message: 'The request timed out');
    } else if (type == DioErrorType.cancel) {
      return const Failure(message: 'The request was cancelled');
    } else if (this.response == null) {
      return const Failure(message: 'You need to be online to use the app');
    } else {
      return Failure(message: error?.toString() ?? 'Something went wrong');
    }
  }
}
