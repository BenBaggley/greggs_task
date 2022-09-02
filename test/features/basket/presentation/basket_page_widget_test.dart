import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/features/basket/application/cubit/basket_cubit.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/presentation/pages/basket_page_widget.dart';
import 'package:greggs/features/basket/presentation/widgets/basket_item_widget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../fixtures/fixtures.dart';
import '../../../test_app.dart';

class MockBasketCubit extends MockCubit<BasketState> implements BasketCubit {}

void main() {
  group(BasketPageWidget, () {
    late MockBasketCubit cubit;

    setUp(() {
      cubit = MockBasketCubit();
    });

    testWidgets(
      'displays loaded state',
      (tester) => mockNetworkImagesFor(() async {
        final json = jsonArrayFixture('basket.json');
        final items = json.map((e) => BasketItem.fromJson(e)).toList();

        final state = BasketState.data(items: items, totalPrice: 10.00);

        whenListen(cubit, Stream.value(state), initialState: state);
        when(() => cubit.loadBasket()).thenAnswer((_) => Future.value());

        await tester.pumpApp(
          child: BlocProvider<BasketCubit>.value(
            value: cubit,
            child: const BasketPageWidget(),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(BasketItemWidget), findsNWidgets(items.length));
        expect(find.text('£10.00'), findsOneWidget);
      }),
    );

    testWidgets('displays loading state', (tester) async {
      const state = BasketState.loading();

      whenListen(cubit, Stream.value(state), initialState: state);
      when(() => cubit.loadBasket()).thenAnswer((_) => Future.value());

      await tester.pumpApp(
        child: BlocProvider<BasketCubit>.value(
          value: cubit,
          child: const BasketPageWidget(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays failure message in snackbar', (tester) async {
      final stateController = StreamController<BasketState>();

      whenListen(
        cubit,
        stateController.stream,
        initialState: const BasketState.initial(),
      );
      when(() => cubit.loadBasket()).thenAnswer((_) => Future.value());

      await tester.pumpApp(
        child: BlocProvider<BasketCubit>.value(
          value: cubit,
          child: const BasketPageWidget(),
        ),
      );

      stateController.add(const BasketState.failure('error'));

      await tester.pumpAndSettle();
      expect(find.widgetWithText(SnackBar, 'error'), findsOneWidget);
    });
  });
}
