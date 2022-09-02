import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:greggs/core/data/basket_storage.dart';
import 'package:greggs/features/products/application/cubit/cubit/products_cubit.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:greggs/features/products/presentation/pages/products_page_widget.dart';
import 'package:greggs/features/products/presentation/widgets/product_item_widget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../fixtures/fixtures.dart';
import '../../../mock_router.dart';
import '../../../test_app.dart';

class MockProductsCubit extends MockCubit<ProductsState>
    implements ProductsCubit {}

class MockBasketStorage extends Mock implements BasketStorage {}

void main() {
  group(ProductsPageWidget, () {
    late MockProductsCubit cubit;
    late MockBasketStorage basketStorage;

    setUp(() {
      cubit = MockProductsCubit();
      basketStorage = MockBasketStorage();
      GetIt.I.registerSingleton<ProductsCubit>(cubit);
      GetIt.I.registerSingleton<BasketStorage>(basketStorage);
    });

    tearDown(() async {
      await GetIt.I.reset();
    });

    testWidgets(
      'displays loaded state',
      (tester) => mockNetworkImagesFor(() async {
        final json = jsonArrayFixture('products.json');
        final products = json.map((e) => Product.fromJson(e)).toList();

        final state = ProductsState.data(products);

        whenListen(cubit, Stream.value(state), initialState: state);
        when(() => cubit.loadProducts()).thenAnswer((_) => Future.value());
        when(() => basketStorage.itemCount).thenReturn(ValueNotifier(10));

        await tester.pumpApp(
          child: const ProductsPageWidget(),
        );

        await tester.pumpAndSettle();

        expect(find.byType(ProductItemWidget), findsNWidgets(products.length));
        expect(find.text('10'), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      }),
    );

    testWidgets('displays loading state', (tester) async {
      const state = ProductsState.loading();

      whenListen(cubit, Stream.value(state), initialState: state);
      when(() => cubit.loadProducts()).thenAnswer((_) => Future.value());
      when(() => basketStorage.itemCount).thenReturn(ValueNotifier(10));

      await tester.pumpApp(
        child: const ProductsPageWidget(),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays failure message in snackbar', (tester) async {
      final stateController = StreamController<ProductsState>();

      whenListen(
        cubit,
        stateController.stream,
        initialState: const ProductsState.initial(),
      );
      when(() => cubit.loadProducts()).thenAnswer((_) => Future.value());
      when(() => basketStorage.itemCount).thenReturn(ValueNotifier(10));

      await tester.pumpApp(
        child: const ProductsPageWidget(),
      );

      stateController.add(const ProductsState.failure('error'));

      await tester.pumpAndSettle();
      expect(find.widgetWithText(SnackBar, 'error'), findsOneWidget);
    });

    testWidgets('tapping basket icon navigates to basket', (tester) async {
      const state = ProductsState.initial();

      whenListen(cubit, Stream.value(state), initialState: state);
      when(() => cubit.loadProducts()).thenAnswer((_) => Future.value());
      when(() => basketStorage.itemCount).thenReturn(ValueNotifier(10));

      final router = MockRouter();
      when(() => router.push(any())).thenReturn(null);

      await tester.pumpRouterApp(
        child: const ProductsPageWidget(),
        router: router,
      );

      await tester.tap(find.byIcon(Icons.shopping_cart));
      verify(() => router.push('/basket'));
    });
  });
}
