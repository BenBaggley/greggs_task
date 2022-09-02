import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/domain/repositories/basket_repository.dart';
import 'package:greggs/features/basket/domain/user_cases/remove_from_basket.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixtures.dart';

class MockBasketRepository extends Mock implements BasketRepository {}

void main() {
  group(RemoveFromBasket, () {
    late MockBasketRepository repository;
    late RemoveFromBasket removeFromBasket;

    final json = jsonArrayFixture('basket.json');
    final items = json.map((j) => BasketItem.fromJson(j)).toList();

    setUp(() {
      repository = MockBasketRepository();
      removeFromBasket = RemoveFromBasket(repository);

      registerFallbackValue(items.first.product);
    });

    test('success', () async {
      when(() => repository.removeFromBasket(any())).thenAnswer(
        (_) async => Right(items),
      );

      final result = await removeFromBasket(items.first.product);
      expect(result, equals(Right(items)));
    });

    test('failure', () async {
      when(() => repository.removeFromBasket(any())).thenAnswer(
        (_) async => const Left(Failure(message: 'message')),
      );

      final result = await removeFromBasket(items.first.product);
      expect(result, equals(const Left(Failure(message: 'message'))));
    });
  });
}
