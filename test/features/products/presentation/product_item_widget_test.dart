import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:greggs/features/products/presentation/widgets/product_item_widget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../common.dart';
import '../../../fixtures/fixtures.dart';
import '../../../test_app.dart';

void main() {
  group(ProductItemWidget, () {
    final json = jsonArrayFixture('products.json').first;
    final product = Product.fromJson(json);

    testWidgets(
      'displays product detail',
      (tester) => mockNetworkImagesFor(() async {
        await tester.pumpApp(
          child: ProductItemWidget(
            product: product,
            onAddToBasket: (_) {},
          ),
        );

        const desc =
            'The Nation’s favourite Sausage Roll.\n\nMuch like Elvis was hailed the King of Rock, '
            'many have appointed Greggs as the (unofficial) King of Sausage Rolls.\n\nFreshly baked in our shops '
            'throughout the day, this British classic is made from seasoned sausage meat wrapped in layers of crisp, '
            'golden puff pastry, as well as a large dollop of TLC. It’s fair to say, we’re proper proud of them.\n\n'
            'And that’s it. No clever twist. No secret ingredient. It’s how you like them, so that’s how we make them.';

        expect(find.text('Sausage Roll'), findsOneWidget);
        expect(find.text(desc), findsOneWidget);
        expect(find.text('£1.05'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(
          find.widgetWithText(ElevatedButton, 'Add to Basket'),
          findsOneWidget,
        );
      }),
    );

    testWidgets(
      'remove button calls given callback',
      (tester) => mockNetworkImagesFor(() async {
        final onAdd = MockValueChanged<Product>();

        await tester.pumpApp(
          child: ProductItemWidget(
            product: product,
            onAddToBasket: onAdd,
          ),
        );

        await tester.tap(find.text('Add to Basket'));

        verify(() => onAdd(product)).called(1);
      }),
    );
  });
}
