import 'package:dartz/dartz.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:greggs/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

/// {@template get_products}
/// Gets a list of Greggs products
/// {@endtemplate}
@injectable
class GetProducts {
  final ProductsRepository _repository;

  /// {@macro get_products}
  const GetProducts(this._repository);

  /// {@macro get_products}
  Future<Either<Failure, List<Product>>> call() => _repository.getProducts();
}
