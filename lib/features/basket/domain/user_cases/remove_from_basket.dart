import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/domain/repositories/basket_repository.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:injectable/injectable.dart';

/// {@template remove_from_basket}
/// Removes a product from the basket
/// {@endtemplate}
@injectable
class RemoveFromBasket {
  final BasketRepository _repository;

  /// {@macro remove_from_basket}
  const RemoveFromBasket(this._repository);

  /// {@macro remove_from_basket}
  Future<Either<Failure, List<BasketItem>>> call(Product product) =>
      _repository.removeFromBasket(product);
}
