import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:greggs/core/data/network_utils.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/products/domain/data_sources/products_data_source.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:injectable/injectable.dart';

/// {@template default_products_data_source}
/// Default implementation of [ProductsDataSource] using [Dio]
/// {@endtemplate}
@Injectable(as: ProductsDataSource)
class DefaultProductsDataSource implements ProductsDataSource {
  final Dio _dio;

  /// {@macro default_products_data_source}
  DefaultProductsDataSource(this._dio);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    return catchFailure(() async {
      final response = await _dio.get<List<dynamic>>('/products');

      return response.data!.map((json) => Product.fromJson(json)).toList();
    });
  }
}
