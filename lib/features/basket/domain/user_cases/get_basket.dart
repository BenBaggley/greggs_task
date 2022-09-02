import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/domain/repositories/basket_repository.dart';
import 'package:injectable/injectable.dart';

/// {@template get_basket}
/// Gets the current basket
/// {@endtemplate}
@injectable
class GetBasket {
  final BasketRepository _repository;

  /// {@macro get_basket}
  const GetBasket(this._repository);

  /// {@macro get_basket}
  Future<Either<Failure, List<BasketItem>>> call() => _repository.getBasket();
}
