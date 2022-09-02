import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/domain/repositories/basket_repository.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:injectable/injectable.dart';

/// {@template add_to_basket}
/// Adds a product to the basket
/// {@endtemplate}
@injectable
class AddToBasket {
  final BasketRepository _repository;

  /// {@macro add_to_basket}
  const AddToBasket(this._repository);

  /// {@macro add_to_basket}
  Future<Either<Failure, List<BasketItem>>> call(Product product) =>
      _repository.addToBasket(product);
}
