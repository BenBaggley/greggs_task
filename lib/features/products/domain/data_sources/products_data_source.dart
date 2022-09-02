import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/products/domain/entities/product.dart';

/// Data source interface for products data
abstract class ProductsDataSource {
  /// Gets a list of Greggs products
  Future<Either<Failure, List<Product>>> getProducts();
}
