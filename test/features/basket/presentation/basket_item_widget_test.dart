import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/presentation/widgets/basket_item_widget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../common.dart';
import '../../../fixtures/fixtures.dart';
import '../../../test_app.dart';

void main() {
  final json = jsonArrayFixture('basket.json').first;
  final item = BasketItem.fromJson(json);
  group(BasketItemWidget, () {
    testWidgets(
      'displays item detail',
      (tester) => mockNetworkImagesFor(() async {
        await tester.pumpApp(
          child: BasketItemWidget(
            item: item,
            onRemoveFromBasket: (_) {},
          ),
        );

        expect(find.text('Sausage Roll'), findsOneWidget);
        expect(find.text('1 x £1.05'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(
          find.widgetWithText(ElevatedButton, 'Remove from Basket'),
          findsOneWidget,
        );
      }),
    );

    testWidgets(
      'remove button calls given callback',
      (tester) => mockNetworkImagesFor(() async {
        final onRemove = MockValueChanged<BasketItem>();

        await tester.pumpApp(
          child: BasketItemWidget(
            item: item,
            onRemoveFromBasket: onRemove.call,
          ),
        );

        await tester.tap(find.text('Remove from Basket'));

        verify(() => onRemove(item)).called(1);
      }),
    );
  });
}
