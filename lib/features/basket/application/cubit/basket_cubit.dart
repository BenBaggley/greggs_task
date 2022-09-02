import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greggs/core/data/mock_dio_adapter.dart';
import 'package:greggs/features/basket/domain/entities/basket_item.dart';
import 'package:greggs/features/basket/domain/user_cases/add_to_basket.dart';
import 'package:greggs/features/basket/domain/user_cases/get_basket.dart';
import 'package:greggs/features/basket/domain/user_cases/remove_from_basket.dart';
import 'package:greggs/features/products/domain/entities/product.dart';
import 'package:injectable/injectable.dart';

part 'basket_state.dart';
part 'basket_cubit.freezed.dart';

/// {@template basket_cubit}
/// Cubit for the basket feature, handling state management
/// {@endtemplate}
@injectable
class BasketCubit extends Cubit<BasketState> {
  /// {@macro basket_cubit}
  BasketCubit(
    this._getBasket,
    this._addToBasket,
    this._removeFromBasket,
    this._dioAdapter,
  ) : super(const BasketState.initial());

  final GetBasket _getBasket;
  final AddToBasket _addToBasket;
  final RemoveFromBasket _removeFromBasket;
  final MockDioAdapter _dioAdapter;

  /// Loads the basket
  Future<void> loadBasket() async {
    emit(const BasketState.loading());

    _dioAdapter.mockGet();
    final result = await _getBasket();

    result.fold(
      (failure) => emit(BasketState.failure(failure.message)),
      (items) => emit(
        BasketState.data(
          items: items,
          totalPrice: _calculateTotal(items),
        ),
      ),
    );
  }

  /// Adds a product to the basket
  Future<void> addToBasket(Product product) async {
    emit(const BasketState.updating());

    _dioAdapter.mockPut();
    final result = await _addToBasket(product);

    result.fold(
      (f) {
        emit(BasketState.failure(f.message));
        loadBasket();
      },
      (items) => emit(
        BasketState.data(
          items: items,
          totalPrice: _calculateTotal(items),
        ),
      ),
    );
  }

  /// Removes a product from the basket
  Future<void> removeFromBasket(BasketItem item) async {
    emit(const BasketState.updating());

    _dioAdapter.mockDelete();
    final result = await _removeFromBasket(item.product);

    result.fold(
      (f) {
        emit(BasketState.failure(f.message));
        loadBasket();
      },
      (items) => emit(
        BasketState.data(
          items: items,
          totalPrice: _calculateTotal(items),
        ),
      ),
    );
  }

  num _calculateTotal(List<BasketItem> items) {
    return items
        .map((i) => i.product.eatOutPrice * i.quantity)
        .fold(0, (a, b) => a + b);
  }
}
