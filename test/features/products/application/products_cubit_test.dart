import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/products/application/cubit/cubit/products_cubit.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:greggs/features/products/domain/use_cases/get_products.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixtures.dart';

class MockGetProducts extends Mock implements GetProducts {}

void main() {
  group(ProductsCubit, () {
    late MockGetProducts getProducts;

    setUp(() {
      getProducts = MockGetProducts();
    });

    test('initial state', () {
      final productsCubit = ProductsCubit(getProducts);
      expect(productsCubit.state, const ProductsState.initial());
    });

    final json = jsonArrayFixture('products.json');
    final products = json.map((j) => Product.fromJson(j)).toList();

    blocTest<ProductsCubit, ProductsState>(
      'loadProducts emits loading and data when successful',
      setUp: () {
        when(() => getProducts()).thenAnswer(
          (_) async => Right(products),
        );
      },
      build: () => ProductsCubit(getProducts),
      act: (cubit) => cubit.loadProducts(),
      expect: () => [
        const ProductsState.loading(),
        ProductsState.data(products),
      ],
      verify: (_) {
        verify(() => getProducts()).called(1);
      },
    );

    blocTest<ProductsCubit, ProductsState>(
      'loadProducts emits loading and failure when unsuccessful',
      setUp: () {
        when(() => getProducts()).thenAnswer(
          (_) async => const Left(Failure(message: 'message')),
        );
      },
      build: () => ProductsCubit(getProducts),
      act: (cubit) => cubit.loadProducts(),
      expect: () => [
        const ProductsState.loading(),
        const ProductsState.failure('message'),
      ],
      verify: (_) {
        verify(() => getProducts()).called(1);
      },
    );
  });
}
