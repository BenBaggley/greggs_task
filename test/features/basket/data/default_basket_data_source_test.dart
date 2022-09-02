import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/data/data_sources/default_basket_data_source.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common.dart';
import '../../../fixtures/fixtures.dart';

void main() {
  group(DefaultBasketDataSource, () {
    late MockDio dio;
    late DefaultBasketDataSource dataSource;

    setUp(() {
      dio = MockDio();
      dataSource = DefaultBasketDataSource(dio);
    });

    final json = jsonArrayFixture('basket.json');
    final basketItems = json.map((j) => BasketItem.fromJson(j)).toList();

    group('getBasket', () {
      test('success', () async {
        when(() => dio.get<List<dynamic>>('/basket')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/basket'),
            data: json,
          ),
        );

        final result = await dataSource.getBasket();

        expect(result.getOrElse(() => []), containsAll(basketItems));
      });

      test('failure', () async {
        when(() => dio.get<List<dynamic>>('/basket')).thenAnswer(
          (_) => Future.error(dioError()),
        );

        final result = await dataSource.getBasket();

        expect(result, equals(const Left(Failure(message: 'message'))));
      });
    });

    group('addToBasket', () {
      test('success', () async {
        when(() => dio.put<List<dynamic>>(
              '/basket',
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/basket'),
              data: json,
            ));

        final result = await dataSource.addToBasket(
          basketItems.first.product,
        );

        expect(result.getOrElse(() => []), containsAll(basketItems));
      });

      test('failure', () async {
        when(() => dio.put<List<dynamic>>(
              '/basket',
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) => Future.error(dioError()));

        final result = await dataSource.addToBasket(
          basketItems.first.product,
        );

        expect(result, equals(const Left(Failure(message: 'message'))));
      });
    });

    group('removeFromBasket', () {
      test('success', () async {
        when(() => dio.delete<List<dynamic>>(
              '/basket',
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/basket'),
              data: json,
            ));

        final result = await dataSource.removeFromBasket(
          basketItems.first.product,
        );

        expect(result.getOrElse(() => []), containsAll(basketItems));
      });

      test('failure', () async {
        when(() => dio.delete<List<dynamic>>(
              '/basket',
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) => Future.error(dioError()));

        final result = await dataSource.removeFromBasket(
          basketItems.first.product,
        );

        expect(result, equals(const Left(Failure(message: 'message'))));
      });
    });
  });
}
