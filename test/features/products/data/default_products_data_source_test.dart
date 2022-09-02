import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/products/data/data_sources/default_products_data_source.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common.dart';
import '../../../fixtures/fixtures.dart';

void main() {
  group(DefaultProductsDataSource, () {
    late MockDio dio;
    late DefaultProductsDataSource dataSource;

    setUp(() {
      dio = MockDio();
      dataSource = DefaultProductsDataSource(dio);
    });

    group('getProducts', () {
      test('success', () async {
        final json = jsonArrayFixture('products.json');
        final products = json.map((j) => Product.fromJson(j)).toList();

        when(() => dio.get<List<dynamic>>('/products')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/products'),
            data: json,
          ),
        );

        final result = await dataSource.getProducts();

        expect(result.getOrElse(() => []), containsAll(products));
      });
      test('failure', () async {
        when(() => dio.get<List<dynamic>>('/products')).thenAnswer(
          (_) => Future.error(dioError()),
        );

        final result = await dataSource.getProducts();

        expect(result, equals(left(const Failure(message: 'message'))));
      });
    });
  });
}
