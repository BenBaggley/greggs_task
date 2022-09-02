import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/products/domain/data_sources/products_data_source.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:greggs/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

/// {@template default_products_repository}
/// Implementation of the [ProductsRepository] using [ProductsDataSource]
/// {@endtemplate}
@Injectable(as: ProductsRepository)
class DefaultProductsRepository implements ProductsRepository {
  final ProductsDataSource _productsDataSource;

  /// {@macro default_products_repository}
  const DefaultProductsRepository(this._productsDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts() =>
      _productsDataSource.getProducts();
}
