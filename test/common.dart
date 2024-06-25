import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

DioException dioError() {
  return DioException(
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      data: <String, dynamic>{
        'message': 'message',
      },
      requestOptions: RequestOptions(path: 'path'),
    ),
    requestOptions: RequestOptions(path: 'path'),
  );
}

abstract class _ValueChanged<T> {
  void call(T value);
}

class MockValueChanged<T> extends Mock implements _ValueChanged<T> {}
