// ignore_for_file: public_member_api_docs
// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:greggs/core/data/basket_storage.dart';
import 'package:greggs/core/data/mock_dio_adapter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiModule {
  @singleton
  @Named('base_url')
  String get baseUrl => 'https://www.greggs.co.uk/api/';

  BaseOptions getBaseOptions(
    @Named('base_url') String baseUrl,
  ) {
    return BaseOptions(
      baseUrl: baseUrl,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );
  }

  @singleton
  Dio getDio(BaseOptions baseOptions) {
    return Dio(baseOptions)
      ..interceptors.addAll([
        if (kDebugMode)
          LogInterceptor(
            requestHeader: true,
            responseHeader: true,
            requestBody: true,
            responseBody: true,
            logPrint: (o) => debugPrint(o.toString()),
          ),
      ]);
  }

  @singleton
  @preResolve
  Future<MockDioAdapter> getDioAdapter(
    Dio dio,
    BasketStorage storage,
  ) async {
    final adapter = MockDioAdapter(storage, dio: dio);
    await adapter.init();
    return adapter;
  }
}
