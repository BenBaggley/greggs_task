import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/products/domain/entities/product.dart';

/// Repository interface for shopping related operations
abstract class BasketRepository {
  /// Gets the current basket
  Future<Either<Failure, List<BasketItem>>> getBasket();

  /// Adds a product to the basket
  Future<Either<Failure, List<BasketItem>>> addToBasket(Product product);

  /// Removes a product from the basket
  Future<Either<Failure, List<BasketItem>>> removeFromBasket(Product product);
}
