import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/domain/data_sources/basket_data_source.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/domain/repositories/basket_repository.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:injectable/injectable.dart';

/// {@default_template basket_repository}
/// Implementation of the [BasketRepository] using [BasketDataSource]
/// {@endtemplate}
@Injectable(as: BasketRepository)
class DefaultBasketRepository implements BasketRepository {
  final BasketDataSource _basketDataSource;

  /// {@macro basket_repository}
  const DefaultBasketRepository(this._basketDataSource);

  @override
  Future<Either<Failure, List<BasketItem>>> addToBasket(Product product) =>
      _basketDataSource.addToBasket(product);

  @override
  Future<Either<Failure, List<BasketItem>>> getBasket() =>
      _basketDataSource.getBasket();

  @override
  Future<Either<Failure, List<BasketItem>>> removeFromBasket(Product product) =>
      _basketDataSource.removeFromBasket(product);
}
