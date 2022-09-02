import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:greggs/core/data/network_utils.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/domain/data_sources/basket_data_source.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:injectable/injectable.dart';

/// {@template default_basket_data_source}
/// Implementation of the [BasketDataSource] using [Dio]
/// {@endtemplate}
@Injectable(as: BasketDataSource)
class DefaultBasketDataSource implements BasketDataSource {
  final Dio _dio;

  /// {@macro default_basket_data_source}
  DefaultBasketDataSource(this._dio);

  @override
  Future<Either<Failure, List<BasketItem>>> getBasket() {
    return catchFailure(() async {
      final response = await _dio.get<List<dynamic>>('/basket');

      return response.data!.map((json) => BasketItem.fromJson(json)).toList();
    });
  }

  @override
  Future<Either<Failure, List<BasketItem>>> addToBasket(Product product) {
    return catchFailure(() async {
      final response = await _dio.put<List<dynamic>>(
        '/basket',
        queryParameters: {
          'articleCode': product.articleCode,
          'quantity': 1,
        },
      );
      return response.data!.map((json) => BasketItem.fromJson(json)).toList();
    });
  }

  @override
  Future<Either<Failure, List<BasketItem>>> removeFromBasket(Product product) {
    return catchFailure(() async {
      final response = await _dio.delete<List<dynamic>>(
        '/basket',
        queryParameters: {
          'articleCode': product.articleCode,
        },
      );

      return response.data!.map((json) => BasketItem.fromJson(json)).toList();
    });
  }
}
