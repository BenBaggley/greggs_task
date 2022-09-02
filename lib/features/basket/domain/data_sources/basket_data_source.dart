import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/products/domain/entities/product.dart';

/// Data source interface for basket data
abstract class BasketDataSource {
  /// Gets the current basket
  Future<Either<Failure, List<BasketItem>>> getBasket();

  /// Adds a product to the basket
  Future<Either<Failure, List<BasketItem>>> addToBasket(Product product);

  /// Removes a product from the basket
  Future<Either<Failure, List<BasketItem>>> removeFromBasket(Product product);
}
