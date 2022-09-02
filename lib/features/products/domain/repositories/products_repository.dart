import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/products/domain/entities/product.dart';

/// Repository interface for orders related operations
abstract class ProductsRepository {
  /// Gets a list of Greggs products
  Future<Either<Failure, List<Product>>> getProducts();
}
