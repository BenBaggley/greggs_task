part of 'basket_cubit.dart';

/// States for the basket feature
@freezed
class BasketState with _$BasketState {
  /// Initial state
  const factory BasketState.initial() = BasketInitial;

  /// Loading state
  const factory BasketState.loading() = BasketLoading;

  /// Updating state
  const factory BasketState.updating() = BasketUpdating;

  /// Loaded state
  const factory BasketState.data({
    required List<BasketItem> items,
    required num totalPrice,
  }) = BasketData;

  /// Error state
  const factory BasketState.failure(String message) = BasketFailure;
}
