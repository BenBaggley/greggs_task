import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:greggs/features/products/domain/repositories/products_repository.dart';
import 'package:greggs/features/products/domain/use_cases/get_products.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixtures.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  group(GetProducts, () {
    late MockProductsRepository repository;
    late GetProducts getProducts;

    setUp(() {
      repository = MockProductsRepository();
      getProducts = GetProducts(repository);
    });

    test('success', () async {
      final json = jsonArrayFixture('products.json');
      final products = json.map((j) => Product.fromJson(j)).toList();

      when(() => repository.getProducts()).thenAnswer(
        (_) async => Right(products),
      );

      final result = await getProducts();
      expect(result, equals(Right(products)));
    });

    test('failure', () async {
      when(() => repository.getProducts()).thenAnswer(
        (_) async => const Left(Failure(message: 'message')),
      );

      final result = await getProducts();
      expect(result, equals(const Left(Failure(message: 'message'))));
    });
  });
}
