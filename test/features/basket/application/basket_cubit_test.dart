import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/core/data/mock_dio_adapter.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/application/cubit/basket_cubit.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/domain/user_cases/add_to_basket.dart';
import 'package:greggs/features/basket/domain/user_cases/get_basket.dart';
import 'package:greggs/features/basket/domain/user_cases/remove_from_basket.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixtures.dart';

class MockGetBasket extends Mock implements GetBasket {}

class MockAddToBasket extends Mock implements AddToBasket {}

class MockRemoveFromBasket extends Mock implements RemoveFromBasket {}

class MockMockDioAdapter extends Mock implements MockDioAdapter {}

void main() {
  group(BasketCubit, () {
    late MockGetBasket getBasket;
    late MockAddToBasket addToBasket;
    late MockRemoveFromBasket removeFromBasket;
    late MockMockDioAdapter mockDioAdapter;

    final json = jsonArrayFixture('basket.json');
    final items = json.map((j) => BasketItem.fromJson(j)).toList();

    setUp(() {
      getBasket = MockGetBasket();
      addToBasket = MockAddToBasket();
      removeFromBasket = MockRemoveFromBasket();
      mockDioAdapter = MockMockDioAdapter();

      when(() => mockDioAdapter.mockGet()).thenAnswer((_) {});
      when(() => mockDioAdapter.mockPut()).thenAnswer((_) {});
      when(() => mockDioAdapter.mockGet()).thenAnswer((_) {});
      registerFallbackValue(items.first.product);
    });

    test('initial state', () {
      final cubit = BasketCubit(
        getBasket,
        addToBasket,
        removeFromBasket,
        mockDioAdapter,
      );

      expect(cubit.state, equals(const BasketState.initial()));
    });

    blocTest<BasketCubit, BasketState>(
      'emits loading and data when loadBasket successful',
      setUp: () {
        when(() => getBasket()).thenAnswer(
          (_) async => Right(items),
        );
      },
      build: () => BasketCubit(
        getBasket,
        addToBasket,
        removeFromBasket,
        mockDioAdapter,
      ),
      act: (cubit) => cubit.loadBasket(),
      expect: () => [
        const BasketState.loading(),
        BasketState.data(items: items, totalPrice: 1.05),
      ],
      verify: (_) {
        verify(() => getBasket()).called(1);
      },
    );

    blocTest<BasketCubit, BasketState>(
      'emits loading and data when loadBasket unsuccessful',
      setUp: () {
        when(() => getBasket()).thenAnswer(
          (_) async => const Left(Failure(message: 'message')),
        );
      },
      build: () => BasketCubit(
        getBasket,
        addToBasket,
        removeFromBasket,
        mockDioAdapter,
      ),
      act: (cubit) => cubit.loadBasket(),
      expect: () => [
        const BasketState.loading(),
        const BasketState.failure('message'),
      ],
      verify: (_) {
        verify(() => getBasket()).called(1);
      },
    );

    blocTest<BasketCubit, BasketState>(
      'emits updating and data when addToBasket successful',
      setUp: () {
        when(() => addToBasket(any())).thenAnswer(
          (_) async => Right(items),
        );
      },
      build: () => BasketCubit(
        getBasket,
        addToBasket,
        removeFromBasket,
        mockDioAdapter,
      ),
      act: (cubit) => cubit.addToBasket(items.first.product),
      expect: () => [
        const BasketState.updating(),
        BasketState.data(items: items, totalPrice: 1.05),
      ],
      verify: (_) {
        verify(() => addToBasket(any())).called(1);
      },
    );

    blocTest<BasketCubit, BasketState>(
      'emits updating, failure, loading and data when addToBasket unsuccessful',
      setUp: () {
        when(() => addToBasket(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'message')),
        );
        when(() => getBasket()).thenAnswer(
          (_) async => Right(items),
        );
      },
      build: () => BasketCubit(
        getBasket,
        addToBasket,
        removeFromBasket,
        mockDioAdapter,
      ),
      act: (cubit) => cubit.addToBasket(items.first.product),
      expect: () => [
        const BasketState.updating(),
        const BasketState.failure('message'),
        const BasketState.loading(),
        BasketState.data(items: items, totalPrice: 1.05),
      ],
      verify: (_) {
        verify(() => addToBasket(any())).called(1);
        verify(() => getBasket()).called(1);
      },
    );

    blocTest<BasketCubit, BasketState>(
      'emits updating and data when removeFromBasket successful',
      setUp: () {
        when(() => removeFromBasket(any())).thenAnswer(
          (_) async => Right(items),
        );
      },
      build: () => BasketCubit(
        getBasket,
        addToBasket,
        removeFromBasket,
        mockDioAdapter,
      ),
      act: (cubit) => cubit.removeFromBasket(items.first),
      expect: () => [
        const BasketState.updating(),
        BasketState.data(items: items, totalPrice: 1.05),
      ],
      verify: (_) {
        verify(() => removeFromBasket(any())).called(1);
      },
    );

    blocTest<BasketCubit, BasketState>(
      'emits updating, failure, loading and data when removeFromBasket unsuccessful',
      setUp: () {
        when(() => removeFromBasket(any())).thenAnswer(
          (_) async => const Left(Failure(message: 'message')),
        );
        when(() => getBasket()).thenAnswer(
          (_) async => Right(items),
        );
      },
      build: () => BasketCubit(
        getBasket,
        addToBasket,
        removeFromBasket,
        mockDioAdapter,
      ),
      act: (cubit) => cubit.removeFromBasket(items.first),
      expect: () => [
        const BasketState.updating(),
        const BasketState.failure('message'),
        const BasketState.loading(),
        BasketState.data(items: items, totalPrice: 1.05),
      ],
      verify: (_) {
        verify(() => removeFromBasket(any())).called(1);
        verify(() => getBasket()).called(1);
      },
    );
  });
}
