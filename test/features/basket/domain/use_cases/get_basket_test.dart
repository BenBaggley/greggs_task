import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/core/domain/failure.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/domain/repositories/basket_repository.dart';
import 'package:greggs/features/basket/domain/user_cases/get_basket.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixtures.dart';

class MockBasketRepository extends Mock implements BasketRepository {}

void main() {
  group(GetBasket, () {
    late MockBasketRepository repository;
    late GetBasket getBasket;

    setUp(() {
      repository = MockBasketRepository();
      getBasket = GetBasket(repository);
    });

    test('success', () async {
      final json = jsonArrayFixture('basket.json');
      final items = json.map((j) => BasketItem.fromJson(j)).toList();

      when(() => repository.getBasket()).thenAnswer(
        (_) async => Right(items),
      );

      final result = await getBasket();
      expect(result, equals(Right(items)));
    });

    test('failure', () async {
      when(() => repository.getBasket()).thenAnswer(
        (_) async => const Left(Failure(message: 'message')),
      );

      final result = await getBasket();
      expect(result, equals(const Left(Failure(message: 'message'))));
    });
  });
}
